function k = dkernel(g, beta)
% Return diffusion kernel 
%
%   K = DKERNEL(G, BETA) return diffusion kernel of given diffusion
%   probability BETA. Diffusion kernel of a graph is defined as
%   K = exp (BETA * L), where L is graph lapalcian matrix and exp is matrix
%   exponential, which is calucalted by SVD.
%
%   See also: laplacian.

% Kyaw Tun
% 6/6/2009

error(nargchk(2, 2, nargin));

[u, s, v] = svd(full(laplacian(g)));

% u and v is the same since laplacian is symetric.

k = u * diag(beta * degree(g)) * v;