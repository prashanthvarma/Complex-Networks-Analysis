function ns = node(g, idxs)
% NODE  - get nodes of given id or name
%
%   nodes = node(g, idxs)
%           idxs can be string id of a node or index of node. Empty matrix
%           return if the matching name is not found.
%

ns = [];
if ischar(idxs)
    n = find(strcmp(idxs, {g.nodes.label}));
    if ~isempty(n)
        ns = g.nodes(n);
    end
elseif iscell(idxs)
    for k = idxs(:)'
        n = find(strcmp(k, {g.nodes.label}));
        if ~isempty(n)
            if isempty(ns)
                ns = g.nodes(n);
            else
                ns(end+1) = g.nodes(n);
            end
        end
    end
elseif isnumeric(idxs)
    assert(all(idxs<length(g.nodes)), 'Invalid indexes');
    ns = g.nodes(idxs);
else
    error('Invalid input');
end
