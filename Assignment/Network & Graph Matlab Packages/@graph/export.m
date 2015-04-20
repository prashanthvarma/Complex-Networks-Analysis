function export(g, fn)
% export    - save graph into various file format
%
% export(g, filename) export the graph to give file name for given
% output file type. Supported file file type are SIF, GML and DOT.
%
% export(g, filename) export with default SIF format

% Kyaw Tun, RIKEN 2006

% DOT is inspired by by Dr. Leon Peshkin, Jan 2004

scale = 30/0.015;

fi = fopen(fn, 'w');
if fi < 1, error('Error opening file.'); end
if length(fn) > 5 && isequal(fn(end-5:end), '.pairs')
    for k = 1:length(g.edges)
        fprintf(fi, '%d\t%d\n', g.edges(k,1), g.edges(k,2));
    end
elseif length(fn) > 3 && isequal(fn(end-3:end), '.dot')
    width = scale*g.nodeSize;
    height = scale*g.nodeSize;
    leftright = 0;
    adj = adjacency(g);
    if directed(g)
        fprintf(fi, 'digraph G {\n');
        arctxt = '->';
        labeltxt = '';
    else
        fprintf(fi, 'graph G {\n');
        arctxt = '--';
        labeltxt = '[dir=none]';
    end
    fprintf(fi, 'center = 1;\n');
    fprintf(fi, 'size=\"%d,%d\";\n', width, height);
    if leftright
        fprintf(fi, 'rankdir=LR;\n');
    end
    fprintf(fi, 'node [	style = filled];');
    Nnds = length(adj);
    for node = 1:Nnds               % process NODEs
        att = 'shape="circle", ';
        if isequal(g.nodes(node).color, 'w') || isequal(g.nodes(node).color, '#ffffff')
            % att = ' style = dotted, ';
        end
        fprintf(fi, '%d [ label = "%s", %spos="%d,%d", fillcolor="%s" ];\n', ...
            node, g.nodes(node).label, att, ...
            round(scale*g.nodes(node).position(1)), ...
            round(scale*g.nodes(node).position(2)), ...
            tohex(g.nodes(node).color));
    end
    edgeformat = strcat(['%d ',arctxt,' %d ',labeltxt,';\n']);
    for node1 = 1:Nnds              % process ARCs
        if g.directed
            arcs = find(adj(node1,:));         % children(adj, node);
        else
            arcs = find(adj(node1,node1+1:Nnds)) + node1; % remove duplicate arcs
        end
        for node2 = arcs
           fprintf(fi, edgeformat, node1, node2);
        end
    end
    fprintf(fi, '}');
elseif length(fn) > 3 && isequal(fn(end-3:end), '.gml')
    fprintf(fi, 'Creator\t"MATLAB Graph Package"\n');
    fprintf(fi, 'Version\t"2.4.1"\n');
    % graph
    fprintf(fi, 'graph\n[\n');
    fprintf(fi, '\tlabel\t"%s"\n', g.name);
    fprintf(fi, '\tdirected\t%d\n', directed(g));
    groupPos = {};
    for k = 1:length(g.nodes)
        % print nodes
        fprintf(fi, '\tnode\n\t[\n');
        fprintf(fi, '\t\tid\t%d\n', k);
        fprintf(fi, '\t\tlabel\t"%s"\n', g.nodes(k).label);
        fprintf(fi, '\t\tgraphics\n\t\t[\n');
        x = scale*(g.nodes(k).position(1)-g.nodeSize/2);
        y = scale*(g.nodes(k).position(2)-g.nodeSize/2);
        w = scale*g.nodeSize;
        h = w;
        fprintf(fi, '\t\t\tx\t%f\n', x);
        fprintf(fi, '\t\t\ty\t%f\n', y);
        fprintf(fi, '\t\t\tw\t%f\n', w);
        fprintf(fi, '\t\t\th\t%f\n', h);
        fprintf(fi, '\t\t\ttype\t"ellipse"\n');
        fprintf(fi, '\t\t\twidth\t1.0\n');
        fprintf(fi, '\t\t\tfill\t"%s"\n', tohex(g.nodes(k).color));
        fprintf(fi, '\t\t\toutline\t"#000000"\n');
        fprintf(fi, '\t\t]\n');
        gpid = g.nodes(k).groupid;
        if gpid > 0
            fprintf(fi, '\t\tgid\t%d\n', gpid + length(g.nodes));
            if length(groupPos) < gpid || isempty(groupPos{gpid})
                groupPos{gpid} = [x, y, w, h];
            else
                gx1 = groupPos{gpid}(1)-w/2;
                gx2 = groupPos{gpid}(2)+w/2;
                gy1 = groupPos{gpid}(3)-h/2;
                gy2 = groupPos{gpid}(4)+h/2;
                groupPos{gpid}(1) = min(gx1, x-w/2) + w/2;
                groupPos{gpid}(2) = min(gx2, x+w/2) - w/2;
                groupPos{gpid}(3) = min(gy1, x-h/2) + h/2;
                groupPos{gpid}(4) = min(gy2, x+h/2) - h/2;
            end
        end
        fprintf(fi, '\t]\n');
    end
    for k = 1:length(groupPos)
        if isempty(groupPos{k}), continue; end
        fprintf(fi, '\tnode\n\t[\n');
        fprintf(fi, '\t\tid\t%d\n', length(g.nodes)+k);
        fprintf(fi, '\t\tlabel\t"Group %d"\n', k);
        fprintf(fi, '\t\tgraphics\n\t\t[\n');
        fprintf(fi, '\t\t\tx\t%f\n', groupPos{k}(1));
        fprintf(fi, '\t\t\ty\t%f\n', groupPos{k}(2));
        fprintf(fi, '\t\t\tw\t%f\n', groupPos{k}(3));
        fprintf(fi, '\t\t\th\t%f\n', groupPos{k}(4));
        fprintf(fi, '\t\t\ttype\t"rectangle"\n');
        fprintf(fi, '\t\t\twidth\t1.0\n');
        fprintf(fi, '\t\t\tfill\t"%s"\n', '#FFFFFF');
        fprintf(fi, '\t\t\toutline\t"#FFFFFF"\n');
        fprintf(fi, '\t\t]\n');
        fprintf(fi, '\t\tisGroup\t%d\n', 1);
        fprintf(fi, '\t]\n');
    end
    d = directed(g);
    for k = 1:length(g.edges)
        % print edges
        if ~d
            if g.edges(k,1) > g.edges(k,2)
                % we do not want the edge be repeated
                continue;
            end
        end
        fprintf(fi, '\tedge\n\t[\n');
        fprintf(fi, '\t\tsource\t%d\n', g.edges(k,1));
        fprintf(fi, '\t\ttarget\t%d\n', g.edges(k,2));
        % fprintf(fi, '\t\tlabel\t"e%d_%d"\n', g.edges(k,1), g.edges(k,2));
        fprintf(fi, '\t\tgraphics\n\t\t[\n');
        fprintf(fi, '\t\t\twidth\t1.0\n');
        fprintf(fi, '\t\t\ttype\t"line"\n');
        c = g.nodes(g.edges(k,1)).color;
        if isequal(c, g.nodes(g.edges(k,2)).color) && ~isequal(c, 'w')
            c = tohex(c);
        else
            c = '#000000';
        end
        fprintf(fi, '\t\t\tfill\t"%s"\n', c);
        fprintf(fi, '\t\t]\n');
        fprintf(fi, '\t]\n');
    end
    fprintf(fi, ']\n');
elseif length(fn) > 3 && isequal(fn(end-3:end), '.sif')
    for k = 1:length(g.edges)
        fprintf(fi, '%s\te%d_%d\t%s\n', g.nodes(g.edges(k, 1)).label, ...
            g.edges(k,1), g.edges(k,2), g.nodes(g.edges(k, 2)).label);
    end
else
    error('Unknown file format');
end
fclose(fi);

function h = tohex(s)
% convert to hex rgb

if isnumeric(s) || s(1) == '[' % must be RGB value
    if ischar(s)
        s = str2num(s);
    end
    h = ['#', dec2hex(round(s(1)*256), 2),dec2hex(round(s(2)*256), 2), dec2hex(round(s(3)*256), 2)];
    return;
end

switch lower(s)
    case {'k', 'black'}
        h = '#000000';
    case {'w', 'white'}
        h = '#FFFFFF';
    case {'r', 'red'}
        h = '#FF0000';
    case {'g', 'green'}
        h = '#00FF00';
    case {'b', 'blue'}
        h = '#0000FF';
    case {'y', 'yellow'}
        h = '#FFFF00';
    case {'m', 'magenta'}
        h = '#FF00FF';
    case {'c', 'cyan'}
        h = '#00FFFF';
    case {'gray'}
        h = '#808080';
    otherwise
        h = '#FFFFFF';
end



