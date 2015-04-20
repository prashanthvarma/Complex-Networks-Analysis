% N = Nodes count
% Adj = Adjacency matrix
% L = Link count
% p =Link Density
% Avg_Deg = Average degree
% Deg_var = Degree Variance

N1 = max(A);
N2 = max(B);
N = max (N1, N2); 
adj = zeros(N, N); 
L = 0;             
Na = length(A);
Nb = length(B);
deg = zeros(N);

% Generating adjacency matrix

for i=1:Na
 L1 = A(i);
    L2 = B(i);
    adj(L1, L2) = 1;
    adj(L2, L1) = 1;
end

% Calculating number of links and generating degree matrix

for i=1:N
   for j=1:N
        if adj(i, j) == 1
            L = L+1;
            deg(i) = deg(i) + 1; 
        end
    end
            
end

% Topological metrics

L = L/2;
Lc = (N*(N-1))/2; % Links in complete graph
p = L/Lc; % Link density
Avg_Deg = (2*L)/N; % Average degree
Deg_Var = var(deg(:,1)); % Degree variance

% Degree distribution : linear-linear scale

figure(1)
[y, x] = hist(deg(:,1),unique(deg(:,1)));
plot(x,y/sum(y),'*r');
xlabel('Degree K');
ylabel('P(D = k)');
title('Node Degree Distribution : linear-linear scale');

% Checking for power law distribution

[y, x] = hist(deg(:,1),unique(deg(:,1))); 
t = y/sum(y);
t = t';
n = log10(x);
T = log10(t);
p = polyfit(n,T,1);
Gamma = p(1); % Gamma - power exponent
c = 10^p(2); % Power law constant
d = c*(unique(deg(:,1)).^(Gamma));
e = unique(deg(:,1));

% Power law degree distribution : linear-linear scale

figure(2)
[y, x] = hist(deg(:,1),unique(deg(:,1)));
plot(x,y/sum(y),'*r'); % Actual distribution
hold on
plot(e,d, ':b'); % Fitting Curve
xlabel('Degree K');
ylabel('P(D = k)');
title('Node Degree Distribution : linear-linear scale');
legend({'Actual distribution','Fitting curve'});

% Power law Degree distribution : log-log scale

figure(3)
loglog(x,y/sum(y),'*r'); % Actual distribution
hold on
loglog(e,d,':b'); % Fitting Curve
xlabel('Log(k)');
ylabel('Log(P(k))');
title('Node Degree Distribution : log-log scale');
legend({'Actual distribution','Fitting curve'});

deg_corr = Degree_correlation(adj);

[C1,Clust_Coeff,C] = clust_coeff(adj);

% avg_hop = ave_path_length(adj); % Function call for average hop count

% max_hop = diameter(adj); % Function call for diameter

% spectral Metrics : 

eigen_adj = eig(adj); % Eigen values of adjacency matrix

spect_rad = max(eigen_adj); % Largest eigen value - spectral radius

D = diag(deg(:,1)); % diagonal - degree matrix

L = D - adj; % laplacian matrix

eigen_lap = eig(L); % Eigen values of adjacency matrix

s = sort(-eigen_lap); % Sorting eigen values of laplacian matrix

alg_connec = - s(length(s)-1); % Second smallest eigen value - algebric connectivity








            
        










