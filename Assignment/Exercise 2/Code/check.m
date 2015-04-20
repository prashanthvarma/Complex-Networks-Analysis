L = 0;
N = length(adjn);
degn = zeros(N,1);
% Calculating number of links and generating degree matrix

for i=1:N
   for j=1:N
        if adjn(i, j) == 1
            L = L+1;
            degn(i) = degn(i) + 1; 
        end
    end
            
end

% Topological metrics

L = L/2;
Lc = (N*(N-1))/2; % Links in complete graph
p = L/Lc; % Link density
Avg_Deg = (2*L)/N; % Average degree
Deg_Var = var(degn(:,1)); % Degree variance

% Degree distribution : linear-linear scale

figure(1)
[y, x] = hist(degn(:,1),unique(degn(:,1)));
plot(x,y/sum(y),'*r');
xlabel('Degree K');
ylabel('P(D = k)');
title('Node Degree Distribution : linear-linear scale');

% Checking for power law distribution

[y, x] = hist(degn(:,1),unique(degn(:,1))); 
t = y/sum(y);
t = t';
n = log10(x);
T = log10(t);
p = polyfit(n,T,1);
Gamma = p(1); % Gamma - power exponent
c = 10^p(2); % Power law constant
d = c*(unique(degn(:,1)).^(Gamma));
e = unique(degn(:,1));

% Power law degree distribution : linear-linear scale

figure(2)
[y, x] = hist(degn(:,1),unique(degn(:,1)));
plot(x,y/sum(y),'*r'); % Actual distribution
hold on
plot(e,d, ':b'); % Fitting Curve
xlabel('Degree K');
ylabel('P(D = k)');
title('Node Degree Distribution : linear-linear scale');
legend({'Actual distribution','Fitting curve'});

% Power law Degree distribution : log-log scale

figure(3)
loglog(x,y/sum(y),'*r'); % Actual distribution
hold on
loglog(e,d,':b'); % Fitting Curve
xlabel('Log(k)');
ylabel('Log(P(k))');
title('Node Degree Distribution : log-log scale');
legend({'Actual distribution','Fitting curve'});
