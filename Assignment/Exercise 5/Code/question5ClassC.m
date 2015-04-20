tic;
NumOfNetworks=10;
C0=dlmread('er__neg_1.txt');
classCadj=edgelist2adjM(C0);
sC=zeros(100,NumOfNetworks);

for h=1:NumOfNetworks
%applying NCO model and get a vetor of s1 which store in  one column in sC
    sC(:,h)=PositiveOpinion(classCadj);

    %rewiring the network
    classCadj1=sym_generate_srand(classCadj,10);
    prC = pearson(classCadj1);
   %check if rewiring network's degree correlation is within the range 
while prC<-0.31||prC>-0.3
classCadj1=sym_generate_srand(classCadj,10);
prC = pearson(classCadj1);
end
classCadj=classCadj1;
h
end
toc;

save ClassC.mat sC;

csvwrite('tennetworkClassCBS1.csv',sC);