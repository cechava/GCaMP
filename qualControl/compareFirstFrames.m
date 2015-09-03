clear all
close all

%sourceRoot='/media/cesar/TeraLacie/';

sourceRoot='/media/cesar/1TB HD/Cesar/GCaMP/Projects/';
%projectID='Retinotopy/halfScreen_ER/UDLR/';
%projectID='Retinotopy/halfScreen_Blocked/UDLR/';
projectID='Retinotopy/5x4Grid/';
%projectID='SceneMatching/';
sessID='AH03_9_1';

dataFolder=[sourceRoot,projectID,'Sessions/',sessID,'/Data/'];
targetFolder=[sourceRoot,projectID,'/Sessions/',sessID,'/QualControl/Figures/'];
if isdir(targetFolder)==0
    mkdir(targetFolder)
end


runList=[1 3:9 11:16];

pixMat=[];

for r=1:length(runList)
    run=runList(r);
    sourceDir=[dataFolder,'run',num2str(run),'/frames/'];
    
    im0=double(imread([sourceDir,'frame0.tiff']));
    pixMat=[pixMat im0(:)];
end

R=corr(pixMat);

h=figure;
imagesc(R)
colorbar
saveas(h,[targetFolder,'1stFrameCorrMatrixAcrossRuns.tif']);