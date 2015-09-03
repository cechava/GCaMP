clear all
close all

sourceRoot='/media/cesar/1TB HD/Cesar/GCaMP/Projects/';
%projectID='Retinotopy/halfScreen_Blocked/UDLR/';
projectID='Retinotopy/3x3Grid/';
%projectID='SceneMatching/';
sessID='AH02_8_14';

analysisFolder=[sourceRoot,projectID,'Sessions/',sessID,'/Analyses/'];

dsFactor=2;
fwhm=0;

analysisID=['Analysis_tWindow_M1_dsFactor',num2str(dsFactor),'_fwhm',num2str(fwhm)];
%analysisID=['Analysis_tWindow_M1_minusRollingMean_dsFactor',num2str(dsFactor),'_fwhm',num2str(fwhm)];
%analysisID=['Analysis_tWindow_M1_hiPass_dsFactor',num2str(dsFactor),'_fwhm',num2str(fwhm)];

anatSource=[sourceRoot,projectID,'Sessions/',sessID,'/Surface/'];
imSurf=double(imread([anatSource,'frame0.tiff']));
imSurf=(imSurf/2^12)*2^8;
funcOverlayTmp=cat(3,imSurf,imSurf,imSurf);
[sizeY,sizeX,nChannels]=size(funcOverlayTmp);


resultsDir=[analysisFolder,analysisID,'/AnalysisOutput/AllRuns/'];
outDir=[analysisFolder,analysisID,'/Figures/AllRuns/fromSPM/'];
% 
% resultsDir=[analysisFolder,analysisID,'/AnalysisOutput/Half1/'];
% outDir=[analysisFolder,analysisID,'/Figures/Half1/'];


if isdir(outDir)==0
    mkdir(outDir)
end

load([sourceRoot,projectID,'contrastDetials.mat']);
nContrasts=length(contrastStruct);

for c=1:nContrasts
    mapFile=[resultsDir,sessID,'_',contrastStruct(c).name,'_SPM.mat'];
    load(mapFile);
    map=imresize(map,[sizeY,sizeX]);
    funcOverlay=funcOverlayTmp;
    
    threshMin=1.35;
%    threshMax=5;
%     threshMin=.1*max((abs(map(:))));
     threshMax=.8*max((abs(map(:))));
     
     if threshMin<threshMax

        threshList=linspace(threshMin,threshMax,8);

        tickDisplay={};
        tickCount=1;
        tmp=flipdim(threshList,2);
        for i=1:7:8
            tickDisplay{tickCount}=num2str(-tmp(i));
            tickCount=tickCount+1;
        end
        for i=1:7:8
            tickDisplay{tickCount}=num2str(threshList(i));
            tickCount=tickCount+1;
        end

        colorOverlayNeg=[0 0 .25;0 0 .5;0 0 .75; 0 0 1; 0 .25 1; 0 .5 1;0 .75 1; 0 1 1];
        colorOverlayPos=[.25 0 0;.5 0 0;.75 0 0; 1 0 0; 1 .25 0; 1 .5 0;1 .75 0; 1 1 0];
        cMap=[flip(colorOverlayNeg,1); .5 .5 .5; colorOverlayPos];



        %COOL COLORS
        for t=1:length(threshList)-1
            colorInd=find(map>-threshList(t+1) & map<=-threshList(t));
            for channel=1:nChannels
                imTemp=squeeze(funcOverlay(:,:,channel));
                imTemp(colorInd)=colorOverlayNeg(t,channel)*(2^8);
                funcOverlay(:,:,channel)=imTemp;
            end
        end

        colorInd=find(map<=-threshList(t+1));
        for channel=1:nChannels
            imTemp=squeeze(funcOverlay(:,:,channel));
            imTemp(colorInd)=colorOverlayNeg(t+1,channel)*(2^8);
            funcOverlay(:,:,channel)=imTemp;
        end

        %WAqRM COLORS
        for t=1:length(threshList)-1
            colorInd=find(map<threshList(t+1) & map>=threshList(t));
            for channel=1:nChannels
                imTemp=squeeze(funcOverlay(:,:,channel));
                imTemp(colorInd)=colorOverlayPos(t,channel)*(2^8);
                funcOverlay(:,:,channel)=imTemp;
            end
        end

        colorInd=find(map>=threshList(t+1));
        for channel=1:nChannels
            imTemp=squeeze(funcOverlay(:,:,channel));
            imTemp(colorInd)=colorOverlayPos(t+1,channel)*(2^8);
            funcOverlay(:,:,channel)=imTemp;
        end
    
        hf=figure;imshow(uint8(funcOverlay));
        colormap(cMap);
        h=colorbar;
        set(h,'ylim',[0 1],'Ticks',[.045 .4 .59 .96],'TickLabels',tickDisplay)
     else
         hf=figure;imshow(uint8(funcOverlay));
         
     end
    
    

    
    saveas(hf,[outDir,contrastStruct(c).name,'_SPM.tiff'])
 %   close all
    
end