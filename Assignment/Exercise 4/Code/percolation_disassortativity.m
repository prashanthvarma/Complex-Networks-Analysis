function [avg_f_d,avg_of_d,avg_largest_component_sizes_d] = percolation_disassortativity(net_disassort, N)

number_of_nodes_to_remove = round(N/100);
result_array_size = ceil(N / number_of_nodes_to_remove);
avg_of_d = zeros(100, result_array_size);
avg_f_d = zeros(100, result_array_size);
avg_largest_component_sizes_d = zeros(100, result_array_size);

for i = 1:100
    
    
     A = sparse(edgeL2adj(net_disassort(:,:,i)));
     
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
    avg_of_d(i,:) = of;
    avg_f_d(i,:) = f;
    avg_largest_component_sizes_d(i,:) = largest_component_sizes;
end