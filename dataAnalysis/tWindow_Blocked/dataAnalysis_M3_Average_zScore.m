clear all
close all

sourceRoot='/media/cesar/1TB HD/Cesar/GCaMP/Projects/';
%projectID='Retinotopy/halfScreen_ER/UDLR/';
%projectID='Retinotopy/halfScreen_Blocked/UDLR/';
projectID='Retinotopy/4x3Grid/';
%projectID='SceneMatching/';
%sessID='AH02_8_14';
sessID='AH02_8_16';
%sessID='AF18_8_1';

analysisFolder=[sourceRoot,projectID,'Sessions/',sessID,'/Analyses/'];

runList=1:8;
%runList=13:14;
nRuns=length(runList);
%nCond=3;
nCond=9;
%nCond=12;

fwhm=0;
dsFactor=2;
sizeY=floor(164/dsFactor);
sizeX=floor(218/dsFactor);
% 
% sizeY=floor(122/dsFactor);
% sizeX=floor(164/dsFactor);



analysisRoot=[analysisFolder,'/Analysis_tWindow_M3_minusRollingMean_dsFactor',num2str(dsFactor),'_fwhm',num2str(fwhm)];

inDir=[analysisRoot,'/MidProcOutput/'];
outDir=[analysisRoot,'/AnalysisOutput/AllRuns/'];
%outDir=[analysisRoot,'/AnalysisOutput/NoLight/'];
%outDir=[analysisRoot,'/AnalysisOutput/NoScreen/'];

if isdir(outDir)==0
    mkdir(outDir)
end




for cond=1:nCond
    cond
    
%*RETRIEVE*
    baseRespAll=[];
    stimRespAll=[];
    for r = 1:nRuns
        run=runList(r)
        inFile=[inDir,sessID,'_run',num2str(run),'.mat'];
        load(inFile)
        condInd=find(respCond==cond);
        baseRespAll=[baseRespAll,baseResp(:,condInd,:)];
        stimRespAll=[stimRespAll,stimResp(:,condInd,:)];
    end
   
    %*AVERAGE*
    nTimePoints=(1/sampRate)*(tWindow1End_ASO-tWindow1Start_ASO)+1;
    nTimePoints2=(1/sampRate)*(tWindow2End_ASO-tWindow2Start_ASO)+1;
    baseRespMean=squeeze(mean(baseRespAll,3));%avg over tWindow
    stimRespMean=squeeze(mean(stimRespAll,3));%avg over tWindow
    
    baseMean=mean(baseRespMean,2);
    baseSD=std(baseRespMean,0,2);
    
    zScoredStimResp=(stimRespMean-baseMean)./baseSD;
    
    observedResp=mean(zScoredStimResp,2);
    
    
    map=reshape(observedResp,sizeY,sizeX);
    
    
    outFile=[outDir,sessID,'_condition',num2str(cond),'_map.mat'];
    save(outFile,'map');
end

 