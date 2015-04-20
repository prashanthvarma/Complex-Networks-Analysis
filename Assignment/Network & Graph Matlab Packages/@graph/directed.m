function d = directed(g)
% directed  - check directed graph
%
%   d = directed(g) return 1 if directed, 0 otherwise
%
% Note: Native graph data structrue is directed. 0 only if adj == adj'

if isempty(g.directed)
    adj = adjacency(g);
    g.directed = ~isequal(adj, adj');
end

d = g.directed;