function adj = neighbors(g, p)
% NEIGHBORS  - neighbor (adjacent) nodes of given node index p
%
%   adj = neighbors(g, p)
%

adj = g.edges(g.edges(:,1)==p,2);
if ~g.directed
    adj = [adj; g.edges(g.edges(:,2)==p,1)];
end

adj = unique(adj);