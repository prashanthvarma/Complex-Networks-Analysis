function M = rewire_disassorttest(M)
adj = full(M);
rew = assortativity(sparse(adj),0);
[deg,~,~]=degrees(adj);
el = adj2edgeL(adj);

while ~(rew>=-0.31&&rew<=-0.30)
   
    ind = randi(length(el),1,2);
    edge1=el(ind(1),:); edge2=el(ind(2),:);

    if length(intersect(edge1(1:2),edge2(1:2)))>0; continue; end % the two edges cannot overlap

    nodes=[edge1(1) edge1(2) edge2(1) edge2(2)];
    [~,Y]=sort(deg(nodes));
    
    % connect nodes(Y(1))-nodes(Y(4)) and nodes(Y(2))-nodes(Y(3))
    if ismember([nodes(Y(1)),nodes(Y(4)),1],el,'rows') | ismember([nodes(Y(2)),nodes(Y(3)),1],el,'rows'); continue; end   
    
    el(ind(1),:)=[nodes(Y(1)),nodes(Y(4)),1];
    el(ind(2),:)=[nodes(Y(2)),nodes(Y(3)),1];
    
    [~,inds1] = ismember([edge1(2),edge1(1),1],el,'rows');
    el(inds1,:)=[nodes(Y(4)),nodes(Y(1)),1];
            
    [~,inds2] = ismember([edge2(2),edge2(1),1],el,'rows');
    el(inds2,:)=[nodes(Y(3)),nodes(Y(2)),1];
    
    rew=assortativity(sparse(edgeL2adj(el)),0);
        
end

M = sparse(edgeL2adj(el));

end