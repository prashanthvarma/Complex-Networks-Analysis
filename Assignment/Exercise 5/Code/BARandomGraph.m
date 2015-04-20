function graph = BARandomGraph(N, m)
% Create a random scale-free network with N nodes by starting with m nodes
% and connecting to m existing nodes at every step with probability p(i) =
% degree(i) / sum(degree(all other nodes)), 
    graph = zeros(N,N);
    % the degree of the initial network has to be at least one.
    for i = 1:m
        neighbor = randsample([1:i-1, i+1:m], 1);
        graph(i, neighbor) = 1;
        graph(neighbor, i) = 1;
    end
    % this means we need to connect 3
    % start with m nodes and in each step connect it to m existing nodes
    for i = (m+1):N
        % calculate probability distribution of connecting to the other
        % nodes
        deg = full(degree(graph));
        % pick unique m nodes out of it and connect
        connect_to_nodes = randsampleWRW(1:i-1, m, deg(1:i-1));
        for j = 1:m
            new_neighbor = connect_to_nodes(j);
            graph(i, new_neighbor) = 1;
            graph(new_neighbor, i) = 1;
        end 
    end
    graph = sparse(graph);
end