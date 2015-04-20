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

% Erdos-Reyni random graph degree distribution
for i = 1:100
    A = random_graph(N, p);
    [max_possible_degree, elements] = degree_dist(A);
    plot(1:max_possible_degree, elements, '*');
    hold on;
end

binomial_degree_dist = binopdf(1:max_possible_degree, N, p);

plot(1:max_possible_degree, binomial_degree_dist,'r*-');
hold off;
ylabel('P[D = k]');
xlabel('Degree (k)');

% Barabasi-Albert scale-free network degree distribution

figure();
pexponents = zeros(1,100);

for i = 1:100
     A = BARandomGraph(N, 3);
    [max_possible_degree, elements] = degree_dist(A);
    loglog(1:max_possible_degree, elements, '*');
    x = log(1:max_possible_degree);
    y = log(elements);
    good = ~(isinf(x) | isinf(y)) ;
    [p v] = polyfit(x(good),y(good),1); 
    pexponents(i) = p(1);
    hold on;
end

avgpexponent = mean(pexponents);

hold off;
ylabel('log(P[D = k])');
xlabel('log(Degree (k)) ');