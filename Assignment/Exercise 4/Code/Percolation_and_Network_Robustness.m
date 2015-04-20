edges = load('Dutch Soccer Network.txt');
N = length(unique(edges));
adj = zeros(N,N);
L = 0;

% Generating adjacency matrix

for i=1:length(edges)
 L1 = edges(i,1);
    L2 = edges(i,2);
    adj(L1, L2) = 1;
    adj(L2, L1) = 1;
end

% Calculating number of links

for i=1:N
   for j=1:N
        if adj(i, j) == 1
            L = L+1;
        end
    end
            
end

L = L/2;
Lc = (N*(N-1))/2; % Links in complete graph
p = L/Lc; % Link density

number_of_nodes_to_remove = round(N/100);

% create the sparse graph
dutch_soccer = sparse(adj);

result_array_size = ceil(N / number_of_nodes_to_remove);

avg_of = zeros(100, result_array_size);
avg_f = zeros(100, result_array_size);
avg_largest_component_sizes = zeros(100, result_array_size);

for i = 1:100
    
    % A = sparse(random_graph(N, p));
    % A = BARandomGraph(N, 3);
     A = dutch_soccer;
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
    avg_of(i,:) = of;
    avg_f(i,:) = f;
    avg_largest_component_sizes(i,:) = largest_component_sizes;
end

[avg_f_a,avg_of_a,avg_largest_component_sizes_a] = percolation_assortativity(net_assort, N);

[avg_f_d,avg_of_d,avg_largest_component_sizes_d] = percolation_disassortativity(net_disassort, N);


figure(1)
plot(mean(avg_f), mean(avg_largest_component_sizes)/N);
hold on
plot(mean(avg_f_a), mean(avg_largest_component_sizes_a)/N, 'g');
hold on
plot(mean(avg_f_d), mean(avg_largest_component_sizes_d)/N, 'r');
xlabel('f');
ylabel('Relative size of largest component');
legend({'Actual Network','Assortive Rewiring','Disassortive Rewiring'});

figure(2)
plot(mean(avg_of), mean(avg_largest_component_sizes)/N);
hold on
plot(mean(avg_of_a), mean(avg_largest_component_sizes_a)/N, 'g');
hold on
plot(mean(avg_of_d), mean(avg_largest_component_sizes_d)/N, 'r');
xlabel('1-f');
ylabel('Relative size of largest component');
legend({'Actual Network','Assortive Rewiring','Disassortive Rewiring'});


    
    