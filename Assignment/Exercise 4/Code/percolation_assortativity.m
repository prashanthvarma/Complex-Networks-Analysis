function [avg_f_a,avg_of_a,avg_largest_component_sizes_a] = percolation_assortativity(net_assort, N)

number_of_nodes_to_remove = round(N/100);
result_array_size = ceil(N / number_of_nodes_to_remove);
avg_of_a = zeros(100, result_array_size);
avg_f_a = zeros(100, result_array_size);
avg_largest_component_sizes_a = zeros(100, result_array_size);

for i = 1:100
    
    
     A = sparse(edgeL2adj(net_assort(:,:,i)));
     
    % remove nodes until the size of the largest cluster is 0
    n_removed = 0;
    n = N;
    f = zeros(1, result_array_size);
    of = zeros(1, result_array_size);
    largest_component_sizes = zeros(1, result_array_size);
    k = 1;
    while (n >= 0)
        % calculate the size of the largest cluster 
        % and the percentage of nodes removed.
        [ci, sizes] = components(A);   
        f(k) = n_removed/N;
        of(k) = n / N;
        largest_component_sizes(k) = max(sizes);
  
        for j = 1:number_of_nodes_to_remove  
            if (size(A,1) == 0)
                break
            end
            % randomly select a node...
            node_to_remove = randsample(size(A,1),1);
            % ... and remove it
            A(node_to_remove,:) = [];
            A(:,node_to_remove) = [];
        end
        n = n - number_of_nodes_to_remove;
        n_removed = (number_of_nodes_to_remove*k);
        k = k + 1;
    end
    avg_of_a(i,:) = of;
    avg_f_a(i,:) = f;
    avg_largest_component_sizes_a(i,:) = largest_component_sizes;
end