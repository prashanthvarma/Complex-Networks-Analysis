function display(g)
% DISP  - display the graph

s = '';
if ~directed(g)
    s = ', undirected';
end
gp = unique(get(g, 'group'));
if length(gp) > 1
    s = sprintf('%s, %d groups', s, length(gp));
end
vp = sum([g.nodes.visited]);
if vp > 0
   s = sprintf('%s, %d visited', s, vp);
end 

[m,n] = size(g);

fprintf('%s <%i nodes, %i edges%s>\n', g.name, m, n, s);
