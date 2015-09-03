function frameCond=getFrameCond(frameT,blockStartT,blockCond)
    
frameCond=zeros(1,length(frameT));
for block=1:length(blockCond)-1
    frameCond(frameT>=blockStartT(block)&frameT<blockStartT(block+1))=blockCond(block);
end