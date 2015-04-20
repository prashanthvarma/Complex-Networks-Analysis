
tic;
NumOfNetworks=7;
%B0=dlmread('er_positive_1.txt');
%classBadj=edgelist2adjM(B0);
sB=zeros(100,NumOfNetworks);

for h=1:NumOfNetworks
%applying NCO model and get a vetor of s1 which store in  one column in sB
    sB(:,h)=PositiveOpinion(classBadj);

    %rewiring the network
    classBadj1=sym_generate_srand(classBadj,10);
    prB = pearson(classBadj1);
   %check if rewiring network's degree correlation is within the range 
while prB<0.3||prB>0.31
classBadj1=sym_generate_srand(classBadj,10);
prB = pearson(classBadj1);
end
classBadj=classBadj1;
h
end
toc;