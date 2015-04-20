function g = graph(varargin)
% graph - graph object constructor
%
%   g = graph create a graph using GUI
%
%   g = graph(adj)      adjecency matrix, give symmetric matrix for
%   undirected graph
%   g = graph(adj, nodeLabels) adjecency matrix with node id
%   g = graph(adj, nodeLabels, graphName)
%
%   g = graph(elist)    edge list in cell array or numeric matrix
%   g = graph(elist, nodeLabels) edge list in cell array
%   g = graph(ig, nodelist) from a parent graph with node list
%
%   g = graph(nNode) generated Erdos-Reyni random graph with nNode number
%   of node and node probability of 1.5 times probability that gaint
%   components commence.
%   
%   g = graph(nNode, p) given that (p >= 0.0 and p <= 1.0) generated Erdos-Reyni
%   undirected random graph on n vertices with edge probability of of p. 
%
%   g = graph(nNode, k) generated Erdos-Reyni undirected random graph with
%   nNode number of nodes and k number of links.
%
%   g = graph('filename') create a graph as defined in file. Supported file
%   format are SIF, SBML, GML, DOT and node pair.
%   g = graph('sbml_file_name.xml') build reaction network from given sbml file
%       Matlab sbml tool box required.
%   g = graph('file_name.sif') build graph from given Simple Interaction
%   File (SIF). SIF is a tab delimited text file containing names of two
%   nodes with link name in between them.
%   g = graph('file_name.txt') file consists just pair of linking nodes
%   G = GRAPH(PG, NODEIDS) create a graph from parent graph PG of selected
%   nodes list NODEIDS. 
%
% Native graph data structure is link list and assume directed. The
% function edges give link list. Undirected graph is archieve by setting
% directed = 0, or set(g, 'directed', 0). Although native graph data
% structre assume directed, this package concern more on undirected graph.
%
%   Use set and get to change graph parameters, such as node color.
%
% Example:
%   g = graph(10); % randomly generate 10-node graph
%
% See also: adjacency, edges, node, set, get
%

%
% Kyaw Tun, RIKEN, Japan
% 2006 Oct
%

% TODO:
% 1) use adjacency matrix as basic data structure of graph
% 2) remove assumption about lazy initialization

% constants
UBQ_MAIN = 1; % take entities as ubiquiton if not main reactant or product
UBQ_UBQ = 2; % take ubiquiton as those over critical point in vertex degree distribution
UBQ_ARB = 3; % take ubiquiton as those over arbitratory threshold

ARB_TH = 17; % arbitratory threshould (this should be depend on network size)

% default variable
ubiquiton = UBQ_ARB;

% premative graph structure
g.nodes = [];
g.edges = [];
g.nodeSize = 0.015;
g.name = '';

% catched field 
g.directed = [];
g.modmat = [];
g.adj = [];

% sample named graphs
graphnames = {'group3', 'group4', 'karate', 'complete'};
graphs = {
[0 1 1 1 0 0 0 0 0 0 0 0;1 0 1 1 0 0 0 0 0 0 0 0;1 1 0 1 1 0 0 0 1 0 0 0;1 1 1 0 0 0 0 0 0 0 0 0;0 0 1 0 0 1 1 1 0 0 0 0;0 0 0 0 1 0 1 1 0 0 0 0;0 0 0 0 1 1 0 1 0 0 0 1;0 0 0 0 1 1 1 0 0 0 0 0;0 0 1 0 0 0 0 0 0 1 1 1;0 0 0 0 0 0 0 0 1 0 1 1;0 0 0 0 0 0 0 0 1 1 0 1;0 0 0 0 0 0 1 0 1 1 1 0]
[0 1 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;1 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;1 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;0 0 1 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0;1 1 0 1 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0;0 0 0 1 0 0 1 0 0 1 0 0 0 0 0 0 0 0 0 0;0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0;0 0 0 0 0 0 1 2 1 1 0 0 0 0 0 0 0 0 0 0;0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0;0 0 0 0 0 1 0 1 1 0 0 0 0 0 0 1 0 0 0 0;0 0 0 0 0 0 0 0 0 0 0 1 1 1 0 0 0 0 0 0;0 0 0 0 1 0 0 0 0 0 1 0 1 1 0 0 0 0 0 0;0 0 0 0 0 0 0 0 0 0 1 1 0 1 1 0 0 0 0 0;0 0 0 0 0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0;0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 1 1 0 1 0;0 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 1 0 1;0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 1 0 1;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 1 0;0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 1 0 0;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0]
[0 1 1 1 1 1 1 1 0 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 1 0;1 0 1 1 0 0 0 0 0 1 0 0 0 1 0 0 0 0 0 0 0 0 0 1 0 0;1 1 0 1 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 1;1 1 1 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;1 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;1 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;1 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1;0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 1 0 0 1;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 1 0;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 0;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0;0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0;0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 1 0 0 0 0 0 1;0 1 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 1 0 0 0 1;0 0 1 0 0 0 0 1 0 0 1 1 1 0 1 1 1 0 0 0 0 0 1 1 1 0]
};

% temporary variables
nodeLabels = {};
positions = [];


if nargin == 0
    fig = figure('BackingStore', 'on', 'IntegerHandle', 'off', 'Name', 'Adjacency Matrix' ...
        ,'NumberTitle', 'off', 'MenuBar', 'none', 'DoubleBuffer','on');

    title(sprintf('Double click to create vertex. Single click to connect.\nRight click to delete. Enter to finish.'))
    xlim([0 10]);
    ylim([0 10]);
    nullgraph = graph([1 0; 1 0]);
    setappdata(fig, 'nullgraph', nullgraph);
    set(fig,'WindowButtonDownFcn', {@uigraph, 'down'});
    set(fig,'KeyPressFcn', {@uigraph, 'keypress'})
    set(fig,'CloseRequestFcn', {@closeuigraph, fig});
    uiwait(fig);
    adj = getappdata(fig,'Matrix');
    g = graph(adj);
    delete(fig);
    return;
elseif nargin >= 1
    if ischar(varargin{1}) && ismember(varargin{1}, graphnames)
        idx = strmatch(varargin{1}, graphnames, 'exact');
        if idx == length(graphnames)
            if nargin > 1
                n = varargin{2};
            else
                n = 4;
            end
            adj = ones(n,n);
            for k1 = 1:n, adj(k1, k1) = 0; end
            g = graph(adj);
            g.name = sprintf('%d complete graph', n);
        else
            g = graph(graphs{idx});
            g.name = graphnames{idx};
        end
        return
    end
    if nargin == 1 && ischar(varargin{1}) % a file name
        if length(varargin{1}) > 3 && isequal(varargin{1}(end-3:end), '.sif')
            % SIF file
            [n1, link, n2] = textread(varargin{1}, '%s%s%s', 'bufsize', 16777216);
            nodeLabels = union(n1, n2);
            n = length(nodeLabels);
            for k1 = 1:min(length(n1), length(n2))
                %kn1 = strmatch(n1{k1}, nodeLabels, 'exact');
                %kn2 = strmatch(n2{k1}, nodeLabels, 'exact');
                kn1 = find(strcmp(nodeLabels, n1{k1}));                
                kn2 = find(strcmp(nodeLabels, n2{k1}));
                g.edges(end+1, 1:2) = [kn1, kn2];
            end
            adj = sparse(n, n);
            for k = 1:size(g.edges,1)
                adj(g.edges(k,1),g.edges(k,2)) = 1;
            end
        elseif length(varargin{1}) > 3 && isequal(varargin{1}(end-3:end), '.gml')
            str = textread(varargin{1}, '%s', 'whitespace','', 'bufsize', 16777216); % read large file quickly
            str = str{:}; 
            % we have to smart when dealing with large string, don't touch
            % it, we use regular expression
            source = regexp(str, '\ssource\s(\d+)', 'tokens');
            target = regexp(str, '\starget\s(\d+)', 'tokens'); 
            id = regexp(str, '\sid\s(\d+)\s', 'tokens');
            ids = zeros(1,length(id));            
            n = length(id);
            for k = 1:n; ids(k) = str2double(id{k}{:}); end
            x = regexp(str, 'x\s((-)?\d+.\d+)', 'tokens');
            y = regexp(str, 'y\s((-)?\d+.\d+)', 'tokens');
            positions = zeros(n,2);
            try
                positions(:,1) = str2double([x{:}]);
                positions(:,2) = str2double([y{:}]);
                % positions(:,1) = positions(:,1) / (max(positions(:,1))+0.05);
                % positions(:,2) = positions(:,2) / (max(positions(:,2))+0.05);
                positions(:,2) = max(positions(:,2)) - positions(:,2);
            catch
                positions = [];
            end
            label =  regexp(str, '\slabel\s"(\w+)"', 'tokens');            
            nodeLabels = [label{1:n}]; % the rest may be label for edges
            for k = 1:length(source)
                g.edges(end+1, 1:2) = [find(ids==str2double(source{k}{:})), ...
                    find(ids==str2double(target{k}{:}))]; 
            end
            d = regexp(str, 'directed\s(\d)', 'tokens');
            if ~isempty(d)
                g.directed = str2double(d{1}{:});
            end
            if ~g.directed
                g.edges(end+1:end+size(g.edges,1), 1:2) = g.edges(:, [2 1]);
            end
        elseif length(varargin{1}) > 3 && isequal(varargin{1}(end-3:end), '.xml')
            % assume SBML file
            m = TranslateSBML(varargin{1});
            n = length(m.species);
            if isfield(m.species, 'id')
                labels = {m.species.id};
            else
                labels = {m.species.name};
            end
            % first we construct incident matrix
            % with row corresponding to metabolite and column corresponding
            % to reactions
            nr = length(m.reaction);
            ic = zeros(n, nr);
            dirs = [m.reaction.reversible];
            for k1 = 1:length(m.reaction)
                rs = [];
                ps = [];
                % % debug code
                % if isequal(m.reaction(k1).id, 'R03270')
                %    disp('reach');
                % end
                for k2 = 1:length(m.reaction(k1).reactant)
                    r = strmatch(m.reaction(k1).reactant(k2).species, labels, 'exact');
                    if isempty(r)
                        error('graph:sbml', ['Invalid reaction: ', m.reaction(k1).name]);
                    end
                    rs(end+1) = r(1);
                end
                for k3 = 1:length(m.reaction(k1).product)
                    p = strmatch(m.reaction(k1).product(k3).species, labels, 'exact');
                    if isempty(p)
                        error('graph:sbml', ['Invalid reaction: ', m.reaction(k1).name]);
                    end
                    ps(end+1) = p(1);
                end
                if isempty(ps) || isempty(rs)
                    warning('graph:sbml', ['Invalid reaction: ', m.reaction(k1).name, ' skipped']);
                    continue;
                end
                ic(rs,k1) = -1;
                ic(ps,k1) = 1;

            end
            % here we can build two kind of graph
            % enzyme graph (enzyme as node) or metabolite graph (metabolite
            % as node)            
            % for the time being, we will do only enzyme graph
            
            % Remove ubiquiton
            % before we do, there are ubiquiton like H20 it will link all
            % enzyme incorrectly, so we remove than, we take only one
            % reaction and one product for a reaction
            % There are several way to get rid of ubiquiton
            deg = sum(abs(ic),2);
            if ubiquiton == UBQ_MAIN
                % Method ONE: main product - main reactant
                icc = zeros(size(ic));
                for k1 = 1:size(ic,2)
                    rs = find(ic(:,k1)<0);
                    ps = find(ic(:,k1)>0);
                    [foo, mi] = min(deg(rs));
                    icc(rs(mi),k1) = -1;
                    [foo, mi] = min(deg(ps));
                    icc(ps(mi),k1) = 1;
                end
            elseif ubiquiton == UBQ_UBQ
                % Method TWO: remove motabolites more than critical
                % threashold
                [sdeg, ideg] = sort(deg);
                degdiff = diff(sdeg); 
                
                error('This method not implemented.');
            elseif ubiquiton == UBQ_ARB
                % Method THREE: remove motabolites more than arbitrary
                % threashold
                arb = ARB_TH;
                [sdeg, ideg] = sort(deg);
                ubq = ideg(end-arb:end);
                icc = ic;
                icc(ubq,:) = 0;
            else
                % Method THREE: No removal
            end
            
            % build enzyme (reaction) as node
            if isfield(m.reaction, 'id')
                nodeLabels = {m.reaction.id}; % level 1
            else
                nodeLabels = {m.reaction.name};
            end
            n = length(nodeLabels);
            for k1 = 1:size(icc,1)
                igs = find(icc(k1,:)<0);
                ogs = find(icc(k1,:)>0);
                for k2 = 1:length(igs)
                    for k3 = 1:length(ogs)
                        g.edges(end+1,1:2) = [igs(k2), ogs(k3)];
                    end
                end
            end         
        else
            % assume just pair or nodes
            [n1, n2] = textread(varargin{1}, '%s%s', 'commentstyle', 'matlab');
            nodeLabels = union(n1, n2);
            n = length(nodeLabels);
            for k1 = 1:min(length(n1), length(n2))
                %kn1 = strmatch(n1{k1}, nodeLabels, 'exact');
                %kn2 = strmatch(n2{k1}, nodeLabels, 'exact');
                kn1 = find(strcmp(nodeLabels, n1{k1}));                
                kn2 = find(strcmp(nodeLabels, n2{k1}));
                g.edges(end+1, 1:2) = [kn1, kn2];
            end          
        end
        g.name = getName(varargin{1});
    elseif isequal(class(varargin{1}), 'graph')
        % from a parent graph
        g = varargin{1};
        adj = adjacency(g);
        if nargin >= 2 && isnumeric(varargin{2})
            ig = varargin{2};
            if length(ig) ~= length(unique(ig))
                error('Node ids must be unique.');
            end
        elseif nargin >= 2 && isequal(varargin{2}, 'visited')
            ig = find([g.nodes.visited]);
        else
            ig = 1:length(adj);
        end
        nodeLabels = {g.nodes.label};
        name = g.name;
        colors = {g.nodes.color};

        g = graph(adj(ig, ig), nodeLabels(ig));
        g.name = [name, '->', num2str(length(ig))];
        g = set(g, 'color', colors(ig));
        return;
    elseif isnumeric(varargin{1}) && length(varargin{1}) == 1
        % generate graph randomly by Erdos-Reyni random graphs 
        n = varargin{1};
        mode = 'Erdos-Reyni';
        if nargin == 3
            mode = varargin{3};
        end
        switch mode
            case {'randperm', 'rp'}
                if nargin >= 2 && ~isempty(varargin{2})
                    k = varargin{2}(1);
                else
                    k = 0.01;
                end
                nk = ceil(n*k/2)*2;
                p = randperm(nk);
                elist = reshape(p,nk/2,2);
                g.edges = mod(elist,n)+1;
                g.directed = 0;
                g.name = sprintf('rp random graph %g', k);
            otherwise
                if nargin < 2
                    % a giant connected component should emerge when 
                    % p > 1/(n-1). 
                    p = 1.5 * 1/(n-1);
                else
                    p = varargin{2}(1);
                end
                if p < 0, error('Probability or number of edges cannot be negative.'); end
                if p <= 1.0
                    adj = rand(n,n) < p; % adjacency matrix
                else
                    % number of edges is given
                    adj = rand(n,n);
                    adj = triu(adj,1);
                    [i, j, v] = find(adj);
                    [y, si] = sort(v);
                    % take first p number of links
                    if p < length(si)
                        toDelete = si(p+1:end);
                        for kd = 1:length(toDelete)
                            adj(i(toDelete(kd)), j(toDelete(kd))) = 0;
                        end
                    end
                    adj = adj > 0.0;
                end                
                adj = triu(adj,1);
                adj = adj + adj'; % make undirected graph
                g = graph(adj);
                g.name = sprintf('Erdos-Reyni random graph %g', p);
                return;
        end
    elseif (isnumeric(varargin{1}) || islogical(varargin{1})) && ...
            size(varargin{1},1) == size(varargin{1},2)
        % adjacency matrix
        g.adj = sparse(varargin{1});
        n = length(g.adj);
        if size(g.adj,1) ~= size(g.adj,2)
            error('Adjacency matrix must be square.');
        end
        [e1, e2] = find(g.adj);
        g.edges = [e1, e2];
        if nargin > 1 
            if length(g.adj) ~= length(varargin{2}) 
                error('Label names must be same length as adjacency matrix');
            end
            if isnumeric(varargin{2})
                nodeLabels = cell(1,length(varargin{2}));
                for kv2 = 1:length(varargin{2});
                    nodeLabels{kv2} = num2str(varargin{2}(kv2));
                end
            else
                nodeLabels = varargin{2};
            end
        end
        if nargin > 2
            g.name = varargin{3};
        end
        if nargin > 3
            positions = varargin{4};
        end

    elseif iscell(varargin{1})
        % cell array of edges
        n = 0;
        for k = 1:length(varargin{1})
            g.edges(k,1:2) = varargin{1}{k};
            n = max([n, g.edges(k,1:2)]);
        end
    elseif isnumeric(varargin{1}) && size(varargin{1},2) == 2 && min(varargin{1}(:)) == 1 
        % edge list
        % support to be cell array of edges
        n = 0;
        for k = 1:size(varargin{1},1)
            g.edges(k,1:2) = varargin{1}(k,1:2);
            n = max([n, g.edges(k,1:2)]);
        end        
    elseif isnumeric(varargin{1}) 
        % assume incident matrix
        x = varargin{1};
        if min(x(:)) > 0
            error('Assumed incident matrix must contained negative value for link out.');
        end
        es = [];
        for kx = 1:size(x,2) % along column of edge
            ins = find(x(:,kx)>0);
            outs = find(x(:,kx)<0);
            for ki = ins
                for ko = outs
                    es(end+1,1:2) = [ki, ko];
                end
            end
        end
        g = graph(es);
        return;
    else
        error('Unreconginized input format.');
    end
end


if isempty(nodeLabels) && (nargin >= 2 && iscell(varargin{2}))
    nodeLabels = varargin{2};
    if length(nodeLabels) ~= n
        error('Node label must be the same dimension as adjacency matrix');
    end
end
if isempty(nodeLabels)
    for k = 1:n
        nodeLabels{k} = num2str(k);
    end
end


if isempty(positions)
    r = 0.4;
    theta = 2*pi/n;    
    positions = [0.5 + r * cos(theta*([1:n]'-1)), ...
        0.5 + r * sin(theta*([1:n]'-1))];
end
for k = 1:n
    g.nodes(k).label = strtrim(nodeLabels{k});
    g.nodes(k).position = positions(k,:);
    % g.position(k,:) = positions(k,:);
    g.nodes(k).visited = 0;
    g.nodes(k).timeStamp = 0;
    g.nodes(k).color = 'w';
    g.nodes(k).groupid = -1;
end

if isempty(g.adj)
    g.adj = sparse(n, n);
    for k = 1:size(g.edges,1)
        g.adj(g.edges(k,1),g.edges(k,2)) = g.adj(g.edges(k,1),g.edges(k,2)) + 1;
    end
end

g = class(g, 'graph');

        
    
function s = getName(s)

sl = find(s==filesep);
if ~isempty(sl) && length(s) > sl(end)
    s = s(sl(end)+1:end);
end
dot = find(s=='.');
s = s(1:dot(end)-1);

function closeuigraph(varargin)

uiresume(varargin{3});


function uigraph(foo, foo2, action, varargin)
%
% ADJ_MATRIX_GUI
% Opens a figure.  Double click to create a vertex. Single click to 
% connect vertices.  Right click to delete vertices or edges.


if nargin == 0
    action = 'init';
end

switch action
case 'motion'
    line_h = getappdata(gcf,'motionline');
    pt = get(gca,'CurrentPoint');
    pt = pt(1,:);
    xdata = get(line_h,'XData');
    ydata = get(line_h,'YData');
    xdata(2) = pt(1);
    ydata(2) = pt(2);
    set(line_h,'XData',xdata,'YData',ydata)
case 'down'
    button = get(gcf,'SelectionType');
    switch button
    case 'normal'
        h = gco;
        fig = gcf;
        
        % First click
        if ~isappdata(fig, 'motionline')
            if isequal(get(h,'Type'),'text')
                pt = get(h,'Position');
                hold on
                line_h = plot(pt(1), pt(2),'b-.' ...
                                          ,'EraseMode','normal');
                setappdata(line_h,'startobj',h)    % Save start object
                hold off
                stack_text_on_top
                setappdata(fig,'motionline',line_h)
                set(fig,'WindowButtonMotionFcn', {@uigraph, 'motion'});
            end
        else
        % Second click
            line_h = getappdata(fig,'motionline');

            if isequal(get(gco,'Type'),'text')
                startobj = getappdata(line_h,'startobj');
                endobj = gco;
                startpt = get(startobj,'Position');
                endpt = get(endobj,'Position');
                set(line_h,'XData',[startpt(1) endpt(1)] ...
                          ,'YData',[startpt(2) endpt(2)]);
                I = round(str2double(get(startobj,'String')));
                J = round(str2double(get(endobj,'String')));
                Matrix = getappdata(gcf,'Matrix');
                Matrix(I,J) = Matrix(I,J)+1;
                Matrix(J,I) = Matrix(J,I)+1;
                setappdata(gcf,'Matrix',Matrix)
            else
                delete(line_h)
            end
            
            rmappdata(gcf,'motionline')
            set(fig,'WindowButtonMotionFcn', '');
        end
    case 'open'
        pt = get(gca,'CurrentPoint');
        pt = pt(1,:);
        hold on
        n = 1+length(findobj(get(gca,'Children'),'Type','text'));
        h = text(pt(1),pt(2),num2str(n) ...
                            ,'Color','r','FontWeight','bold');
        hold off
        if ~isappdata(gcf,'Matrix')
            setappdata(gcf,'Matrix',[])
        end
        Matrix = getappdata(gcf,'Matrix');
        Matrix(n,n) = 0;
        setappdata(gcf,'Matrix',Matrix)
    case 'alt'
        switch get(gco,'Type')
        case 'text'
            n = round(str2double(get(gco,'String')));
            pt = get(gco,'Position');
            handles = get(gca,'Children');
            for I=1:length(handles)
                h = handles(I);
                if isequal(get(h,'Type'),'text')
                    n2 = round(str2double(get(h,'String')));
                    if n2 > n
                        set(h,'String',n2-1)
                    end
                else
                    xdata = get(h,'XData');
                    ydata = get(h,'YData');
                    if (xdata(1) == pt(1) & ydata(1) == pt(2)) ...
                    |  (xdata(2) == pt(1) & ydata(2) == pt(2))
                        delete(h)
                    end
                end
            end
            if isappdata(gcf,'Matrix')
                Matrix = getappdata(gcf,'Matrix');
                Matrix(n,:) = [];
                Matrix(:,n) = [];
                setappdata(gcf,'Matrix',Matrix)
            end
            delete(gco)
        case 'line'
            xdata = get(gco,'XData');
            ydata = get(gco,'YData');
            txt_h = findobj(get(gca,'Children'),'Type','text');
            for K=1:length(txt_h)
                h = txt_h(K);
                pt = get(h,'Position');
                if (xdata(1) == pt(1) & ydata(1) == pt(2))
                    I = round(str2double(get(h,'String')));
                elseif (xdata(2) == pt(1) & ydata(2) == pt(2))
                    J = round(str2double(get(h,'String')));
                end
            end
            if isappdata(gcf,'Matrix')
                Matrix = getappdata(gcf,'Matrix');
                Matrix(I,J) = Matrix(I,J)-1;
                Matrix(J,I) = Matrix(J,I)-1;
                setappdata(gcf,'Matrix',Matrix)
            end
            delete(gco)
        end % End object switch
    end % End button switch
case 'keypress'
    ESC = 27;
    ENTER = 13';
    switch get(gcf,'CurrentCharacter')
    case ESC
        if isappdata(gcf,'motionline')
            line_h = getappdata(gcf,'motionline');
            delete(line_h)
                    
            rmappdata(gcf,'motionline')
        end
        set(gcf,'WindowButtonMotionFcn', '');
    case ENTER
        uiresume(gcf);
    end
case 'init'
    fig = figure('BackingStore', 'on', 'IntegerHandle', 'off', 'Name', 'Adjacency Matrix' ...
            ,'NumberTitle', 'off', 'MenuBar', 'none', 'DoubleBuffer','on');

    title('Double click to create vertex. Single click to connect. Right click to delete')
    set(fig,'WindowButtonDownFcn', {@uigraph, 'down'});
    set(fig,'KeyPressFcn', {@uigraph, 'keypress'})

otherwise
    error(['Unknown - ' action])
end % End action switch

function stack_text_on_top
    ax = gca;
    handles = get(gca,'Children');
    txt_h = findobj(handles,'Type','text');
    
    set(gca,'Children',[txt_h; setdiff(handles,txt_h)])


 
