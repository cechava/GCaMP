function dataAnalysis_tWindow_M2_minusRollingMean_perRun(projectID,sessID,run,tWindow1Start_ASO,tWindow1End_ASO,tWindow2Start_ASO,tWindow2End_ASO)
%method (M2): roughyl following Gias et al methods
%sessID='AH02_8_16';
%run=2;
run
sourceRoot='/media/cesar/1TB HD/Cesar/GCaMP/Projects/';
%projectID='Retinotopy/halfScreen_Blocked/UDLR/';
%projectID='Retinotopy/4x3Grid/';
%sessID='Jrat13_8_6';

% tWindow1Start_ASO=-2;%secs
% tWindow1End_ASO=0;%secs
% tWindow2Start_ASO=0;%secs
% tWindow2End_ASO=5;%secs

dataFolder=[sourceRoot,projectID,'/Sessions/',sessID,'/Data/'];
analysisFolder=[sourceRoot,projectID,'/Sessions/',sessID,'/Analyses/'];

fwhm=0;
dsFactor=2;

sizeY=floor(164/dsFactor);
sizeX=floor(218/dsFactor);

% sizeY=floor(122/dsFactor);
% sizeX=floor(164/dsFactor);


outDir=[analysisFolder,'Analysis_tWindow_M2_minusRollingMean_dsFactor',num2str(dsFactor),'_fwhm',num2str(fwhm),'/MidProcOutput/'];
if isdir(outDir)==0
    mkdir(outDir)
end

sourceDir=[dataFolder,'run',num2str(run),'/'];
frameSourceDir=[sourceDir,'frames/'];
planSourceDir=[sourceDir,'plan/'];



load([planSourceDir,'frameInfo.mat'])
frameCount=length(frameT);

%[frameCount,frameT,~]=getFrameTimes(planSourceDir);
[blockStartT,blockCond]=getBlockStartTimes(planSourceDir);


%*LOAD IN FRAMES*
frameArray=zeros(sizeY,sizeX,frameCount);


for frame=1:frameCount
%    frame
    im0=double(imread([frameSourceDir,'frame',num2str(frame-1),'.tiff']));
    if size(im0,3)>1
        im0=mean(im0,3);
    end
    
    
    %DOWNSAMPLE IMAGE IF NECESSARY (AFTER BLOCK AVERAGING)
    if dsFactor==1
        im2=im0;
    else
        im1=conv2(im0,fspecial('average',[dsFactor dsFactor]));
        im1=im1(1:size(im0,1),1:size(im0,2));
        im2=im1(dsFactor:dsFactor:end,dsFactor:dsFactor:end);
    end
    
    if fwhm==0
        im3=im2;
    elseif fwhm==1
        %spatially smooth with a filter, fwhm = 3 pixels
        im3=imfilter(im2,fspecial('gaussian',[11 11],1),im2(1,1));
    elseif fwhm==3
        im3=imfilter(im2,fspecial('gaussian',[30 30],3),im2(1,1));
    elseif fwhm==4
        im3=imfilter(im2,fspecial('gaussian',[33 33],4),im2(1,1));
    end

    frameArray(:,:,frame)=im3;   
end
[sizeY,sizeX,sizeZ]=size(frameArray);
frameArray=reshape(frameArray,sizeX*sizeY,sizeZ);

% %INTERPOLATE SAMPLE TO STEADY FRAME RATE
sampRate=1/60;
newFrameT=frameT(1):sampRate:frameT(end);
frameArray=interp1(frameT',frameArray',newFrameT);
frameArray=frameArray';
frameT=newFrameT;
clear newFrameT

%Remove Rolling Average
detrendedFrameArray=zeros(size(frameArray));
framesToAvg=(1/sampRate)*((tWindow2End_ASO-tWindow1Start_ASO)*2);
for pix=1:size(frameArray,1);
    meanVal=mean(frameArray(pix,:),2);
    tmp0=frameArray(pix,:);
    tmp1=padarray(tmp0,[0 framesToAvg],tmp0(1),'pre');
    tmp1=padarray(tmp1,[0 framesToAvg],tmp0(end),'post');
    rollingAvg=conv(tmp1,fspecial('average',[1 framesToAvg]),'same');%average over 20 secs
    rollingAvg=rollingAvg(framesToAvg+1:end-framesToAvg);
    detrendedFrameArray(pix,:)=tmp0-rollingAvg+meanVal;
end
clear frameArray

%GET FRACTIONAL SIGNAL CHANGE


stimStart=blockStartT(blockCond~=0);


baseResp=zeros(size(detrendedFrameArray,1),length(stimStart),((1/sampRate)*(tWindow1End_ASO-tWindow1Start_ASO)+1));
stimResp=zeros(size(detrendedFrameArray,1),length(stimStart),((1/sampRate)*(tWindow2End_ASO-tWindow2Start_ASO)+1));


respCond=zeros(1,length(stimStart));

for i =1:length(stimStart)
    endInd=find(frameT>=(stimStart(i)+tWindow1End_ASO),1);
    startInd=find(frameT>=(stimStart(i)+tWindow1Start_ASO),1);
    baseResp(:,i,:)=detrendedFrameArray(:,startInd:endInd); 

    
    endInd=find(frameT>=(stimStart(i)+tWindow2End_ASO),1);
    startInd=find(frameT>=(stimStart(i)+tWindow2Start_ASO),1);
    stimResp(:,i,:)=detrendedFrameArray(:,startInd:endInd); 
    
    respCond(i)=blockCond(2*i);
    
end
clear detrendedFrameArray


outFile=[outDir,sessID,'_run',num2str(run),'.mat'];
save(outFile,'respCond','baseResp','stimResp','sampRate','tWindow1End_ASO','tWindow2End_ASO','tWindow1Start_ASO','tWindow2Start_ASO');

