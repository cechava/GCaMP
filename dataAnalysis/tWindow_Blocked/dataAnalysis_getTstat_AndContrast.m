clear all
close all

sourceRoot='/media/cesar/1TB HD/Cesar/GCaMP/Projects/';
%projectID='Retinotopy/halfScreen_Blocked/UDLR/';
projectID='Retinotopy/3x3Grid/';
%projectID='SceneMatching/';
sessID='AH02_8_14';

analysisFolder=[sourceRoot,projectID,'Sessions/',sessID,'/Analyses/'];

runList=1:8;
%runList=1:16;
nRuns=length(runList);
nCond=9;
%nCond=12;

fwhm=0;
dsFactor=2;

sizeY=floor(164/dsFactor);
sizeX=floor(218/dsFactor);

% sizeY=floor(122/dsFactor);
% sizeX=floor(164/dsFactor);


analysisRoot=[analysisFolder,'/Analysis_tWindow_M1_dsFactor',num2str(dsFactor),'_fwhm',num2str(fwhm)];
%analysisRoot=[analysisFolder,'/Analysis_tWindow_M1_minusRollingMean_dsFactor',num2str(dsFactor),'_fwhm',num2str(fwhm)];
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


%*CONTRAST*

load([sourceRoot,projectID,'contrastDetials.mat']);

for c=1:length(contrastStruct)
    if sum(contrastStruct(c).minus)==0
        [H,P,CI,STATS]=ttest(observedRespAll{contrastStruct(c).plus}');
        pixStats=STATS.tstat';
        map=reshape(pixStats,sizeY,sizeX);
    else
        [H,P,CI,STATS]=ttest(observedRespAll{contrastStruct(c).plus}',observedRespAll{contrastStruct(c).minus}');
        pixStats=STATS.tstat';
        map=reshape(pixStats,sizeY,sizeX);
    end
    outFile=[outDir,sessID,'_',contrastStruct(c).name,'_SPM.mat'];
    save(outFile,'map');
end
