N1 = max(A);
N2 = max(B);
N = max (N1, N2);
Na = length(A);
adj = zeros(N, N); 
deg = zeros(N,1);
%top_prop_sum = [0, 0, 0, 0, 0, 0];
Clust_Coeff_Sum = 0;

% Generating adjacency matrix

for i=1:Na
 L1 = A(i);
    L2 = B(i);
    adj(L1, L2) = 1;
    adj(L2, L1) = 1;
end

% Generating degree matrix

for i=1:N
   for j=1:N
        if adj(i, j) == 1
            deg(i) = deg(i) + 1; 
        end
    end
            
end

edge_list = adj2edgeL(adj);

D_C = Degree_correlation(edge_list);

% Rewiring

for k=1:100

%[el,rew] = rewire_assort(edge_list, D_C);

[el,rew] = rewire_disassort(edge_list, D_C);

%net_assort(:,:,k) = el;

net_disassort(:,:,k) = el;

adjn = edgeL2adj(el);

[C1,Clust_Coeff,C] = clust_coeff(adjn);

Clust_Coeff_Sum = Clust_Coeff_Sum + Clust_Coeff;

%[deg_corr, Clust_Coeff, avg_hop, max_hop, spect_rad, alg_connec] = Topological_Properties (el);
%top_prop = [deg_corr, Clust_Coeff, avg_hop, max_hop, spect_rad, alg_connec];
%top_prop_sum = top_prop_sum + top_prop; 

fprintf('Network : %u\n',k)

end

%top_prop_avg = (top_prop_sum)./100;

Clust_Coeff_Avg = Clust_Coeff_Sum / 100;