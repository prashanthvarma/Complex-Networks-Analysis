function   r = Degree_correlation(el)

N = length(unique(el));
degi = zeros(N,1);
degj = zeros(N,1);
deg1 = zeros(N,1);

adjr = edgeL2adj(el);

% Generating degree matrix

for i=1:N
   for j=1:N
        if adjr(i, j) == 1
            deg1(i) = deg1(i) + 1; 
        end
    end
            
end

    [i,j] = find(triu(adjr,1)>0);
    K = length(i);
    
    for k=1:K
        degi(k) = deg1(i(k));
        degj(k) = deg1(j(k));
    end
    
 % compute assortativity
r = (sum(degi.*degj)/K - (sum(0.5*(degi+degj))/K)^2)/(sum(0.5*(degi.^2+degj.^2))/K - (sum(0.5*(degi+degj))/K)^2);