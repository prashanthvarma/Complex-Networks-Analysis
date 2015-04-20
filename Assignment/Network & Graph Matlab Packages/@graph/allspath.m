function B = allspath(g, th)
% ALLSPATH - solve the All Pairs Shortest Path problem for undirected graph
%
% Rapidly returns the shortest node-to-node distance along the edges of a
% graph, for all nodes in the graph.
%
%   B = allspath(g)
%
%   g = input graph
%   B = shortest path distance matrix between all nodes
%
%   This function consists two algorithms. One is memory hungry and other
%   is CPU hungry. The program swith the two depending on the size of
%   graph. Change the threshold in the code if you have 64-bit version of
%   Matlab. 
%
% Frist part of algorithm was written by Michael Kleder, October 2005. Available
% from Matlab file exchange central. Although it is very first, consume
% huge memory and didn't seem to work more than 300 nodes. Alternative algorithm 
% use for large graph.
%
%   Note this program do not work for directed graph

if g.directed
    error('graph:modmat', '%s', 'Graph is not undirected.');
end

B = adjacency(g);

if exist('biograph', 'file') % use bioinformatics tool if available
    B = allshortestpaths(biograph(B), 'Directed', directed(g));
    return;
end

if nargin < 2, 
    % th = 300; % for 32 bit
    th = 500; % for 64 bit
end

if length(B) <= th
    B(B==0)=Inf;
    C=ones(size(B));
    iter=0;
    while any(C(:))
        C=B;
        B=min(B,squeeze(min(repmat(B,[1 1 length(B)])+...
            repmat(permute(B,[1 3 2]),[1 length(B) 1]),[],1)));
        C=B-C;
    end
    B(logical(eye(length(B))))=0;

else
    n = length(g.nodes);
    B = zeros(n, n);

    disptime = 15;
    st = clock;
    bt = st;

    for k = 1:n
        B(k,:) = apspi(g,k);
        et = clock;
        if etime(et, st) > disptime
            fprintf('%2.2f %% %2.1f min remaining \n', 100*k/n, (n-k)*etime(et,bt)/k/60);
            st = clock;
        end
    end
end



function b = apspi(g, sp)

b = zeros(1, length(g.nodes));

activeVertexes = sp;
timeStamp = 0;

while ~isempty(activeVertexes)
    nextVertexes = [];
    timeStamp = timeStamp + 1;
    for kv = activeVertexes
        adj = neighbors(g,kv);
        nv = adj(find(b(adj)==0));
        b(nv) = timeStamp;
        nextVertexes = [nextVertexes, nv];
    end
    activeVertexes = nextVertexes;
end
b(sp) = 0;















