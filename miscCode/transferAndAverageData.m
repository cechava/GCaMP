clear all
close all

sourceRoot='/media/cesar/My Passport1/CoxLab/';
%sourceRoot='/media/cesar/My Passport1/CoxLab/SceneMatching/Data/';
%sessID='AF18_8_1';
sessID='AH03_9_1';
runList=[1 3:9 11:16];
%runList=1:8;

targetRoot='/media/cesar/1TB HD/Cesar/GCaMP/Projects/';
projectID='Retinotopy/5x4Grid/';
%projectID='SceneMatching/';
targetFolder=[targetRoot,projectID,'Sessions/',sessID,'/Data/'];

for r=1:length(runList)
    run=runList(r)
    sourceFolder=dir([sourceRoot,projectID,'Data/',sessID,'/',sessID,'_run',num2str(run),'_*']);
    
    %average and transfer frames
    sourceDir=[sourceRoot,projectID,'Data/',sessID,'/',sourceFolder(1).name,'/frames/'];

    targetDir=[targetFolder,'run',num2str(run),'/frames/'];
    if isdir(targetDir)==0
        mkdir(targetDir)
    end
     picList=dir([sourceDir,'/*.tiff']);
     nPics=length(picList);
    
    newPicCount=0;
    for pic=1:3:nPics-1
        im0=double(imread([sourceDir,'frame',num2str(pic-1),'.tiff']));
        im1=double(imread([sourceDir,'frame',num2str(pic),'.tiff']));
        if pic+1<=nPics-1
            im2=double(imread([sourceDir,'frame',num2str(pic+1),'.tiff']));
            imNew=squeeze(mean(cat(3,im0,im1,im2),3));
        else
            imNew=squeeze(mean(cat(3,im0,im1),3));
        end
        
        frame=imNew;
        imwrite(uint16(imNew),[targetDir,'frame',num2str(newPicCount),'.tiff'],'TIFF');
        newPicCount=newPicCount+1;
    end
    
    %transfer text data
    sourceDir=[sourceRoot,projectID,'Data/',sessID,'/',sourceFolder(1).name,'/plan/'];
    targetDir=[targetFolder,'run',num2str(run),'/plan/'];
    if isdir(targetDir)==0
        mkdir(targetDir)
    end
    
    [~,frameT,frameCond] = getFrameTimes(sourceDir);
    
    frameT=frameT(2:3:nPics);
    frameCond=frameCond(2:3:nPics);
    frameCount=length(2:3:nPics);
    
    save([targetDir,'frameInfo'],'frameT','frameCond','frameCount');
    
    copyfile([sourceDir,'expPlan.txt'],[targetDir,'expPlan.txt']);
    copyfile([sourceDir,'blockParadigm.txt'],[targetDir,'blockParadigm.txt']);
end