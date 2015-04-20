function [s, maxeig, dQ, g] = specBiPart(g, ng)
% SPECTBIPART - spectral partitioning into two groups
%
% s = specBiPart(g) spectral partitioning into two groups. Partitioning
% vector s consist 1 for group 1 and -1 for group 1. The graph is
% indivisable, where maximun eigenvalue of modularity matrix is zero.
% s = specBiPart(g, ng) spectral partitioning of subgroup of nodes ng in graph g
% into two groups. 
% [s, maxeig] = specPart(g, ng) maxeig is maximun eigenvalue of modularity
% matrix
% [s, maxeig, dQ] = specBiPart(g, ng) calculate incremental modularity, dQ =
% s' * B * s /4m, where B is modularity matrix and m is total number of
% edges.
%
% See also SPECPART, MODMAT, MODULARITY.

%
% Ref: M. E. Newman, PNAS 2006

options.issym=1;               % matrix is symmetric
options.isreal=1;              % matrix is real
options.tol=1e-6;              % decrease tolerance 
options.maxit=500;             % increase maximum number of iterations
options.disp=0;

if nargin == 1
    [mod, g] = modmat(g);
    [v, maxeig] = eigs(mod, 1, 'LA', options); 
    % [v, e] = eig(mod);
    % d = []; for k = 1:size(g,1), d(k) = e(k,k); end  % take diagonal
    % [maxeig, maxeigidx] = max(d);
    % s = sign(v(:,maxeigidx)); % partitioning vector into two groups
    s = sign(v);
else
    [mod, g] = modmat(g, ng);
    [v, maxeig] = eigs(mod, 1, 'LA', options); 
    % [v, e] = eig(mod);
    % d = []; for k = 1:size(mod,1), d(k) = e(k,k); end  % take diagonal
    % [maxeig, maxeigidx] = max(d);
    % s = sign(v(:,maxeigidx)); % partitioning vector into two groups
    s = sign(v);
end
if nargout > 2, 
    m = sum(sum(adjacency(g)))/2;
    dQ = s' * mod * s / (4*m); 
end