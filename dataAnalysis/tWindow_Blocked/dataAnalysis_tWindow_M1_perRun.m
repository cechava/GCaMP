function dataAnalysis_tWindow_M1_perRun(run,sessID)
%method (M1): following the methods of Andermann et al 2011, fractional
%change between -2 
%run=2
run
sourceRoot='/home/cesar/Documents/GCaMP/Projects/';
%projectID='Retinotopy/halfScreen_Blocked/UDLR/';
projectID='Retinotopy/3x3Grid/';
%sessID='Jrat13_8_6';

dataFolder=[sourceRoot,projectID,'Sessions/',sessID,'/Data/'];
analysisFolder=[sourceRoot,projectID,'Sessions/',sessID,'/Analyses/'];

fwhm=0;
dsFactor=2;

sizeY=floor(164/dsFactor);
sizeX=floor(218/dsFactor);

% sizeY=floor(122/dsFactor);
% sizeX=floor(164/dsFactor);


outDir=[analysisFolder,'Analysis_tWindow_M1_dsFactor',num2str(dsFactor),'_fwhm',num2str(fwhm),'/MidProcOutput/'];
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
% sampRate=1/60;
% newFrameT=frameT(1):sampRate:frameT(end);
% frameArray=interp1(frameT',frameArray',

%DETREND
detrendedFrameArray=zeros(size(frameArray));
for pix=1:size(frameArray,1);
     meanVal=mean(frameArray(pix,:));
    detrendedFrameArray(pix,:)=detrend(frameArray(pix,:))+meanVal;
end
clear frameArray

%GET FRACTIONAL SIGNAL CHANGE
tWindow1Start_ASO=-2;%secs
tWindow1End_ASO=0;%secs
tWindow2Start_ASO=0;%secs
tWindow2End_ASO=10;%secs

stimStart=blockStartT(blockCond~=0);

observedResp=zeros(size(detrendedFrameArray,1),length(stimStart));
respCond=zeros(1,length(stimStart));

for i =1:length(stimStart)
    endInd=find(frameT>=(stimStart(i)+tWindow1End_ASO),1);
    startInd=find(frameT>=(stimStart(i)+tWindow1Start_ASO),1);
    tWindow1Val=mean(detrendedFrameArray(:,startInd:endInd),2); 
    
    endInd=find(frameT>=(stimStart(i)+tWindow2End_ASO),1);
    startInd=find(frameT>=(stimStart(i)+tWindow2Start_ASO),1);
    tWindow2Val=mean(detrendedFrameArray(:,startInd:endInd),2); 
    
    observedResp(:,i)=(((tWindow2Val-tWindow1Val)./tWindow1Val))*100;
    respCond(i)=blockCond(2*i);
    
end
clear detrendedFrameArray


outFile=[outDir,sessID,'_run',num2str(run),'.mat'];
save(outFile,'respCond','observedResp');

