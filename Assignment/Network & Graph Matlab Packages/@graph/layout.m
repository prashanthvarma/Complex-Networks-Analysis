function g = layout(g, method)
% LAYOUT    - layout the graph
%
%   g = layout(g) layout the graph with default method (force directed).
%   g = layout(g, method) layout the graph with provide methods. available
%   methods are 'random', 'force directed', 'group', 'graphviz'.
%
%   For 'GraphViz', MATLAB - GraphViz interface and AT & T GraphViz is required.

if nargin < 2
    method = 'force directed';
end

switch lower(method)
    case {'ran', 'random'}
        g = random(g);
    case {'gv', 'graphviz'}
        lbs = {g.nodes.label};
        [x, y] = draw_dot(adjacency(g), lbs);
        for k = 1:length(g.nodes)
            g.nodes(k).position = [x(k), y(k)];
        end
    case {'g', 'group'}
        % layout depending on group
        gids = [g.nodes.groupid];
        gid = unique(gids);
        lc = length(gid);
        if lc == 2
            g = colorLayout(g, gid, 1);
        elseif lc <= 4            
            g = colorLayout(g, gid, 2);
        elseif lc <= 9
            g = colorLayout(g, gid, 3);
        elseif lc <= 16
            g = colorLayout(g, gid, 4);
        elseif lc <= 25
            g = colorLayout(g, gid, 5);
        elseif lc <= 36
            g = colorLayout(g, gid, 6);
        elseif lc <= 49
            g = colorLayout(g, gid, 7);
        elseif lc <= 64
            g = colorLayout(g, gid, 8);
        elseif lc <= 144
            g = colorLayout(g, gid, 12);
        elseif lc <= 1024
            g = colorLayout(g, gid, 32);
        else
            warning('graph:layout', 'Too many groups.');
        end
    otherwise
        g = forcedirected_old(g);
end

function g = colorLayout(g, cs, d)
r = 1/d/2;
xs = repmat([1:d]'./d-r,1,d);
ys = xs';
if d == 1
    % special case
    r = 1/4;
    d = 2;
    xs = repmat([1:d]'./d-r,1,d);
    ys = repmat(ys, 1, d);
end
for k = 1:length(g.nodes)
    gi = find(cs==g.nodes(k).groupid);
    x = xs(gi) + rand * r * sin(rand*2*pi);
    y = ys(gi) + rand * r * cos(rand*2*pi);
    g.nodes(k).position = [x, y];
end

function g = random(g)

minb = [0.05, 0.05];
b = [0.9, 0.9];

for k = 1:length(g.nodes)
    g.nodes(k).position = rand(1,2) .* b + minb;
end


function g = forcedirected(g)
% force directed layout

n = length(g.nodes);
normlen = g.nodeSize*5;
attstng = 5;
repstng = 1;

maxb = 0.95;
minb = 0.05;
snag = 0.01;

dist = zeros(n,2);
md = zeros(n,2);

% adj = adjacency(g);
% position = reshape([g.nodes.position], 2, length(g.nodes))';
wn = warning;
warning('off');
for kn = 1:20
    % attractive force
    sp = vertcat(g.nodes(g.edges(:,1)).position);
    ep = vertcat(g.nodes(g.edges(:,2)).position);
    vx = ep(:,1) - sp(:,1);
    vy = ep(:,2) - sp(:,2);
    len = sqrt(vx.*vx + vy.*vy);
    len(len==0) = nan;
    f = (normlen-len) ./ (len .* 3);
    dx = attstng .* f .* vx;
    dy = attstng .* f .* vy;
    dx(isnan(dx)) = 0;
    dy(isnan(dy)) = 0;
    dist(g.edges(:,2),1) = dist(g.edges(:,2),1) + dx;
    dist(g.edges(:,2),2) = dist(g.edges(:,2),2) + dy;
    dist(g.edges(:,1),1) = dist(g.edges(:,1),1) - dx;
    dist(g.edges(:,1),2) = dist(g.edges(:,1),2) - dy;

    % repulsive force
    dxs = repmat(g.nodes.position(:,1), 1, n) - g.nodes.position(:,1);
    dys = repmat(g.nodes.position(:,2), 1, n) - g.nodes.position(:,2);
    dx = normlen .* vx ./ (len.^2);
    dy = normlen .* vy ./ (len.^2);
    dx(isnan(dx)) = 0;
    dy(isnan(dy)) = 0;
    dx = sum(dx);
    dy = sum(dy);
    dist(g.edges(:,2),1) = dist(g.edges(:,2),1) + dx;
    dist(g.edges(:,2),2) = dist(g.edges(:,2),2) + dy;
    dist(g.edges(:,1),1) = dist(g.edges(:,1),1) - dx;
    dist(g.edges(:,1),2) = dist(g.edges(:,1),2) - dy;

    for k = 1:n
        dx = min(max(-snag,dist(k,1)),snag);
        dy = min(max(-snag,dist(k,2)),snag);
        g.nodes(k).position(1) = g.nodes(k).position(1) + dx;
        g.nodes(k).position(2) = g.nodes(k).position(2) + dy;
        if g.nodes(k).position(1) < minb
            g.nodes(k).position(1) = minb;
        elseif g.nodes(k).position(1) > maxb
            g.nodes(k).position(1) = maxb;
        end
        if g.nodes(k).position(2) < minb
            g.nodes(k).position(2) = minb;
        elseif g.nodes(k).position(2) > maxb
            g.nodes(k).position(2) = maxb;
        end
        dist(k) = dist(k) ./ 2;
    end
    if 0
        cla
        plot(g)
        pause(0.1)
        drawnow
    end
end
warning(wn);

function g = forcedirected_old(g)

n = length(g.nodes);
normlen = g.nodeSize*5;
attstng = 3;
repstng = 1;

maxb = 0.95;
minb = 0.05;
snag = 0.01;

dist = zeros(n,2);
md = zeros(n,2);

adj = adjacency(g);
position = reshape([g.nodes.position], 2, length(g.nodes))';
wn = warning;
warning('off');
for kn = 1:200
    if 1
        ndist = dist;
        
        for k = 1:length(g.edges)
            k1 = g.edges(k,1);
            k2 = g.edges(k,2);
            vx = g.nodes(k2).position(1) - g.nodes(k1).position(1);
            vy = g.nodes(k2).position(2) - g.nodes(k1).position(2);
            len = sqrt(vx*vx + vy*vy);
            if len == 0, continue; end
            f = (normlen-len) / (len * 3);
            dx = attstng * f * vx;
            dy = attstng * f * vy;
            dist(k2,1) = dist(k2,1) + dx;
            dist(k2,2) = dist(k2,2) + dy;
            dist(k1,1) = dist(k1,1) - dx;
            dist(k1,2) = dist(k1,2) - dy;
        end
        
        x = repmat(position(:,1), 1, n);
        dx = x - x';
        y = repmat(position(:,2), 1, n);
        dy = y - y';
        % distance matrix, each element represent distance between row node and
        % column node
        len = sqrt(dx.*dx + dy.*dy);

        % attractive force
        af = len .* adj;
        f = (normlen - af) ./ (af .* 3);
        dx = attstng * f .* dx;
        dy = attstng * f .* dy;
        dx(find(~isfinite(dx))) = 0;
        dy(find(~isfinite(dy))) = 0;
        ndist = ndist + [sum(dx,2) sum(dy,2)];

    else
        sp = vertcat(g.nodes(g.edges(:,1)).position);
        ep = vertcat(g.nodes(g.edges(:,2)).position);
        vx = ep(:,1) - sp(:,1);
        vy = ep(:,2) - sp(:,2);
        len = sqrt(vx.*vx + vy.*vy);
        len(find(len==0)) = nan;
        f = (normlen-len) ./ (len .* 3);
        dx = attstng .* f .* vx;
        dy = attstng .* f .* vy;
        dx(isnan(dx)) = 0;
        dy(isnan(dy)) = 0;
        dist(g.edges(:,2),1) = dist(g.edges(:,2),1) + dx;
        dist(g.edges(:,2),2) = dist(g.edges(:,2),2) + dy;
        dist(g.edges(:,1),1) = dist(g.edges(:,1),1) - dx;
        dist(g.edges(:,1),2) = dist(g.edges(:,1),2) - dy;
    end

    for k1 = 1:n
        % continue;
        if 1
            dx = 0;
            dy = 0;
            for k2 = 1:n
                if k1 == k2, continue; end
                vx = g.nodes(k1).position(1) - g.nodes(k2).position(1);
                vy = g.nodes(k1).position(2) - g.nodes(k2).position(2);
                len = vx*vx + vy*vy;
                len = len - g.nodeSize;
                if len <= 0
                    dy = rand * g.nodeSize;
                    dx = rand * g.nodeSize;
                else
                    dx = dx + normlen * vx / (len^2);
                    dy = dy + normlen * vy / (len^2);
                end
            end
        else
            p2 = vertcat(g.nodes.position);
            vx = g.nodes(k1).position(1) - p2(:,1);
            vy = g.nodes(k1).position(2) - p2(:,2);
            len = vx.*vx + vy.*vy;
            zidx = find(len==0);
            len(zidx) = 1;
            dx = normlen .* vx ./ (len.^2);
            dy = normlen .* vy ./ (len.^2);
            dx(zidx) = rand(1,length(zidx)) * g.nodeSize;
            dy(zidx) = rand(1,length(zidx)) * g.nodeSize;
            dx(isnan(dx)) = 0;
            dy(isnan(dy)) = 0;
            dx = sum(dx);
            dy = sum(dy);
        end

        dlen = sqrt(dx*dx+dy*dy)/2;
        if dlen == 0, continue; end
        dist(k1,1) = dist(k1,1) + repstng * dx/dlen;
        dist(k1,2) = dist(k1,2) + repstng * dy/dlen;
    end
    for k = 1:n
        dx = min(max(-snag,dist(k,1)),snag);
        dy = min(max(-snag,dist(k,2)),snag);
        g.nodes(k).position(1) = g.nodes(k).position(1) + dx;
        g.nodes(k).position(2) = g.nodes(k).position(2) + dy;
        if g.nodes(k).position(1) < minb
            g.nodes(k).position(1) = minb;
        elseif g.nodes(k).position(1) > maxb
            g.nodes(k).position(1) = maxb;
        end
        if g.nodes(k).position(2) < minb
            g.nodes(k).position(2) = minb;
        elseif g.nodes(k).position(2) > maxb
            g.nodes(k).position(2) = maxb;
        end
        dist(k) = dist(k) ./ 2;
    end
    if 0
        cla
        plot(g)
        pause(0.1)
        drawnow
    end
end
warning(wn);