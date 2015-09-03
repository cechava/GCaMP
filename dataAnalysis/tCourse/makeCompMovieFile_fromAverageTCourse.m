
clear all
close all

sourceRoot='/home/cesar/Documents/GCaMP/Projects/';
%projectID='Retinotopy/halfScreen_ER/UDLR/';
%projectID='Retinotopy/halfScreen_Blocked/UDLR/';
projectID='Retinotopy/3x3Grid/';
sessID='AH02_8_14';
%sessID='AF18_8_1';

dataFolder=[sourceRoot,projectID,'Sessions/',sessID,'/Data/'];
analysisFolder=[sourceRoot,projectID,'Sessions/',sessID,'/Analyses/'];

nCond=9;

frameRate=60;
% stimStartT=5;
% stimEndT=10;
stimStartT=2;
stimEndT=7;


stimStartFrame=frameRate*stimStartT;
stimEndFrame=frameRate*stimEndT;

fwhm=0;
dsFactor=2;

analysisRoot=[analysisFolder,'/Analysis_tCourse_dsFactor',num2str(dsFactor),'_fwhm',num2str(fwhm)];

inDir=[analysisRoot,'/AnalysisOutput/AllRuns/'];
outDir=[analysisRoot,'/Movies/AllRuns/'];

% inDir=[analysisRoot,'/AnalysisOutput/NoLight/'];
% outDir=[analysisRoot,'/Movies/NoLight/'];


% inDir=[analysisRoot,'/AnalysisOutput/NoScreen/'];
% outDir=[analysisRoot,'/Movies/NoScreen/'];
if isdir(outDir)==0
    mkdir(outDir)
end


for cond1=2:nCond
cond1
inFile=[inDir,sessID,'_condition',num2str(cond1),'_tCourse.mat'];
load(inFile,'observedRespMean')
frameArray=observedRespMean;
clear observedRespMean


 
frameArray1=((frameArray-min(frameArray(:)))/(max(frameArray(:))-min(frameArray(:))))*255;
[sizeY,sizeX,sizeZ]=size(frameArray1);
clear frameArray

    for cond2=cond1:9
        inFile=[inDir,sessID,'_condition',num2str(cond2),'_tCourse.mat'];
        load(inFile,'observedRespMean')
        frameArray=observedRespMean;
        clear observedRespMean

        outFile=[outDir,sessID,'_condition',num2str(cond1),'&',num2str(cond2),'.avi'];
        writerObj=VideoWriter(outFile);
        writerObj.FrameRate=frameRate;
        open(writerObj);

        frameArray2=((frameArray-min(frameArray(:)))/(max(frameArray(:))-min(frameArray(:))))*255;
        clear frameArray

        for f=1:sizeZ
            frame0=(frameArray1(:,:,f));
            frame1=(frameArray2(:,:,f));
            frame2=imfuse(uint8(frame0),uint8(frame1),'falsecolor','Scaling','independent','ColorChannels',[1 2 0]);
            if f>=stimStartFrame && f<stimEndFrame
                frame3=uint8(padarray(frame2,[4 4 0],uint8(255)));
            else
                frame3=uint8(padarray(frame2,[4 4 0],uint8(0)));
            end

            writeVideo(writerObj,frame3);
        end

        close(writerObj)
    end
end
