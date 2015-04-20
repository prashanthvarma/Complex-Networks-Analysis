function g = span(g, start_nodes, len)
% SPAN span the graph from given starting nodes
%
%   G = SPAN(G, START_NODES, LEN) span the tree and marked the travelled
%   nodes by visited and timeStamp. START_NODES is array of node id or
%   a node label.Use GRAPH(G, 'visited') to create a subgraph from the 
%   parent of travelled nodes. 
%
%   

g = reset(g);

if ischar(start_nodes)
    [tf, loc] = ismember(start_nodes, {g.nodes.label});
    if ~tf
        error('Node label %s not found.', start_nodes);
    else
        start_nodes = loc;
    end
end

timeStamp = 0;
activeVertexes = start_nodes;
for k = activeVertexes(:)'
    g.nodes(k).visited = 1;
end

for k = 1:len
    nextVertexes = [];
    timeStamp = timeStamp + 1;
    for kv = activeVertexes
        adj = neighbors(g,kv);
        for ka = adj'
            if ~g.nodes(ka).visited
                g.nodes(ka).visited = 1;
                g.nodes(ka).timeStamp = timeStamp;
                nextVertexes(end+1) = ka;
            end
        end
    end
    activeVertexes = nextVertexes;
end