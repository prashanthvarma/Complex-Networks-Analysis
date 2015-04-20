%generate ER network
N=10000;
p=4/10000;
classAadj=random_graph(N,p);

%applying NCO model and get a vetor of s1 which store in  one column in sC
S = PositiveOpinion(classAadj);
