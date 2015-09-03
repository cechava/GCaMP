function [blockStartT,blockCond]=getBlockStartTimes(planSourceDir)

blockParaText=tdfread([planSourceDir,'blockParadigm.txt']);
blockStartT=blockParaText.tStart;
blockCond=blockParaText.condNum;