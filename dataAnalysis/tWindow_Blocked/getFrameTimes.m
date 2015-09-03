function [frameCount,frameT,frameCond] = getFrameTimes(planSourceDir)

frameTimeText=tdfread([planSourceDir,'frameTimes.txt']);
frameT=frameTimeText.frameT;
frameCount=frameTimeText.frameCount(end)+1;
frameCond=frameTimeText.frameCond;
