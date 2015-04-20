function [deg_corr, Clust_Coeff, avg_hop, max_hop, spect_rad, alg_connec] = Topological_Properties (el)

N = length(unique(el));
degn = zeros(N,1);

adjn = edgeL2adj(el);

% Generating degree matrix

for i=1:N
   for j=1:N
        if adjn(i, j) == 1
            degn(i) = degn(i) + 1; 
        end
    end
            
end

deg_corr = Degree_correlation(el);

[C1,Clust_Coeff,C] = clust_coeff(adjn);

a = sparse(adjn);

short = all_shortest_paths(a);

avg_hop = sum(sum(short)./N)/N;

max_hop = max(max(short));

% spectral Metrics : 

eigen_adj = eig(adjn); % Eigen values of adjacency matrix

spect_rad = max(eigen_adj); % Largest eigen value - spectral radius

D = diag(degn); % diagonal - degree matrix

L = D - adjn; % laplacian matrix

eigen_lap = eig(L); % Eigen values of adjacency matrix

s = sort(-eigen_lap); % Sorting eigen values of laplacian matrix

alg_connec = - s(length(s)-1); % Second smallest eigen value - algebric connectivity