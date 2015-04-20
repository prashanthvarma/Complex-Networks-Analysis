function [pk, feq, vdk, gamma] = verdegdb(g)
% VERDEGDB vertex degree distribution
%
%   [pk, feq, vdk, gamma] = verdegdb(g)
%
%   adj     - adjacency matrix
%   pk      - P(k), probability of finding vertex degree k
%   feq     - number of vertex found for vertex degree k
%   vdk     - k, vertex degree k
%   gamma   - vertex exponent
%
%
% To draw degree distribution diagram
%
%   [pk, feq, vdk, gamma] = verdegdb(g);
%   loglog(vdk, pk, '.')
%   xlabel('k'), ylabel('P(k)'), 
%   title(['Vertex degree distribution - ', get(g, 'name')])

adj = adjacency(g);
degs = full(sum(adj,1));
vdk = unique(degs);
feq = zeros(size(vdk));
for k = 1:length(vdk)
    feq(k) = sum(degs == vdk(k));
end

pk = feq ./ sum(feq);
x = log10(vdk);
y = log10(pk);
if vdk(1) == 0 & nargout > 3
    warning('graph:verdegdb', 'There are %d proteins which has no link are ignored in gamma calculation.', ...
        feq(1));
    gamma = - lscov(x(2:end)', y(2:end)', feq(2:end)');
else
    gamma = - lscov(x', y', feq');
end
