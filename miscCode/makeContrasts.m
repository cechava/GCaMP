clear all
close all

sourceRoot='/media/cesar/1TB HD/Cesar/GCaMP/Projects/';
% projectID='Retinotopy/halfScreen_Blocked/UDLR/';
% 
% outDir=[sourceRoot,projectID];
% 
% contrastStruct=struct;
% 
% contrastStruct(1).name=['Top'];
% contrastStruct(1).plus=[1];
% contrastStruct(1).minus=[0];
% 
% contrastStruct(2).name=['Bottom'];
% contrastStruct(2).plus=[2];
% contrastStruct(2).minus=[0];
% 
% contrastStruct(3).name=['Left'];
% contrastStruct(3).plus=[3];
% contrastStruct(3).minus=[0];
% 
% contrastStruct(4).name=['Right'];
% contrastStruct(4).plus=[4];
% contrastStruct(4).minus=[0];
% 
% 
% contrastStruct(5).name=['Top_vs_Bottom'];
% contrastStruct(5).plus=[1];
% contrastStruct(5).minus=[2];
% 
% contrastStruct(6).name=['Left_vs_Right'];
% contrastStruct(6).plus=[3];
% contrastStruct(6).minus=[4];
% 
% 
%save([outDir,'contrastDetials.mat'],'contrastStruct')

% projectID='Retinotopy/4x3Grid/';
% 
% outDir=[sourceRoot,projectID];
% 
% contrastStruct=struct;
% 
% contrastStruct(1).name=['1'];
% contrastStruct(1).plus=[1];
% contrastStruct(1).minus=[0];
% 
% contrastStruct(2).name=['2'];
% contrastStruct(2).plus=[2];
% contrastStruct(2).minus=[0];
% 
% contrastStruct(3).name=['3'];
% contrastStruct(3).plus=[3];
% contrastStruct(3).minus=[0];
% 
% contrastStruct(4).name=['4'];
% contrastStruct(4).plus=[4];
% contrastStruct(4).minus=[0];
% 
% contrastStruct(5).name=['5'];
% contrastStruct(5).plus=[5];
% contrastStruct(5).minus=[0];
% 
% contrastStruct(6).name=['6'];
% contrastStruct(6).plus=[6];
% contrastStruct(6).minus=[0];
% 
% contrastStruct(7).name=['7'];
% contrastStruct(7).plus=[7];
% contrastStruct(7).minus=[0];
% 
% contrastStruct(8).name=['8'];
% contrastStruct(8).plus=[8];
% contrastStruct(8).minus=[0];
% 
% contrastStruct(9).name=['9'];
% contrastStruct(9).plus=[9];
% contrastStruct(9).minus=[0];
% 
% contrastStruct(10).name=['10'];
% contrastStruct(10).plus=[10];
% contrastStruct(10).minus=[0];
% 
% contrastStruct(11).name=['11'];
% contrastStruct(11).plus=[11];
% contrastStruct(11).minus=[0];
% 
% contrastStruct(12).name=['12'];
% contrastStruct(12).plus=[12];
% contrastStruct(12).minus=[0];
% 
% contrastStruct(13).name=['11vs12'];
% contrastStruct(13).plus=[11];
% contrastStruct(13).minus=[12];
% 
% contrastStruct(14).name=['12vs8'];
% contrastStruct(14).plus=[12];
% contrastStruct(14).minus=[8];
% 
% save([outDir,'contrastDetials.mat'],'contrastStruct')


projectID='Retinotopy/5x4Grid/';

outDir=[sourceRoot,projectID];

contrastStruct=struct;

contrastStruct(1).name=['1'];
contrastStruct(1).plus=[1];
contrastStruct(1).minus=[0];

contrastStruct(2).name=['2'];
contrastStruct(2).plus=[2];
contrastStruct(2).minus=[0];

contrastStruct(3).name=['3'];
contrastStruct(3).plus=[3];
contrastStruct(3).minus=[0];

contrastStruct(4).name=['4'];
contrastStruct(4).plus=[4];
contrastStruct(4).minus=[0];

contrastStruct(5).name=['5'];
contrastStruct(5).plus=[5];
contrastStruct(5).minus=[0];

contrastStruct(6).name=['6'];
contrastStruct(6).plus=[6];
contrastStruct(6).minus=[0];

contrastStruct(7).name=['7'];
contrastStruct(7).plus=[7];
contrastStruct(7).minus=[0];

contrastStruct(8).name=['8'];
contrastStruct(8).plus=[8];
contrastStruct(8).minus=[0];

contrastStruct(9).name=['9'];
contrastStruct(9).plus=[9];
contrastStruct(9).minus=[0];

contrastStruct(10).name=['10'];
contrastStruct(10).plus=[10];
contrastStruct(10).minus=[0];

contrastStruct(11).name=['11'];
contrastStruct(11).plus=[11];
contrastStruct(11).minus=[0];

contrastStruct(12).name=['12'];
contrastStruct(12).plus=[12];
contrastStruct(12).minus=[0];

contrastStruct(13).name=['13'];
contrastStruct(13).plus=[14];
contrastStruct(13).minus=[0];

contrastStruct(14).name=['14'];
contrastStruct(14).plus=[14];
contrastStruct(14).minus=[0];

contrastStruct(15).name=['15'];
contrastStruct(15).plus=[15];
contrastStruct(15).minus=[0];

contrastStruct(16).name=['16'];
contrastStruct(16).plus=[16];
contrastStruct(16).minus=[0];

contrastStruct(17).name=['17'];
contrastStruct(17).plus=[17];
contrastStruct(17).minus=[0];

contrastStruct(18).name=['18'];
contrastStruct(18).plus=[18];
contrastStruct(18).minus=[0];

contrastStruct(19).name=['19'];
contrastStruct(19).plus=[19];
contrastStruct(19).minus=[0];

contrastStruct(20).name=['20'];
contrastStruct(20).plus=[20];
contrastStruct(20).minus=[0];

save([outDir,'contrastDetials.mat'],'contrastStruct')


% projectID='SceneMatching/';
% 
% outDir=[sourceRoot,projectID];
% 
% contrastStruct=struct;
% 
% contrastStruct(1).name=['Original'];
% contrastStruct(1).plus=[1];
% contrastStruct(1).minus=[0];
% 
% contrastStruct(2).name=['MagMatched'];
% contrastStruct(2).plus=[2];
% contrastStruct(2).minus=[0];
% 
% contrastStruct(3).name=['TexMatched'];
% contrastStruct(3).plus=[3];
% contrastStruct(3).minus=[0];
% 
% contrastStruct(4).name=['Original_vs_MagMatched'];
% contrastStruct(4).plus=[1];
% contrastStruct(4).minus=[2];
% 
% contrastStruct(5).name=['Original_vs_TexMatched'];
% contrastStruct(5).plus=[1];
% contrastStruct(5).minus=[3];
% 
% contrastStruct(6).name=['MagMatched_vs_TexMatched'];
% contrastStruct(6).plus=[2];
% contrastStruct(6).minus=[3];
% 
% save([outDir,'contrastDetials.mat'],'contrastStruct')





