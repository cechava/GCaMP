clear all
close all

sourceRoot='/media/cesar/1TB HD/Cesar/GCaMP/Projects/';
%projectID='Retinotopy/halfScreen_ER/UDLR/';
%projectID='Retinotopy/halfScreen_Blocked/UDLR/';
projectID='Retinotopy/5x4Grid/';
%projectID='SceneMatching/';
sessID='AH03_9_1';
%sessID='AH02_8_16';
%sessID='AF18_8_1';

analysisFolder=[sourceRoot,projectID,'Sessions/',sessID,'/Analyses/'];

runList=[1 3:9 11:16];
%runList=1:8;
%runList=13:14;
nRuns=length(runList);
%nCond=3;
nCond=20;
%nCond=12;

fwhm=0;
dsFactor=2;
sizeY=floor(164/dsFactor);
sizeX=floor(218/dsFactor);
% 
% sizeY=floor(122/dsFactor);
% sizeX=floor(164/dsFactor);



analysisRoot=[analysisFolder,'/Analysis_tWindow_M2_minusRollingMean_dsFactor',num2str(dsFactor),'_fwhm',num2str(fwhm)];

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
    baseRespMean=squeeze(mean(baseRespAll,2));
    stimRespMean=squeeze(mean(stimRespAll,2));
    
    baseMean=mean(baseRespMean,2);
    baseMean=repmat(baseMean,1,nTimePoints2);
    baseSD=std(baseRespMean,0,2);
    baseSD=repmat(baseSD,1,nTimePoints2);
    
    zScoredStimResp=(stimRespMean-baseMean)./baseSD;
    
    %%*For maps showing Z-score respect to noise*
%    
%     observedResp=mean(zScoredStimResp,2);
%     map=reshape(observedResp,sizeY,sizeX);
%     outFile=[outDir,sessID,'_condition',num2str(cond),'_map.mat'];
    
    %%*Z-score maps*
    observedResp=mean(zScoredStimResp,2);
    observedResp(observedResp<=0)=0;
    if std(observedResp)==0
        observedRespS=zeros(size(observedResp));
    else
        observedRespS=(observedResp-mean(observedResp))/std(observedResp);
    end
    map=reshape(observedRespS,sizeY,sizeX);
    outFile=[outDir,sessID,'_condition',num2str(cond),'_ZScoredmap.mat'];
    
    %%*Normalize maps
%     observedResp=mean(zScoredStimResp,2);
%     observedRespN=(observedResp-min(observedResp(:)))/(max(observedResp(:))-min(observedResp(:)));
%     map=reshape(observedRespN,sizeY,sizeX);
%     outFile=[outDir,sessID,'_condition',num2str(cond),'_normMap.mat'];
    
    
    save(outFile,'map');
end

 