function [g, q] = gaPart(g, varargin)
% SPECTPART - partitioning by GA
%
% [g, q] = gaPart(g, ...) opts is gapotimset. Default gapotimset is 
%   cross fraction is 0.3, population size is 5 times number of nodes. 
%   If input graph g has grouping, initial population contained a partitioing 
%   from g.
%
%   Optional parameters
%   nRun        - number of run, default 1. Result is the best of runs.
%   gaoptimset  - ga optimset
%   nPop        - number of population
%   GroupSize   - maximun number of group size
%   PopulationSize - Number of population in GA optimset
%
% Example:
%   g = graph('karate'); % get some graph
%   g = set(g, 'directed', 0); % partitioning work only for undirected
%   [g Q] = specPart(g)
%   [g gQ] = gaPart(g)  % generally GA partitiong is follow by spectral partition.
%   g = set(g, 'nodeColor', []); % color node with group id
%   g = layout(g, 'group');
%   plot(g);
%
% See also SPECPART

 
% we need to pass these to objective function
B = modmat(g);
m = sum(sum(adjacency(g)))/2;

nRun = 1;
opts = gaoptimset('PopulationType', 'bitstring', ...
        'PopulationSize', 20+ceil(size(g,1)*5), ...
        'CrossoverFraction', 0.5, ...
        'Vectorized', 'off');
S = get(g, 'partition');
if size(S,2) == 1
    ng = 2 + ceil(size(g,1)/20);
else
    % add 25% more groups
    ng = ceil(size(S,2) * 1.25);
    % number of element in new S
end
% Read additional options
if nargin > 1
    if rem(nargin,2) ~= 1
        error('netana:netannotator:IncorrectNumberOfArguments',...
            'Incorrect number of arguments to %s.',mfilename);
    end
    for j=1:2:nargin-1
        pname = varargin{j};
        pval = varargin{j+1};
        switch lower(strtrim(pname))
            case 'nrun'
                nRun = pval;
            case 'gaoptim'
                opts = gaoptimset(opts, pval);
            case 'populationsize'
                opts = gaoptimget(opts, 'PopulationSize', pval);
            case 'groupsize'
                ng = pval;
            otherwise
                error('graph:gapart:UnknownParameterName',...
                    'Unknown parameter name: %s.',pname);
        end
    end
end

np = gaoptimget(opts, 'PopulationSize');

mg = ceil(log2(ng));
nt = mg * size(g,1);
% create initial populations
pop = double(rand(np, nt)>0.5);

% put an elite member from given graph partiting
pop(1,:) = 0;
for k1 = 1:size(S,1)
    groupNo = find(S(k1,:)) - 1;
    b = dec2bin(groupNo, mg);
    b = fliplr(b);
    for k2 = 1:length(b)
        if b(k2) == '1'
             pop(1,(k1-1)*mg+k2) = 1;
        end
    end
    % disp([k1, groupNo, pop(1,(k1-1)*mg+1:k1*mg)]);
end

opts = gaoptimset(opts, 'InitialPopulation', pop);

x = [];
optFv = 0;
for k = 1:nRun
    [x1, fval] = ga(@gaobjfun, nt, opts);
    if fval < optFv
        optFv = fval;
        x = x1;
    end
end

n = length(B);
S = x2s(x);
q = trace(S' * B * S) / (2*m);
g = set(g, 'group', S);

    function obj = gaobjfun(x)
        % gaobjfun  - GA objective function
        %
        %   obj = gaobjfun(x) get modularity of given partitioning vector 
        %         x from GA
        %


        S = x2s(x);

        % modularity, higher is better so put minus
        obj = - trace(S' * B * S) / (2*m); 
        % fprintf('%g: %s\n', obj, mat2str(sum(S,1)));

    end

    % -------------------
    function S = x2s(x)
        % Convert GA bitstring to its representative partiting matrix

        % disp(size(x));
        n = length(B);
        s = reshape(x, n, length(x)/n);
        
        % each node can be belong to only group
        S = zeros(n, ng); 
        for k1 = 1:size(s,1)
            % convert binary to decimal
            groupNo = sum(2 .^ [0:mg-1] .* s(k1,:)); 
            groupNo = mod(groupNo, ng);
            S(k1, groupNo+1) = 1;
        end

    end

end