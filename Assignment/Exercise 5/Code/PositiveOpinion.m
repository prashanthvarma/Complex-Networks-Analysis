%input:adjacency matrix
%output:a vector of s1
function [s1,MaxClusterSize]=PositiveOpinion(classadj)
s1=zeros(100,1);
MaxClusterSize=zeros(100,1);
for i=1:100
    %f=i*0.01;
    %k=i*100;
    index=randperm(10000,i*10000/100);%10000/imax
   
    %generate opinion vector which 1 means positive, -1 means negative
    opinionVector=ones(10000,1);
    opinionVector=opinionVector*(-1);
    opinionVector(index)=1;    
    %positiveNum=k;
    percentagePositive=i*100/10000;
    
    %keep changing opinion until arriving the steady state
    l=1;
    m=0;
    while l<5&&m<30
        
    %generate opinion vector for each time step
    changeOpinion=classadj*opinionVector+opinionVector;
    countPositive=0;
    for j=1:10000
        if changeOpinion(j)>1E-5
            changeOpinion(j)=1;
            countPositive=countPositive+1;
        else if changeOpinion(j)<-1E-5
                changeOpinion(j)=-1;
            else if changeOpinion(j)==0&&opinionVector(j)==1
                    countPositive=countPositive+1;
                    changeOpinion(j)=opinionVector(j);
                else changeOpinion(j)=opinionVector(j);
                end
             end
        end
    end
    percentagePositive1=countPositive/10000;
    opinionVector=changeOpinion;
    if percentagePositive==percentagePositive1
        l=l+1;
    else percentagePositive=percentagePositive1;
        l=1;
    end
    m=m+1
    i
    end
    %remove all the negative nodes
    
    
    
    %remove all the negative nodes and then calculate the largest cluster
    %size
    
    calMatrix1=changeOpinion*ones(1,10000);
    %negClassadj1=classadj.*calMatrix1;
    modClassadj=((classadj.*calMatrix1)+classadj)/2;
    calMatrix2=ones(10000,1)*(changeOpinion');
    %negClassadj2=modClassadj.*calMatrix2;
    modClassadj=((modClassadj.*calMatrix2)+modClassadj)/2;
    
   
%find largest cluster size
comps=find_conn_comp(modClassadj);

ClusterList=[];
for k=1:length(comps); ClusterList=[ClusterList, length(comps{k})]; end
MaxClusterSize(i)=max(ClusterList);
           
    %s1(i)=MaxClusterSize/10000;
   
    
    
end
s1=MaxClusterSize/10000;