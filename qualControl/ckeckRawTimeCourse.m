clear all
close all

sourceRoot='/media/cesar/My Passport1/CoxLab/Retinotopy/halfScreen_ER/UDLR/Data/';
sessID='AH02_8_12_s02';
run=1;

sizeY=122;
sizeX=164;

frameRate=180;%fps
timeToLoad=60;%secs
framesToLoad=frameRate*timeToLoad;


sourceFolder=dir([sourceRoot,sessID,'/',sessID,'_run',num2str(run),'_*']);
sourceDir=[sourceRoot,sessID,'/',sourceFolder(1).name,'/'];
frameSourceDir=[sourceDir,'frames/'];
planSourceDir=[sourceDir,'plan/'];

[~,frameT,frameCond] = getFrameTimes(planSourceDir);
frameCount=length(frameT);
%*LOAD IN FRAMES*
frameArray=zeros(sizeY,sizeX,framesToLoad);


for frame=1:framesToLoad
    if mod(frame-1,frameRate)==0
        secondsLoaded=floor((frame-1)/frameRate)
    end
%    frame
    im0=double(imread([frameSourceDir,'frame',num2str(frame-1),'.tiff']));
%     if size(im0,3)>1
%         im0=mean(im0,3);
%     end
    frameArray(:,:,frame)=im0; 
    
  
end

[sizeY,sizeX,sizeZ]=size(frameArray);
frameArrayNorm=((frameArray-min(frameArray(:)))/(max(frameArray(:))-min(frameArray(:))))*255;
frameArray=reshape(frameArray,sizeX*sizeY,sizeZ);

meanF=squeeze(mean(frameArray,1));

figure;plot(frameT(1:framesToLoad),frameArray(4096,1:framesToLoad));

figure;plot(frameT(1:framesToLoad),meanF);


outFile='rawDataMovie.avi';
writerObj=VideoWriter(outFile);
writerObj.FrameRate=frameRate;
open(writerObj);

stimStartT=15:20:timeToLoad;
stimEndT=stimStartT+5;

stimStartFrame=frameRate*stimStartT;
stimEndFrame=frameRate*stimEndT;
 

[sizeY,sizeX,sizeZ]=size(frameArrayNorm);

for f=1:sizeZ
    frame0=(frameArrayNorm(:,:,f));
%     if f>=stimStartFrame & f<stimEndFrame
%         frame1=uint8(padarray(frame0,[4 4],255));
%     else
         frame1=uint8(padarray(frame0,[4 4],0));
%     end
    writeVideo(writerObj,frame1);
end

close(writerObj)

% frameArray=reshape(frameArray,sizeY,sizeX,sizeZ);
% frameSD=squeeze(std(frameArray,0,3));
% 
% frameArray=reshape(frameArray,sizeX*sizeY,sizeZ);
% for pix=1:sizeY*sizeX
% tmp(pix,:)=conv(frameArray(pix,:),fspecial('average',[1 90]),'same');
% end
% tmp=reshape(tmp,sizeY,sizeX,sizeZ);