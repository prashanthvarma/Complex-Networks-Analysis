function g = set(g, varargin)
% SET   - setter in parameter value format
%
% Available parameters are:
% directed      - 1 make directed grpah, 0 make undirected. undirected graph
%                 reduce muli-edge to single edge
% nodelabels    - set all node labels
% nodeLabel     - g = SET(g, 'nodeLabel', {1, 'new label for note 1'}) set 
%                 node label for a given node
% nodeColor     - change node color, e.g. 'y' for all node yellow color
%                 {'w', 'g', 'w', 'y', ...} to set undividually. [1 2 1 3
%                 ...] also work. Empty value color accroding to group id.
% group         - set group id. value must be a vector corresponding to each
%                 node. If group is not sequence start with 1, group id
%                 will be reassign.
% name          - set name of graph
%
%   See also: GET

for k = 1:2:length(varargin)
    switch lower(varargin{k})
        case {'nodelabel'}            
            if ~iscell(varargin{k+1}) || length(varargin{k+1}) ~= 2
                error('Invalid number of arguments for nodelabel.'); 
            end
            g.nodes(varargin{k+1}{1}).label = varargin{k+1}{2};
        case {'labels', 'nodelabels', 'names', 'nodenames'}
            v = varargin{k+1};
            if length(v) ~= length(g.nodes)
                error('Invalid value for node labels');
            end
            if isnumeric(v)
                v = arrayfun(@mat2str, v, 'UniformOutput', false);
            elseif ischar(v)
                v = cellstr(v(:));
            end
            for k = 1:length(v)
                g.nodes(k).label = v{k};
            end
        case {'directed', 'd'}
            if isequal(varargin{k+1}, 1)
                g.directed = 1;
            elseif isequal(varargin{k+1}, 0)
                if g.directed == 0, return; end
                % TODO: this need to change, lost positioning, grouping,
                % color
                adj = adjacency(g);
                adj = adj + (adj' - diag(diag(adj)));
                name = g.name;
                g = graph(adj, {g.nodes.label});
                g.name = name;
                g.directed = 0;
            else
                error(['Invalid parameter: ', varargin{k}]);
            end
        case {'group', 'g', 'gid', 'groupid'}
            gp = varargin{k+1};
            if isempty(gp)
                for k1 = 1:length(g.nodes)
                    g.nodes(k1).groupid = -1;
                end
            elseif size(gp,1) == length(g.nodes) && size(gp,2) > 1
                % given as partitioning vector
                % put grouping
                gs = sum(gp,1);
                gp(:,find(gs==0)) = []; % remove group with no member
                for k1 = 1:length(g.nodes)
                    m = find(gp(k1,:));
                    if ~isempty(m)
                        g.nodes(k1).groupid = m(1);
                    else
                        g.nodes(k1).groupid = -1; % no group
                    end
                end
            else
                if length(gp) ~= length(g.nodes)
                    error('graph:set', '%s', 'Number of group id must equal to number of nodes');
                end
                gps = unique(gp);
                if isequal(gps, 1:max(gps))
                    for k1 = 1:length(gp), g.nodes(k1).groupid = gp(k1); end
                else
                    % not sequential and start with 1 so reassign
                    for kn = 1:length(gps)
                        [g.nodes(find(gp==gps(kn))).groupid] = deal(kn);
                    end
                end
            end
        case {'nodecolor', 'nc', 'color'}
            c = varargin{k+1};
            if isempty(c)
                c = [g.nodes.groupid];
            end
            if iscell(c)
                if length(c) ~= length(g.nodes)
                    error('graph:set', '%s', 'Number of color must equal to number of nodes');
                end
                for kn = 1:length(g.nodes)
                    g.nodes(kn).color = c{kn};
                end
            elseif ischar(c)                
                for kn = 1:length(g.nodes)
                    g.nodes(kn).color = c;
                end
            else % must be numeric array
                if length(c) ~= length(g.nodes)
                    error('graph:set', '%s', 'Number of color must equal to number of nodes');
                end     
                uc = unique(c);
                cmap = {'w', 'g', 'y', 'm', 'b', 'c', 'r', ...
                    [.5, .5, .5], [0 0 .5], [0 .5 0], [.5 0 0], [.5 .5 0], [.5 0 .5] [0 .5 .5], ...
                    [.75, .25, .25], [.25, .75, .25], [.25, .25, .75], [.75 .25 0], [.25 .75 0], [.75 0 .25] [.25 0 .75] [0 .75 .25] [0 .25 .75], ...
                    [.75, .75, .75], [0 0 .75], [0 .75 0], [.75 0 0], [.75 .75 0], [.75 0 .75] [0 .75 .75], ...
                    [.125, .125, .125], [0 0 .125], [0 .125 0], [.125 0 0], [.125 .125 0], [.125 0 .125] [0 .125 .125], ...
                    [.25, .25, .25], [0 0 .25], [0 .25 0], [.25 0 0], [.25 .25 0], [.25 0 .25] [0 .25 .25], ...
                    [.125, .25, .125], [.25, .125, .125], [.125, .25, .25], [.125 .25 0], [.25 .125 0], [.125 0 .25] [.25 0 .125] [0 .125 .25] [0 .25 .125], ...
                    };
                for kn = 1:length(g.nodes)
                    sc = cmap{mod(find(uc==c(kn))-1,length(cmap))+1};
                    if ~ischar(sc), sc = mat2str(sc); end
                    g.nodes(kn).color = sc;
                end
            end
        case 'nodelocation'
            nlz = [length(g.nodes), 2];
            if ~isequal(size(varargin{k+1}), nlz)
                error('graph:set', '%s %s', 'nodeLocation size must be ', mat2str(nlz));
            end
            for kn = 1:length(g.nodes)
                g.nodes(kn).position = varargin{k+1}(kn,:);
            end
        case 'name'
            g.name = varargin{k+1};
        case {'nodesize', 'ns'}
            g.nodeSize = varargin{k+1};
        otherwise
            error('graph:set', '%s%s', 'Unknown option: ', varargin{k});        
    end
end
