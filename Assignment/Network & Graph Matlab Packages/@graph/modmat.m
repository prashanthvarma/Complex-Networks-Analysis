function [b, g] = modmat(g, ng)
% MODMAT    - Modularity matrix for undirected graph
%
%   B = modmat(g) find modularity matrix of the undirected graph. Each
%   element in the matrix is defined as:
%
%                  k_i * k_j
%   b_ij = A_ij - -----------
%                    2 * m
%
%   k_i, k_j: vertices degree of i and j
%   A_ij: adjacency, 1 if node i and node j are conected, 0 otherwise
%   m: the total number of edges
%
%   B = modmat(g, ng) incremental modularity matrix of subgroup of nodes ng
%
% Example:
%   g = set(g, 'directed', 0); % convert to undirected graph
%   g = simple(g); % convert to simple graph
%   q = modmat(g)
%
% Example:
%   % binary spectral partitioning
%   mod = modmat(g);
%   [v, e] = eig(mod);
%   d = []; for k = 1:size(g,1), d(k) = e(k,k); end  % take diagonal
%   [maxeig, maxeigidx] = max(d);
%   s = sign(v(:,maxeigidx)); % partitioning vector into two groups
%   q = modularity(g, s); % calculate modularity matrix
%   g = set(g, 'nodecolor', s); % change node color according to grouping
%   plot(g)
%
%
% See also SPECBIPART, MODULARITY, SIMPLE.

%
% Ref: M. E. Newman, PNAS 2006

if directed(g)
    error('graph:modmat', '%s', 'Graph is not undirected.');
end


if nargin == 2
    ng = ng(:)';
    B = modmat(g);
    b = B;
    bg = sum(B(ng,:), 1);
    for k1 = ng            
        b(k1, k1) = B(k1, k1) - bg(k1);
    end
    b = b(ng, ng);
else
    if isempty(g.modmat)
        adj = adjacency(g);
        n = length(adj);
        deg = sum(adj,1);
        m = sum(deg)/2;
        g.modmat = zeros(size(adj));
        for k1 = 1:n
            for k2 = 1:n
                g.modmat(k1, k2) = adj(k1, k2) - deg(k1) * deg(k2) / (2 * m);
            end
        end
    end
    b = g.modmat;
end