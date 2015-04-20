function r = get(g, varargin)
% get   - get value of given parameter
%
%   r = get(g, ...)
%
% Valid parameters are:
%   labels (nodenames), group, paritition, nodecolor, visited, name,
%   positions
%
%
%   Examples:
%   r = get(g, 'visited') % return visited node list. Visited is stamped by
%                          %breadthFirstSearch function.
%
%   See also set.
%

r = [];
error(nargchk(2,2,nargin));
switch lower(varargin{1})
    case {'labels', 'nodelabels', 'names', 'nodenames'}
        r = {g.nodes.label};        
    case {'group', 'groupid', 'g', 'gid'}
        r = [g.nodes.groupid];
    case {'partition', 'p'}
        gd = [g.nodes.groupid];
        ugd = unique(gd);
        r = zeros(length(g.nodes), length(ugd));
        for k = 1:length(ugd)
            r(find(gd==ugd(k)),k) = 1;
        end
    case {'nodecolor', 'nc'}
        r = {g.nodes.color};
    case {'nodesize', 'ns'}
        r = g.nodeSize;
    case {'visited', 'v'}
        r = find([g.nodes.visited] == 1);
    case 'name'
        r = g.name;
    case {'ps', 'positions'}
        r = reshape([g.nodes.position], 2, length(g.nodes))';
    case {'directed', 'd'}
        r = g.directed;
    otherwise
        error(['Unknown parameter: ', varargin{1}]);
end