function plot(g, varargin)
% GRAPH/PLOT    - plot a graph
%
%   plot(g)
%   plot(g, ...)
% Options:
%   ShowNodeLabel   - 1 to show label
%   Fast            - 1 to draw fastly using build-in function gplot, this 
%                   will ignore some options like ShowNodeLabel


n = length(g.nodes);
w = g.nodeSize;
h = g.nodeSize;
z = 0;

color = 'b';
showNodeLabel = n < 32;
fast = n > 300;
if mod(length(varargin),2) ~= 0
    error('Parameter and value must be in pair.');
end
for k = 1:2:length(varargin)
    switch lower(varargin{k})
        case {'lhownodelabel', 'nodelabel', 'snl', 'nl'}
            showNodeLabel = isequal(1, varargin{k+1});
        case {'fast', 'f'}
            if isequal(1, varargin{k+1})
                fast = 1;
            else
                fast = 0;
            end
        case {'z'}
            z = varargin{k+1};
        case {'color', 'c'}
            color = varargin{k+1};
    end
end

if fast
    xy = reshape([g.nodes.position], 2, length(g.nodes))';
    gplot(adjacency(g), xy);
    return;
end

labelOffset = g.nodeSize*0.02/0.015;
arrowLen = g.nodeSize*0.02/0.015;

axis manual
wn = warning;
warning off

% prepare the axis
ps = [g.nodes.position];
ps = [reshape(ps, 2, length(ps)/2)]';
xmin = min(ps(:,1));
xmax = max(ps(:,1));
ymin = min(ps(:,2));
ymax = max(ps(:,2));
r = max([xmax-xmin, ymax-ymin]);
axis square
axis([xmin-w, xmin+r+w*2, ymin-w, ymin+r+w*2]);

for k = 1:size(g.edges,1)
    n1 = g.edges(k,1);
    n2 = g.edges(k,2);
    x = [g.nodes(n1).position(1),g.nodes(n2).position(1)];
    y = [g.nodes(n1).position(2),g.nodes(n2).position(2)];
    line(x, y, repmat(z, 1, length(x)), 'Color', color);

    if directed(g)
        px(1) = x(2);
        py(1) = y(2);

        theta = atan2(y(2)-y(1), x(2)-x(1)) + pi;

        deg1 = theta + pi*15/180;
        deg2 = theta + pi*345/180;
        px(2) = x(2) + arrowLen * cos(deg1);
        py(2) = y(2) + arrowLen * sin(deg1);
        px(3) = x(2) + arrowLen * cos(deg2);
        py(3) = y(2) + arrowLen * sin(deg2);

        patch(px,py,repmat(z, 1, length(px)),'b', 'Color', color);
    end    
end

for k = 1:n
    x = g.nodes(k).position(1)-w/2;
    y = g.nodes(k).position(2)-h/2;
    c = g.nodes(k).color;
    if c(1) == '['
        c = str2num(c);
    end
    lw = 1;
    if g.nodes(k).visited, lw = 2; end
    rectangle('Position',[x, y, w, h],'Curvature', [1 1], ...
        'LineWidth', lw, ...
        'FaceColor', c, 'ButtonDownFcn', {@mousedown, g.nodes(k).label});
    if showNodeLabel 
        text(x+labelOffset, y+labelOffset, g.nodes(k).label);
    end
end
warning(wn);


function mousedown(varargin)
% for mouse callback of patch

disp(varargin{3});



