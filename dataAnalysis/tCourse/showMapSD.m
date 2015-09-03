clear all
close all

sourceRoot='/media/cesar/1TB HD/Cesar/GCaMP/Projects/';
%projectID='Retinotopy/halfScreen_ER/UDLR/';
%projectID='Retinotopy/halfScreen_Blocked/UDLR/';
projectID='Retinotopy/5x4Grid/';
%projectID='SceneMatching/';
%sessID='AF18_8_1';
%sessID='AH02_8_12_s04';
sessID='AH03_9_1';

dataFolder=[sourceRoot,projectID,'Sessions/',sessID,'/Data/'];
analysisFolder=[sourceRoot,projectID,'Sessions/',sessID,'/Analyses/'];


nCond=20;
fwhm=0;
dsFactor=2;
%analysisRoot=[analysisFolder,'/Analysis_tCourse_dsFactor',num2str(dsFactor),'_fwhm',num2str(fwhm)];
analysisRoot=[analysisFolder,'/Analysis_tCourse_minusRollingMean_dsFactor',num2str(dsFactor),'_fwhm',num2str(fwhm)];

inDir=[analysisRoot,'/AnalysisOutput/AllRuns/'];
%inDir=[analysisRoot,'/AnalysisOutput/NoScreen/'];
%inDir=[analysisRoot,'/AnalysisOutput/NoLight/'];
outDir=[analysisRoot,'/Figures/'];

if isdir(outDir)==0
    mkdir(outDir)
end


for cond=1:nCond
    load([inDir,sessID,'_condition',num2str(cond),'_tCourse.mat']);
    mapSD=squeeze(std(observedRespMean,0,3));
    
    h=figure;
    imagesc(mapSD)
    colormap('jet')
    colorbar
    saveas(h,[outDir,'SDmap_condition',num2str(cond),'.tif']);
end