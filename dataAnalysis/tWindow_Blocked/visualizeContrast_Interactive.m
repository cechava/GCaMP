clear all
close all
sourceRoot='/home/cesar/Documents/AutoFluorescence/Projects/';
projectID='Retinotopy/halfScreen_Blocked/UDLR/';
sessID='Jrat13_8_10_s02';
analysisFolder=[sourceRoot,projectID,'Sessions/',sessID,'/Analyses/'];

dsFactor=2;
fwhm=0;

mapAnalysisID=['Analysis_tWindow_M1_dsFactor',num2str(dsFactor),'_fwhm',num2str(fwhm)];

imSizeY=122;
imSizeX=164;


sizeY=floor(imSizeY/dsFactor);
sizeX=floor(imSizeX/dsFactor);


anatSource=[sourceRoot,projectID,'Sessions/',sessID,'/Surface/'];
imSurf=double(imread([anatSource,'frame0.tiff']));
imSurf=imresize(imSurf,[sizeY,sizeX]);
imSurf=(imSurf/2^12)*2^8;
funcOverlayTmp=cat(3,imSurf,imSurf,imSurf);
[sizeY,sizeX,nChannels]=size(funcOverlayTmp);


mapDataDir=[analysisFolder,mapAnalysisID,'/AnalysisOutput/AllRuns/'];


load([sourceRoot,projectID,'contrastDetials.mat']);
nContrasts=length(contrastStruct);

c=6;
contrastStruct(c).name
spmFile=[mapDataDir,sessID,'_',contrastStruct(c).name,'_map.mat'];
load(spmFile);
map=imresize(map,[sizeY,sizeX]);
funcOverlay=funcOverlayTmp;

threshMin=.1*max(abs(map(:)));
threshMax=.8*max((abs(map(:))));

threshList=linspace(threshMin,threshMax,8);

tickDisplay={};
tickCount=1;
tmp=flipdim(threshList,2);
for i=1:7:8
    tickDisplay{tickCount}=num2str(-tmp(i));
    tickCount=tickCount+1;
end
for i=1:7:8
    tickDisplay{tickCount}=num2str(threshList(i));
    tickCount=tickCount+1;
end

colorOverlayNeg=[0 0 .25;0 0 .5;0 0 .75; 0 0 1; 0 .25 1; 0 .5 1;0 .75 1; 0 1 1];
colorOverlayPos=[.25 0 0;.5 0 0;.75 0 0; 1 0 0; 1 .25 0; 1 .5 0;1 .75 0; 1 1 0];
    cMap=[flip(colorOverlayNeg,1); .5 .5 .5; colorOverlayPos];


%COOL COLORS
for t=1:length(threshList)-1
    colorInd=find(map>-threshList(t+1) & map<=-threshList(t));
    for channel=1:nChannels
        imTemp=squeeze(funcOverlay(:,:,channel));
        imTemp(colorInd)=colorOverlayNeg(t,channel)*(2^8);
        funcOverlay(:,:,channel)=imTemp;
    end
end

colorInd=find(map<=-threshList(t+1));
for channel=1:nChannels
    imTemp=squeeze(funcOverlay(:,:,channel));
    imTemp(colorInd)=colorOverlayNeg(t+1,channel)*(2^8);
    funcOverlay(:,:,channel)=imTemp;
end

%WAqRM COLORS
for t=1:length(threshList)-1
    colorInd=find(map<threshList(t+1) & map>=threshList(t));
    for channel=1:nChannels
        imTemp=squeeze(funcOverlay(:,:,channel));
        imTemp(colorInd)=colorOverlayPos(t,channel)*(2^8);
        funcOverlay(:,:,channel)=imTemp;
    end
end

colorInd=find(map>=threshList(t+1));
for channel=1:nChannels
    imTemp=squeeze(funcOverlay(:,:,channel));
    imTemp(colorInd)=colorOverlayPos(t+1,channel)*(2^8);
    funcOverlay(:,:,channel)=imTemp;
end

figure(2)

f1=figure(1);imshow(uint8(funcOverlay));
colormap(cMap);
h=colorbar;
set(h,'ylim',[0 1],'Ticks',[.045 .4 .59 .96],'TickLabels',tickDisplay)
dcm_obj = datacursormode;


timeAnalysisRoot=[analysisFolder,'/Analysis_tCourse_dsFactor',num2str(dsFactor),'_fwhm',num2str(fwhm)];
timeDir=[timeAnalysisRoot,'/AnalysisOutput/AllRuns/'];
nCond=4;

while(1)
    k=waitforbuttonpress ;   
    if k==0
        info_struct = getCursorInfo(dcm_obj);
        pixY=info_struct.Position(2);
        pixX=info_struct.Position(1);
        getPixelTimeCourse(timeDir,sessID,nCond,pixX,pixY)
        set(0,'currentfigure',f1);
        clc
    else
        break
    end
end



