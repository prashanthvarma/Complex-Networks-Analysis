function [m, n] = size(g, dim)
% size      - size of graph 
%
%   [m, n] = size(g)
%   [m, n] = size(g, dim) dim is 1 for node and 2 for edges
%   m:  number of nodes
%   n:  number of edges
%

if nargin > 1
    if dim == 2
        m = length(g.edges) / (~directed(g) + 1); % divided by two if not directed
    elseif dim == 1
        m = length(g.nodes);
    end
else
    n = length(g.edges) / (~directed(g) + 1); % divided by two if not directed
    m = length(g.nodes);
end