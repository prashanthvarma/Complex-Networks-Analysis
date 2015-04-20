function ci = clusteringcoef(g)
% clusteringcoef    - clustering coefficient of given adjacency matrix
%
%   coefs = clusteringcoef(g) cluster coefficient is ratio of the number of
%   edges Ei between the first neighbors of the vertex i, and the
%   respective number of edges, Ei(max) = ai(ai-1)/2, in the complete graph
%   that can be formed by the nearest neighbors of this vertex:
%
%   g is a graph or an alternatively adjacency matrix.
%
%          2 Ei
%   ci = -----------
%        ai (ai - 1)
%
%   A note that do no have a link with others has clustering coefficient of NaN.


if isa(g, 'graph')
    adj = adjacency(g);
else
    adj = g;
end

n = length(adj);
ci = zeros(1,n);
for k = 1:n
    neighbours = [find(adj(:,k))]';
    neighbours(neighbours==k) = []; % self link deleted
    a = length(neighbours);
    if a == 0; ci(k) = NaN; continue; end
    if a < 2, continue; end
    E = 0;
    for ks = 1:a
        k1 = neighbours(ks);
        for k2 = neighbours(ks+1:a)
            if adj(k1,k2) || adj(k2,k1)
                E = E + 1;
            end
        end
    end
    ci(k) = 2 * E / (a * (a-1));
end

        
        