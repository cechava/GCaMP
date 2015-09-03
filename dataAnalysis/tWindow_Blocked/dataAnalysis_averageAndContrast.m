clear all
close all

sourceRoot='/media/cesar/1TB HD/Cesar/GCaMP/Projects/';
%projectID='Retinotopy/halfScreen_Blocked/UDLR/';
projectID='Retinotopy/5x4Grid/';
%projectID='SceneMatching/';
sessID='AH03_9_1';

analysisFolder=[sourceRoot,projectID,'Sessions/',sessID,'/Analyses/'];

runList=[1 3:9 11:16];
nRuns=length(runList);
%nCond=3;
%nCond=4;
%nCond=12;
nCond=20;

fwhm=0;
dsFactor=2;

sizeY=floor(164/dsFactor);
sizeX=floor(218/dsFactor);

% sizeY=floor(122/dsFactor);
% sizeX=floor(164/dsFactor);


%analysisRoot=[analysisFolder,'/Analysis_tWindow_M1_dsFactor',num2str(dsFactor),'_fwhm',num2str(fwhm)];
analysisRoot=[analysisFolder,'/Analysis_tWindow_M1_minusRollingMean_dsFactor',num2str(dsFactor),'_fwhm',num2str(fwhm)];
%analysisRoot=[analysisFolder,'/Analysis_tWindow_M1_hiPass_dsFactor',num2str(dsFactor),'_fwhm',num2str(fwhm)];


inDir=[analysisRoot,'/MidProcOutput/'];
outDir=[analysisRoot,'/AnalysisOutput/AllRuns/'];
%outDir=[analysisRoot,'/AnalysisOutput/Half2/'];
if isdir(outDir)==0
    mkdir(outDir)
end


observedRespAll=cell(1,nCond);


%*RETRIEVE*
for r = 1:nRuns
    run=runList(r);
    inFile=[inDir,sessID,'_run',num2str(run),'.mat'];
    load(inFile)
    for cond=1:nCond
        condInd=find(respCond==cond);
        observedRespAll{cond}=[observedRespAll{cond},observedResp(:,condInd)];
    end
end

%*AVERAGE*
observedRespMean=zeros(sizeY,sizeX,nCond);
for cond=1:nCond
    tmp=squeeze(mean(observedRespAll{cond},2));
    observedRespMean(:,:,cond)=reshape(tmp,sizeY,sizeX);
end

%*CONTRAST*

load([sourceRoot,projectID,'contrastDetials.mat']);

for c=1:length(contrastStruct)
    if sum(contrastStruct(c).minus)==0
        map=squeeze(observedRespMean(:,:,contrastStruct(c).plus));
    else
        map=squeeze(observedRespMean(:,:,contrastStruct(c).plus))-squeeze(observedRespMean(:,:,contrastStruct(c).minus));
    end
    outFile=[outDir,sessID,'_',contrastStruct(c).name,'_map.mat'];
    save(outFile,'map');
end
