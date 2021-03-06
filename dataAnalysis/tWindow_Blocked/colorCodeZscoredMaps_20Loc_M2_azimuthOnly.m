clear all
close all

sourceRoot='/media/cesar/1TB HD/Cesar/GCaMP/Projects/';
%projectID='Retinotopy/halfScreen_Blocked/UDLR/';
projectID='Retinotopy/5x4Grid/';
sessID='AH03_9_1';

analysisFolder=[sourceRoot,projectID,'Sessions/',sessID,'/Analyses/'];

dsFactor=2;
fwhm=0;

%analysisID=['Analysis_tWindow_M1_dsFactor',num2str(dsFactor),'_fwhm',num2str(fwhm)];
analysisID=['Analysis_tWindow_M2_minusRollingMean_dsFactor',num2str(dsFactor),'_fwhm',num2str(fwhm)];
%analysisID=['Analysis_tWindow_M1_hiPass_dsFactor',num2str(dsFactor),'_fwhm',num2str(fwhm)];

anatSource=[sourceRoot,projectID,'Sessions/',sessID,'/Surface/'];
imSurf=double(imread([anatSource,'frame0.tiff']));
imSurf=(imSurf/2^12)*2^8;
codedImg=cat(3,imSurf,imSurf,imSurf);
[sizeY,sizeX,nChannels]=size(codedImg);

resultsDir=[analysisFolder,analysisID,'/AnalysisOutput/AllRuns/'];
outDir=[analysisFolder,analysisID,'/Figures/AllRuns/ZscoredMap/'];

if isdir(outDir)==0
    mkdir(outDir)
end




load([sourceRoot,projectID,'contrastDetials.mat']);
nCond=20;%length(contrastStruct);

allMaps=zeros(sizeY,sizeX,nCond);

for c=1:nCond
    mapFile=[resultsDir,sessID,'_condition',num2str(c),'_ZScoredmap.mat'];
    load(mapFile);
    map=imresize(map,[sizeY,sizeX]);
    allMaps(:,:,c)=map;
end

%*SET THRESHHOLD*
thresh=1;%-Inf;
allMaps(allMaps<thresh)=0;
sumSigMaps=squeeze(sum(allMaps,3));

%*FIND MAXIMUM POSITION FOR EACH PIXEL*
[maxVal,maxPos]=max(allMaps,[],3);

%*COLOR CODE PIXELS
maxPos(sumSigMaps==0)=0;



% colorCode=[127 0 127;127 0 127;127 0 127;127 0 127;127 0 127;...
%     127 85 127;127 85 127;127 85 127;127 85 127;127 85 127;...
%     127 190 127;127 190 127;127 190 127;127 190 127;127 190 127;...
%     127 255 127;127 255 127;127 255 127;127 255 127;127 255 127;];


colorCode=[255 0 0;255 100 127;127 0 127;127 0 255;0 0 255;...
    255 0 0;255 100 127;127 0 127;127 0 255;0 0 255;...
    255 0 0;255 100 127;127 0 127;127 0 255;0 0 255;...
    255 0 0;255 100 127;127 0 127;127 0 255;0 0 255;];


for dim=1:3
    imDim=squeeze(codedImg(:,:,dim));
    for pos=1:nCond
        imDim(maxPos==pos)=colorCode(pos,dim);
    end
    codedImg(:,:,dim)=imDim;
end

figure;imshow(uint8(codedImg))

%*MAKE LEGEND*
count=1;
legend=zeros(300,300,3);
for y=1:4
    Y1=(100*(y-1))+1;
    Y2=Y1+99;
    for x=1:5
        X1=(100*(x-1))+1;
        X2=X1+99;
        for dim=1:3
            legend(Y1:Y2,X1:X2,dim)=colorCode(count,dim);
        end
        count=count+1;
    end
end

imwrite(uint8(codedImg),[outDir,'colorCodedAzimuthMap_tresh',num2str(thresh),'.tif'],'TIFF')

figure;imshow(uint8(legend))
imwrite(uint8(legend),[outDir,'colorCodeAzimuthLegend.tif'],'TIFF')
