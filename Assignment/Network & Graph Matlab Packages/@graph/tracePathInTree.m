function path = tracePathInTree(g, sp, ep)
% TRACEPATHINTREE   - Backward trace path from ep to sp 
%   
% path = tracePathInTree(g, sp, ep)   Backward trace path from ep to sp 
%   according to decressing order of time stamp.he graph is mark with
%   timestamp.
%
%   sp  - index of start vertex
%   ep  - index of end vertex

isdirected = g.directed;
g = set(g, 'directed', 0); % make reverse transfersal possible

path = ep;

found = 1;
while path(end) ~= sp && found
    found = 0;
    for k = neighbors(g, path(end));
        if g.nodes(k).timeStamp+1 == g.nodes(path(end)).timeStamp
            path(end+1) = k;
            found = 1;
            break;
        end
    end
end

if ~found
    path = [];
end
g.directed = isdirected;