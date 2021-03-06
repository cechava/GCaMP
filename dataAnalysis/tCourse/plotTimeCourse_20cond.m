clear all
%close all

sourceRoot='/media/cesar/1TB HD/Cesar/GCaMP/Projects/';
%projectID='Retinotopy/halfScreen_ER/UDLR/';
projectID='Retinotopy/5x4Grid/';
%sessID='AF18_8_1';
sessID='AH03_9_1';

dataFolder=[sourceRoot,projectID,'Sessions/',sessID,'/Data/'];
analysisFolder=[sourceRoot,projectID,'Sessions/',sessID,'/Analyses/'];


nCond=20;
frameRate=1/60;
fwhm=0;
dsFactor=2;
%analysisRoot=[analysisFolder,'/Analysis_tCourse_dsFactor',num2str(dsFactor),'_fwhm',num2str(fwhm)];
analysisRoot=[analysisFolder,'/Analysis_tCourse_minusRollingMean_dsFactor',num2str(dsFactor),'_fwhm',num2str(fwhm)];

inDir=[analysisRoot,'/AnalysisOutput/AllRuns/'];
%inDir=[analysisRoot,'/AnalysisOutput/NoScreen/'];
%inDir=[analysisRoot,'/AnalysisOutput/NoLight/'];

%  
% pixY=1;
% pixX=1;
% % 
% pixY=39;
% pixX=10;
% % % 
% pixY=30;
% pixX=15;

pixY=60;
pixX=70;


figure;
hold all
for cond=1:nCond
    load([inDir,sessID,'_condition',num2str(cond),'_tCourse.mat']);
    frameT_ASO=0:frameRate:(priorTime+afterTime)-frameRate;
    frameT_ASO=frameT_ASO-priorTime;
    h(cond)=subplot(4,5,cond);
    hold all
    shadedErrorBar(frameT_ASO,squeeze(observedRespMean(pixY,pixX,:)),squeeze(observedRespSE(pixY,pixX,:)),'-b')
    line([0 0],get(h(cond),'Ylim'),'Color',[0 0 0])
    set(gca,'FontSize',16)
    xlabel('Time ASO (secs)','FontSize',20)
    ylabel('Fractional Signal Change','FontSize',20)
end