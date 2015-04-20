function [g] = bfs(g, sp, ep)
% bfs  - Do breadth first search
%
%   bfs = bfs(g, sp)
%   bfs = bfs(g, sp, ep)
%
%   g   - graph
%   sp  - index or id of start point 
%   ep  - index or id of end point 
%   bfs - breadth first search graph
%
%   Note: this function change internal state of input graph object g.
%   This function reset and change visited and timeStamp fields of nodes in g. 
%
% Example:
%   % to get a graph
%   bfs = bfs(g, sp)
%   bfsGraph = graph(bfs, nodes) 
%

if nargin < 3, ep = -1; end
if ischar(sp)
    sp = node(g, sp);
end
if ischar(ep)
    ep = node(g, ep);
end

g = reset(g);
nodes = sp;
edges = [];
g.nodes(sp).visited = 1;

timeStamp = 1;
g.nodes(sp).timeStamp = timeStamp;

activeVertexes = sp;


while ~isempty(ep) && ~isempty(activeVertexes)
    nextVertexes = [];
    timeStamp = timeStamp + 1;
    for kv = activeVertexes
        adj = neighbors(g,kv);
        for ka = adj'
            if ~g.nodes(ka).visited
                g.nodes(ka).visited = 1;
                g.nodes(ka).timeStamp = timeStamp;
                nextVertexes(end+1) = ka;
                nodes(end+1) = ka;
                edges(end+1,[1 2]) = [kv, ka];
                ep(ep==ka) = [];
            end
        end
    end
    activeVertexes = nextVertexes;
end

g.edges = edges;
