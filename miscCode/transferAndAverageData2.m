clear all
close all

sourceRoot='/media/cesar/My Passport/CoxLab/Retinotopy/halfScreen_ER/UDLR/Data/';
%sessID='AF18_8_1';
sessID='Jrat13_8_6';
runList=1:14;

targetRoot='/home/cesar/Documents/AutoFluorescence/Projects/';
projectID='Retinotopy/halfScreen_Blocked/UDLR/';
targetFolder=[targetRoot,projectID,'Sessions/',sessID,'/Data2/'];

for r=1:length(runList)
    run=runList(r)
    sourceFolder=dir([sourceRoot,sessID,'/',sessID,'_run',num2str(run),'_*']);
    
    %average and transfer frames
    sourceDir=[sourceRoot,sessID,'/',sourceFolder(1).name,'/frames/'];

    targetDir=[targetFolder,'run',num2str(run),'/frames/'];
    if isdir(targetDir)==0
        mkdir(targetDir)
    end
     picList=dir([sourceDir,'/*.tiff']);
     nPics=length(picList);
    
    newPicCount=0;
    for pic=1:18:nPics-1
        if (nPics-1)-pic+1>=18
            pic2Average=18;
        else
            pics2Average=(nPics-1)-pic+1;
        end
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
    sourceDir=[sourceRoot,sessID,'/',sourceFolder(1).name,'/plan/'];
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