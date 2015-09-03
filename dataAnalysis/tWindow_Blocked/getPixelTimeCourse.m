function getPixelTimeCourse(timeDir,sessID,nCond,pixX,pixY)



figure(2);
clf
hold all

for cond=1:nCond
    load([timeDir,sessID,'_condition',num2str(cond),'_tCourse.mat']);
    size(observedRespMean)
    frameT_ASO=0:1/60:(priorTime+afterTime)-1/60;
    frameT_ASO=frameT_ASO-priorTime;
    h(cond)=subplot(2,2,cond);
    hold all
    shadedErrorBar(frameT_ASO,squeeze(observedRespMean(pixY,pixX,:)),squeeze(observedRespSE(pixY,pixX,:)),'-b')
    line([0 0],get(h(cond),'Ylim'),'Color',[0 0 0])
    set(gca,'FontSize',16)
    xlabel('Time ASO (secs)','FontSize',20)
    ylabel('Signal','FontSize',20)
    
end
title(h(1),['Pixel Y: ',num2str(pixY),' Pixel X: ',num2str(pixX),' Time Course'],'FontSize',12)