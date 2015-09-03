clear all
close all

sourceRoot='/media/cesar/1TB HD/Cesar/GCaMP/Projects/';
%projectID='Retinotopy/halfScreen_ER/UDLR/';
%projectID='Retinotopy/halfScreen_Blocked/UDLR/';
projectID='Retinotopy/5x4Grid/';
%projectID='SceneMatching/';
sessID='AH03_9_1';
%sessID='AF18_8_1';

analysisFolder=[sourceRoot,projectID,'Sessions/',sessID,'/Analyses/'];

runList=[1 3:9 11:16];
%runList=13:14;
nRuns=length(runList);
%nCond=3;
%nCond=9;
%nCond=12;
nCond=20;

fwhm=0;
dsFactor=2;
sizeY=floor(164/dsFactor);
sizeX=floor(218/dsFactor);
% 
% sizeY=floor(122/dsFactor);
% sizeX=floor(164/dsFactor);

%analysisRoot=[analysisFolder,'/Analysis_tCourse_dsFactor',num2str(dsFactor),'_fwhm',num2str(fwhm)];
analysisRoot=[analysisFolder,'/Analysis_tCourse_minusRollingMean_dsFactor',num2str(dsFactor),'_fwhm',num2str(fwhm)];
%analysisRoot=[analysisFolder,'/Analysis_tCourse_bandPass_dsFactor',num2str(dsFactor),'_fwhm',num2str(fwhm)];



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
    observedRespAll=[];
    for r = 1:nRuns
        run=runList(r)
        inFile=[inDir,sessID,'_run',num2str(run),'.mat'];
        load(inFile)
        condInd=find(respCond==cond);
        observedRespAll=[observedRespAll,observedResp(:,condInd,:)];
    end
   
    %*AVERAGE*
    nTimePoints=(priorTime+afterTime)*(1/sampRate);
    tmp=squeeze(mean(observedRespAll,2));
    observedRespMean=reshape(tmp,sizeY,sizeX,nTimePoints);
    tmp=squeeze(std(observedRespAll,0,2))/sqrt(size(observedRespAll,2));
    %tmp=squeeze(std(observedRespAll,0,2));
    observedRespSE=reshape(tmp,sizeY,sizeX,nTimePoints);
    
    outFile=[outDir,sessID,'_condition',num2str(cond),'_tCourse.mat'];
    save(outFile,'observedRespMean','observedRespSE','priorTime','afterTime','sampRate');
end



