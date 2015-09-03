clear all
close all


sourceRoot='/media/cesar/My Passport1/CoxLab/Retinotopy/5x4Grid/Data/';
%sourceRoot='/media/cesar/My Passport1/CoxLab/SceneMatching/Data/';
sessID='AH03_9_1';


%targetRoot='/home/cesar/Documents/AutoFluorescence/Projects/';
targetRoot='/media/cesar/1TB HD/Cesar/GCaMP/Projects/';
%projectID='Retinotopy/halfScreen_Blocked/UDLR/';
projectID='Retinotopy/5x4Grid/';
%projectID='SceneMatching/';

targetDir=[targetRoot,projectID,'Sessions/',sessID,'/Surface/'];
if isdir(targetDir)==0
    mkdir(targetDir)
end

sourceDir=dir([sourceRoot,sessID,'/',sessID,'_surface*']);
sourceDir=[sourceRoot,sessID,'/',sourceDir(1).name,'/Surface/'];
picList=dir([sourceDir,'*.tiff']);
nPics=length(picList);

imAll=[];
for pic=1:nPics
    im0=double(imread([sourceDir,'frame',num2str(pic-1),'.tiff']));
    imAll=cat(3,imAll,im0);
end

imAvg=squeeze(mean(imAll,3));


imwrite(uint16(imAvg),[targetDir,'frame0.tiff'],'TIFF')

imwrite(uint16((imAvg/(2^12))*2^16),[targetDir,'16bitSurf.tif'],'TIFF')

