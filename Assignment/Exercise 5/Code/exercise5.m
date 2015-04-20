N = 2000;
avgDegree = 4;

number_of_iterations = 1;
S1 = zeros(number_of_iterations, 101); % we calculate 101 points of f
M = erdos_reyni(N, avgDegree/N);

for i= 1:100
    net(:,i) = NCOalgorithm(full(M));
end

for k = 1:number_of_iterations
    M = erdos_reyni(N, avgDegree/N);
    A = full(M + eye(N));

    % Generate random intial opinions
    for i = 0:100
        f =  i * 0.01; % f is the probability to have opinion 1
       
        prev_opinions = -1 + 2 .* (rand(N,1) <= f);

        % Inlined nco.m function for better performance
        while 1
            new_opinions = A * prev_opinions;
            new_opinions = new_opinions + (prev_opinions .* (new_opinions == 0)); % when there is no majority: stay unchanged
            new_opinions = new_opinions ./ abs(new_opinions); % normalize.    
            if (prev_opinions == new_opinions) 
                break
            end
            prev_opinions = new_opinions;
    
        end
        
        op_ind = (new_opinions == 1);
        % Ignore all nodes which have negative opinion
        % Find the largest cluster size
        [ci, sizes] = components(M(op_ind, op_ind));   
        S1(k, i + 1) = max(sizes);
    end
end

plot(0:0.01:1, mean(S1./N, 1));