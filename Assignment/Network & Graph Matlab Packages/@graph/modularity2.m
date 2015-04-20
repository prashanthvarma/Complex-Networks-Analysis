function q = modularity2(g, s)
% MODULARITY2   - modularity measure (alternative)
%
%   q = modularity2(g) returns modularity measure of graph g. Use set(g, 'group', ...)
%       to set group id. q is defined as:
%
%   q = sum of (A(vc,vc)/A(v,v) - (A(vc,v)/A(v,v))^2)
%       v is verties and vc is verties in group c. A(vc, v) represent edges
%       weight between vc and v, 0 if they are not link.
%
%   q = modularity2(g, s) returns modularity measure of graph g grouped according to 
%       grouping vector s corresponding to each node. 
%
%   Example:
%   q = modularity2(g)
%   q = modularity2(g, [1 1 2 1 3 3]);
%
%   See also MODULARITY, SET.

% Ref: Scott Whitey and Padhraic Smyth 2005

adj = adjacency(g);
Avv = sum(sum(adj));

if nargin == 1
    s = [g.nodes.groupid];
end

q = 0;
for k = min(s):max(s)
    c = find(s==k);
    if isempty(c), continue; end
    Avcvc = sum(sum(adj(c,c)));
    Avcv = sum(sum(adj(c,:)));
    q = q + Avcvc/Avv - (Avcv/Avv)^2;
end