function nconetworks=NCOalgorithm(net)
st=1;
nodes=length(net);
opinion=zeros(nodes,1);
i=randi(100,1);
f=i*0.01;
pfacnodes=f*nodes;
pnodes=randi(nodes,1,pfacnodes);

for i=1:length(pnodes)
    opinion(pnodes(1,i))=1;
end
tempopinion=opinion;
while st==1
    for k=1:length(opinion)
    positive=0;
    negative=0;
        negind=kneighbors(net,k,1);
            for op=1:length(negind)
                if opinion(k)==1
                positive=positive+1;
                else
                negative=negative+1;
                end
                opin=opinion(negind(op));
                if opin==1
                    positive=positive+1;
                else
                    negative=negative+1;
                end
            end
            
         if positive>negative
             tempopinion(k)=1;
         else
             if negative>positive
             tempopinion(k)=0;
             end                  
         end    
    end
    status=opinion-tempopinion;
    [~,~,ele]=find(status);
    if ~numel(ele)>0
         st=0;
    end
end
nconetworks=nconetwork(nodes,net,tempopinion,f);
end
