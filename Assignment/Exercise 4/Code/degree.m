function [ deg ] = degree( adj_matrix )
    % Returns the degree of an undirected graph from its adjacentency matrix
    deg = sum(adj_matrix) + diag(adj_matrix)';
end

