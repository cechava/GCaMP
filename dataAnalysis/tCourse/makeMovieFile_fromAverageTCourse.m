
clear all
close all

sourceRoot='/media/cesar/1TB HD/Cesar/GCaMP/Projects/';
%projectID='Retinotopy/halfScreen_ER/UDLR/';
%projectID='Retinotopy/halfScreen_Blocked/UDLR/';
projectID='Retinotopy/5x4Grid/';
%projectID='SceneMatching/';
sessID='AH03_9_1';
%sessID='AF18_8_1';

dataFolder=[sourceRoot,projectID,'Sessions/',sessID,'/Data/'];
analysisFolder=[sourceRoot,projectID,'Sessions/',sessID,'/Analyses/'];

%nCond=9;
nCond=20;

frameRate=60;
% stimStartT=5;
% stimEndT=10;
stimStartT=2;
stimEndT=7;
% stimStartT=2;
% stimEndT=12;


stimStartFrame=frameRate*stimStartT;
stimEndFrame=frameRate*stimEndT;

fwhm=0;
dsFactor=2;

%analysisRoot=[analysisFolder,'/Analysis_tCourse_dsFactor',num2str(dsFactor),'_fwhm',num2str(fwhm)];
analysisRoot=[analysisFolder,'/Analysis_tCourse_minusRollingMean_dsFactor',num2str(dsFactor),'_fwhm',num2str(fwhm)];

inDir=[analysisRoot,'/AnalysisOutput/AllRuns/'];
outDir=[analysisRoot,'/Movies/AllRuns/'];

% inDir=[analysisRoot,'/AnalysisOutput/NoLight/'];
% outDir=[analysisRoot,'/Movies/NoLight/'];


% inDir=[analysisRoot,'/AnalysisOutput/NoScreen/'];
% outDir=[analysisRoot,'/Movies/NoScreen/'];
if isdir(outDir)==0
    mkdir(outDir)
end


for cond=1:nCond
cond
inFile=[inDir,sessID,'_condition',num2str(cond),'_tCourse.mat'];
load(inFile,'observedRespMean')
frameArray=observedRespMean;
clear observedRespMean

outFile=[outDir,sessID,'_condition',num2str(cond),'.avi'];
writerObj=VideoWriter(outFile);
writerObj.FrameRate=frameRate;
open(writerObj);
 
frameArray=((frameArray-min(frameArray(:)))/(max(frameArray(:))-min(frameArray(:))))*255;
[sizeY,sizeX,sizeZ]=size(frameArray);

for f=1:sizeZ
    frame0=(frameArray(:,:,f));
    if f>=stimStartFrame && f<stimEndFrame
        frame1=uint8(padarray(frame0,[4 4],255));
    else
        frame1=uint8(padarray(frame0,[4 4],0));
    end
    writeVideo(writerObj,frame1);
end

close(writerObj)
end
