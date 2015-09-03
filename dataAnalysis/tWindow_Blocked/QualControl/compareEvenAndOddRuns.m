clear all
close all

sourceRoot='/media/cesar/1TB HD/Cesar/GCaMP/Projects/';
%projectID='Retinotopy/halfScreen_Blocked/UDLR/';
projectID='Retinotopy/4x3Grid/';
sessID='AH02_8_16';
analysisFolder=[sourceRoot,projectID,'Sessions/',sessID,'/Analyses/'];

fwhm=0;
dsFactor=2;
%analysisID=['Analysis_tWindow_M1_dsFactor',num2str(dsFactor),'_fwhm',num2str(fwhm)];
analysisID=['Analysis_tWindow_M1_minusRollingMean_dsFactor',num2str(dsFactor),'_fwhm',num2str(fwhm)];
%analysisID=['Analysis_tWindow_M1_hiPass_dsFactor',num2str(dsFactor),'_fwhm',num2str(fwhm)];

resultsDir1=[analysisFolder,analysisID,'/AnalysisOutput/Half1/'];
resultsDir2=[analysisFolder,analysisID,'/AnalysisOutput/Half2/'];

load([sourceRoot,projectID,'contrastDetials.mat']);
nContrasts=12;%length(contrastStruct);

mapCorr=zeros(1,nContrasts);

for c=1:nContrasts
    spmFile1=[resultsDir1,sessID,'_',contrastStruct(c).name,'_map.mat'];
    load(spmFile1);
    mapData=map(:);
    
    spmFile2=[resultsDir2,sessID,'_',contrastStruct(c).name,'_map.mat'];
    load(spmFile2);
    mapData=[mapData map(:)];
    
    Rmatrix=corr(mapData);
   % Rmatrix=corr(mapData,'type','Spearman');
    mapCorr(c)=Rmatrix(1,2);
end
mapCorr
meanCorr=mean(mapCorr)