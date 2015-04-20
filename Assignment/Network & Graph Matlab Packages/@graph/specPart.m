function [g, Q] = specPart(g, options, ng, Q)
% SPECTPART     - spectral partitioning 
%
% [s, Q] = specPart(g) spectral partitioning into two groups. Partitioning
% vector s consist 1 for group 1 and 2 for group. Q is modularity.
%
% Example:
%   g = graph('group3'); % get a sample graph
%   [g Q] = specPart(g)
%   g = set(g, 'nodeColor', []); % color node with group id
%   g = layout(g, 'group');
%   plot(g);
%
% See also SPECBIPART, GAPART, MODMAT, MODULARITY.

%
% Ref: M. E. Newman, PNAS 2006

if nargin == 1
    options.mindq = eps;
end

if nargin <= 2
    [g.nodes.groupid] = deal(1);
    [s, maxeig, dQ, g] = specBiPart(g);
    Q = 0;
    ng = 1:length(g.nodes);
else
    [s, maxeig, dQ, g] = specBiPart(g, ng);
end

if dQ <= options.mindq || maxeig <= 0
    return; % no more contribution
end
ng1 = ng(find(s==1));
ng2 = ng(find(s==-1));
if isempty(ng1) || isempty(ng2)
    return;
end

% do partitioning
Q = dQ + Q;
[g.nodes(ng2).groupid] = deal(max([g.nodes.groupid])+1);


if size(g,1) > 120
    fprintf('Q = %g\tdQ = %g\n',Q, dQ);
end

if length(ng1) > 1
    [g, Q] = specPart(g, options, ng1, Q);
end
if length(ng2) > 1
    [g, Q] = specPart(g, options, ng2, Q);
end