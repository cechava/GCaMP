clear all
close all

sourceRoot='/home/cesar/Documents/GCaMP/Projects/';
projectID='Retinotopy/3x3Grid/';
sessID='AH02_8_14';
analysisFolder=[sourceRoot,projectID,'Sessions/',sessID,'/Analyses/'];

fwhm=0;
dsFactor=2;
analysisID=['Analysis_tWindow_M1_dsFactor',num2str(dsFactor),'_fwhm',num2str(fwhm)];


resultsDir=[analysisFolder,analysisID,'/AnalysisOutput/AllRuns/'];


load([sourceRoot,projectID,'contrastDetials.mat']);
nContrasts=9;%length(contrastStruct);



for c1=1:nContrasts
    RSAmatrix=zeros(1,nContrasts);
    spmFile1=[resultsDir,sessID,'_',contrastStruct(c1).name,'_map.mat'];
    load(spmFile1);
    mapData1=map(:)';
    for c2=1:nContrasts
        spmFile2=[resultsDir,sessID,'_',contrastStruct(c2).name,'_map.mat'];
        load(spmFile2);
        mapData2=map(:)';
        
        RSAmatrix(1,c2)=pdist([mapData1; mapData2],'correlation');
    end
    
    RSAmatrix=reshape(RSAmatrix,3,3)';
    figure;imagesc(RSAmatrix);colormap('jet');colorbar
    
    

end


