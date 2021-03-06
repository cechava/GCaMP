%function dataAnalysis_tCourse_hiPass_perRun(run)
%run
run=2;

sourceRoot='/home/cesar/Documents/AutoFluorescence/Projects/';
projectID='Retinotopy/halfScreen_Blocked/UDLR/';
%projectID='Retinotopy/halfScreen_ER/UDLR/';
sessID='Jrat13_8_6';
%sessID='AF18_7_31';

dataFolder=[sourceRoot,projectID,'Sessions/',sessID,'/Data/'];
analysisFolder=[sourceRoot,projectID,'Sessions/',sessID,'/Analyses/'];

fwhm=0;
dsFactor=2;

% sizeY=floor(164/dsFactor);
% sizeX=floor(218/dsFactor);

sizeY=floor(122/dsFactor);
sizeX=floor(164/dsFactor);

outDir=[analysisFolder,'/Analysis_tCourse_hiPass_dsFactor',num2str(dsFactor),'_fwhm',num2str(fwhm),'/MidProcOutput/'];
if isdir(outDir)==0
    mkdir(outDir)
end


sourceDir=[dataFolder,'run',num2str(run),'/'];
frameSourceDir=[sourceDir,'frames/'];
planSourceDir=[sourceDir,'plan/'];

picList=dir([frameSourceDir,'*']);
nFrames=length(picList);

load([planSourceDir,'frameInfo.mat'])
frameCount=length(frameT);

%[frameCount,frameT,~]=getFrameTimes(planSourceDir);


[blockStartT,blockCond]=getBlockStartTimes(planSourceDir);

%*LOAD IN FRAMES*
frameArray=zeros(sizeY,sizeX,frameCount);


for frame=1:frameCount
    %frame
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
    
    
    [imSizeY,imSizeX]=size(im2);
    imTmp=[flip(flip(im2,1),2) flip(im2,1) flip(flip(im2,1),2);...
    flip(im2,2) im2 flip(im2,2);...
    flip(flip(im2,1),2) flip(im2,1) flip(flip(im2,1),2)];
    imLoTmp=conv2(imTmp,fspecial('average',[10/dsFactor 10/dsFactor]),'same');
    imLo=imLoTmp(imSizeY+1:2*imSizeY,imSizeX+1:2*imSizeX);
    im3=im2-imLo;

    


    
    if fwhm==0
        im4=im3;
    elseif fwhm==1
        %spatially smooth with a filter, fwhm = 3 pixels
        im4=imfilter(im3,fspecial('gaussian',[11 11],1),im3(1,1));
    elseif fwhm==2
        im4=imfilter(im3,fspecial('gaussian',[20 20],2),im3(1,1));
    elseif fwhm==3
        im4=imfilter(im3,fspecial('gaussian',[30 30],3),im3(1,1));
    elseif fwhm==4
        im4=imfilter(im3,fspecial('gaussian',[33 33],4),im3(1,1));
    end

    frameArray(:,:,frame)=im4;   
end
[sizeY,sizeX,sizeZ]=size(frameArray);
frameArray=reshape(frameArray,sizeX*sizeY,sizeZ);

%INTERPOLATE SAMPLE TO STEADY FRAME RATE
sampRate=1/60;
%sampRate=1/2;
newFrameT=frameT(1):sampRate:frameT(end);
frameArray=interp1(frameT',frameArray',newFrameT);
frameArray=frameArray';
frameT=newFrameT;
clear newFrameT

%DETREND
detrendedFrameArray=zeros(size(frameArray));
for pix=1:size(frameArray,1);
    meanVal=mean(frameArray(pix,:));
    detrendedFrameArray(pix,:)=detrend(frameArray(pix,:))+meanVal;
end
clear frameArray
%FOR EACH BLOCK: %GET SIGNAL 
priorTime=5;%secs before stim onset to consider for baseline
afterTime=19;%secs after stim onset to include in signal average
stimStart=blockStartT(blockCond~=0);

observedResp=zeros(size(detrendedFrameArray,1),length(stimStart),((priorTime+afterTime)*(1/sampRate)));
respCond=zeros(1,length(stimStart));

for i =1:length(stimStart)
    endInd=find(frameT>=(stimStart(i)+afterTime),1)-1;
    startInd=find(frameT>=(stimStart(i)-priorTime),1);   
    baselineEnd=find(frameT>=(stimStart(i)),1)-1;
    baselineVal=mean(detrendedFrameArray(:,startInd:baselineEnd),2); 
    baselineVal=repmat(baselineVal,1,length(startInd:endInd));
    observedResp(:,i,:)=((detrendedFrameArray(:,startInd:endInd)./baselineVal)-1)*100;

    respCond(i)=blockCond(2*i);
end
clear detrendedFrameArray




outFile=[outDir,sessID,'_run',num2str(run),'.mat'];
save(outFile,'respCond','observedResp','priorTime','afterTime','sampRate');

