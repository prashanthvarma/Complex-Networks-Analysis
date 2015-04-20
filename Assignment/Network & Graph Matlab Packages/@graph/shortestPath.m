function path = shortestPath(g, sp, ep)
% SHORTESTPATH  - find shortest path
%
%   path = shortestPath(g, sp, ep)
%
%   g   - graph
%   sp  - index of start point
%   ep  - index of end point, ep can be array of index
%
%   see also - allspath
%

bfs = breadthFirstSearch(g, sp, ep);
path = fliplr(tracePathInTree(bfs,sp,ep));
