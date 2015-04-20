function q = modularity(g, s)
% modularity    - modularity of the graph for given partitioning vector
%
%   q = modularity (g, s) modularity of the graph g for given partitioning
%   vector s. 
%
%         1
%   q = ----- s' * B * s
%        4*m
%
% B: modularity matrix.
% s: partitioning vector, s_i = 1 if vertex i belongs to group 1 and s_i =
% -1 if vertex i belong to group 2.
% m: the total number of edges.
%
% Example:
%  n = size(g,1);
%  s = (rand(1,n) > rand)*2-1; % generate random partitioning
%  q = modularity(g, s);
%
% Ref: Newman M. E. Proc Natl Acad Sci U S A 2006 
%
% See also MODULARITY2, MODMAT.

error(nargchk(2,2,nargin));

adj = adjacency(g);
deg = sum(adj);
m = sum(deg)/2;
s = s(:);

q = s' * modmat(g) * s / (4*m);
