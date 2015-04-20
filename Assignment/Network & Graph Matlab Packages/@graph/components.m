function comps = components(g)
% COMPONENTS    - connected components
%
%   comps = components(g) get connected components in the graph. c return as
%   cell array of each connected components
%
% This function change internal state of the graph.

g = reset(g);
comps = {};
if isempty(g.edges)
    return; 
end

for k = 1:length(g.nodes)
    if ~g.nodes(k).visited
        comps{end+1} = [];
        activeVertexes = k;
        while ~isempty(activeVertexes)
            nextVertexes = [];
            for kv = activeVertexes
                adj = neighbors(g,kv);
                for ka = adj'
                    if ~g.nodes(ka).visited
                        g.nodes(ka).visited = 1;
                        nextVertexes(end+1) = ka;
                        comps{end}(end+1) = ka;
                    end
                end
            end
            activeVertexes = nextVertexes;
        end
        if isempty(comps{end}) % if there is only one component
            comps{end} = k;
        end
    end
end