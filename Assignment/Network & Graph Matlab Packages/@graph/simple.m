function g = simple(gi)
% SIMPLE    - convert a graph into simple graph
%
% g = simple(gi) get a simple graph. Simple graph is undirected, no
% multi-edges, no self-loop graph. This also remove sigleton nodes; 
% Note: The resulting graph may have loop however.
%
% Example:
%   g = simple(g);
%
%   % get larget single component
%   comps = components(g);
%   s = []; for k = 1:length(comps), s(k) = length(comps{k}); end
%   [m, mi] = max(s);
%   sg = graph(g, comps{mi});

adj = full(adjacency(gi));
adj = adj + adj';
adj = sign(adj);
for k = 1:length(adj)
    adj(k,k) = 0;
end
labels = {gi.nodes.label};
sigleton = sum(adj,1) == 0;
adj(sigleton, :) = [];
adj(:, sigleton) = [];
labels(sigleton) = [];
g = graph(adj, labels);
