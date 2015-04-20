function deg = degree(g, dim)
% degree    - vertex degree
%
%   deg = degree(g) return (out) vertex degree
%   deg = degree(g, 1) return out vertex degree
%   deg = degree(g, 2) return in vertex degree

if nargin < 2
    dim = 1;
end
deg = full(sum(adjacency(g),dim));