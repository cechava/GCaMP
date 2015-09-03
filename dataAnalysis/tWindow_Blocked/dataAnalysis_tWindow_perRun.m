function dataAnalysis_tWindow_perRun(run)
%run=2
run
sourceRoot='/home/cesar/Documents/IntrinsicImaging/Projects/';
projectID='Retinotopy/halfScreen_ER/UDLR/';
%sessID='AF19_7_21';
sessID='AG02_7_24';
dataFolder=[sourceRoot,projectID,'Sessions/',sessID,'/Data/'];
analysisFolder=[sourceRoot,projectID,'Sessions/',sessID,'/Analyses/'];

fwhm=0;
dsFactor=2;

sizeY=floor(164/dsFactor);
sizeX=floor(218/dsFactor);


outDir=[analysisFolder,'Analysis_tWindow_dsFactor',num2str(dsFactor),'_fwhm',num2str(fwhm),'/MidProcOutput/'];
if isdir(outDir)==0
    mkdir(outDir)
end

sourceDir=[dataFolder,'run',num2str(run),'/'];
frameSourceDir=[sourceDir,'frames/'];
planSourceDir=[sourceDir,'plan/'];



load([planSourceDir,'frameInfo.mat'])
frameCount=length(frameT);
[blockStartT,blockCond]=getBlockStartTimes(planSourceDir);


%*LOAD IN FRAMES*
frameArray=zeros(sizeY,sizeX,length(frameT));


for frame=1:frameCount
%    frame
    im0=double(imread([frameSourceDir,'frame',num2str(frame-1),'.tiff']));
    if size(im0,3)>1
        im0=mean(im0,3);
    end
    im0=(im0/((2^12)-1))*100;
    
    
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

%INTERPOLATE SAMPLE TO STEADY FRAME RATE
sampRate=1/60;
newFrameT=frameT(1):sampRate:frameT(end);
frameArray=interp1(frameT',frameArray',newFrameT);
frameArray=frameArray';
frameT=newFrameT;
clear newFrameT

%DETREND
detrendedFrameArray=zeros(size(frameArray));
for pix=1:size(frameArray,1);
    detrendedFrameArray(pix,:)=detrend(frameArray(pix,:));
end
clear frameArray
%FOR EACH BLOCK: 1) SUBTRACT BASELINE 2)GET AVERAGE SIGNAL
baselineStart=5;%secs before stim onset to consider for baseline
tWindowStart_ASO=2;%secs
tWindowEnd_ASO=5;%secs
stimStart=blockStartT(blockCond~=0);
blankStart=blockStartT(blockCond==0);

observedResp=zeros(size(detrendedFrameArray,1),length(stimStart));
respCond=zeros(1,length(stimStart));
nSamples=zeros(1,length(stimStart));

for i =1:length(stimStart)
    %BASELINE
    endInd=find(frameT>=stimStart(i),1)-1;
    startInd=find(frameT>=(stimStart(i)-baselineStart),1);
    baselineVal=mean(detrendedFrameArray(:,startInd:endInd),2); 
    %RESPONSE
    endInd=find(frameT>=(stimStart(i)+tWindowEnd_ASO),1);
    startInd=find(frameT>=(stimStart(i)+tWindowStart_ASO),1);
    respVal=mean(detrendedFrameArray(:,startInd:endInd),2); 
    observedResp(:,i)=respVal-baselineVal;
    respCond(i)=blockCond(2*i);
    
end
clear detrendedFrameArray


outFile=[outDir,sessID,'_run',num2str(run),'.mat'];
save(outFile,'respCond','observedResp');

