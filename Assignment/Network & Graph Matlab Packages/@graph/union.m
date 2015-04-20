function g1 = union(g1, g2)
% UNION     - union of two graph
%
% g = union(g1, g2) combine graph g1 and graph g2. Exact node label are
% assumed as same. Edge appear in g if either of g1 and g2 has an edge.
%

if g1.directed ~= g2.directed
    error('Both graph must be directed or undirected.');
end

labels1 = {g1.nodes.label};
for k = 1:length(g2.nodes)
    if ~ismember(g2.nodes(k).label, labels1)
        g1.nodes(end+1) = g2.nodes(k);
    end
end
labels1 = {g1.nodes.label};
adj = adjacency(g1);
for k = 1:size(g2.edges,1)
    n1 = find(strcmp(labels1, g2.nodes(g2.edges(k,1)).label));
    n2 = find(strcmp(labels1, g2.nodes(g2.edges(k,2)).label));
    if ~adj(n1,n2) % no such edge in g1
        g1.edges(end+1,:) = [n1, n2];
    end
end
    
    
    