clear all
close all


%sourceRoot='/home/cesar/Documents/GCaMP/Projects/';
sourceRoot='/media/cesar/1TB HD/Cesar/GCaMP/Projects/';
targetRoot=sourceRoot;

projectID='Retinotopy/5x4Grid/';
%projectID='SceneMatching/';
sessID='AH03_9_1';
dataFolder=[sourceRoot,projectID,'/Sessions/',sessID,'/Data/'];
targetFolder=[targetRoot,projectID,'/Sessions/',sessID,'/QualControl/Figures/'];
if isdir(targetFolder)==0
    mkdir(targetFolder)
end
    
runList=[1 3:9 11:16];
sizeY=164;
sizeX=218;

frameRate=60;%fps


for run = runList
    sourceDir=[dataFolder,'run',num2str(run),'/'];
    frameSourceDir=[sourceDir,'frames/'];
    planSourceDir=[sourceDir,'plan/'];

    load([planSourceDir,'frameInfo.mat'])
    frameCount=length(frameT);
    %*LOAD IN FRAMES*
    frameArray=zeros(sizeY,sizeX,length(frameT));


    for frame=1:length(frameT)
        if mod(frame-1,frameRate)==0
            secondsLoaded=floor((frame-1)/frameRate)
        end
    %    frame
        im0=double(imread([frameSourceDir,'frame',num2str(frame-1),'.tiff']));
        if size(im0,3)>1
            im0=mean(im0,3);
        end
        frameArray(:,:,frame)=im0; 


    end

    [sizeY,sizeX,sizeZ]=size(frameArray);
   
    frameArray=reshape(frameArray,sizeX*sizeY,sizeZ);

    meanF=squeeze(mean(frameArray,1));
    
    [blockStartT,blockCond]=getBlockStartTimes(planSourceDir);
    stimStart=blockStartT(blockCond~=0);
    stimEnd=stimStart+10;
    
    randPix=randi(sizeX*sizeY);
    h=figure('visible','off');
    hold all;
    plot(frameT,frameArray(randPix,:));
    line([stimStart stimStart],get(gca,'Ylim'),'Color',[1 0 0])
    line([stimEnd stimEnd],get(gca,'Ylim'),'Color',[0 0 0])
    set(gca,'FontSize',16)
    xlabel('Time (secs)','FontSize',20)
    ylabel('Raw Signal','FontSize',20)
    title(['Pixel ',num2str(randPix),' TimeCourse'],'FontSize',18)
    saveas(h,[targetFolder,'randomPixelTimeCourse_run',num2str(run),'.tiff'])
    
    
    close all
    

    h2=figure('visible','off');hold all;
    plot(frameT,meanF);
    line([stimStart stimStart],get(gca,'Ylim'),'Color',[1 0 0])
    line([stimEnd stimEnd],get(gca,'Ylim'),'Color',[0 0 0])
    set(gca,'FontSize',16)
    xlabel('Time (secs)','FontSize',20)
    ylabel('Raw Signal','FontSize',20)
    title('All Pixel Average TimeCourse','FontSize',18)
    saveas(h2,[targetFolder,'AvgPixelTimeCourse_run',num2str(run),'.tiff'])
    close all
    
end


