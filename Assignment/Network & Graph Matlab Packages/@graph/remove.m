function g = remove(g, ids)
%% Remove nodes
%
%   G = REMOVE(G, NODES) remove given nodes from graph G. NODES could be vector
%   of indeies or name of nodes.
%
%


if iscell(ids)
    labels = {g.nodes.label};
    [tf, ids] = ismember(ids, labels);
end

g.nodes(ids) = [];
g.adj(ids, :) = [];
g.adj(:, ids) = [];
edges_todelete = any([ismember(g.edges(:,1), ids), ismember(g.edges(:,2), ids)],2);
g.edges(edges_todelete, :) = [];
