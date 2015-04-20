function L = laplacian(g)
% Get graph Laplacian matrix
%
%   L = laplacian(g)
%
% graph Laplacian matrix is defined by L = D - A, where D is vertex degree
% diagonal matrix and A is adjacency matrix.
%
% See also: adjacency

L = diag(sum(g.adj)) - g.adj;
