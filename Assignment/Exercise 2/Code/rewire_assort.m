function [el,rew] = rewire_assort(el,rew)

[deg,~,~]=degrees(edgeL2adj(el));

while ~(rew>=0.3&&rew<=0.31) 
    
    % pick two random edges    
    ind = randi(length(el),1,2);
    edge1=el(ind(1),:); edge2=el(ind(2),:);

    if ~isempty(intersect(edge1(1:2),edge2(1:2))); continue; end % the two edges cannot overlap

    nodes=[edge1(1) edge1(2) edge2(1) edge2(2)];
    [~,Y]=sort(deg(nodes));
    
    % connect nodes(Y(1))-nodes(Y(2)) and nodes(Y(3))-nodes(Y(4))
    if ismember([nodes(Y(1)),nodes(Y(2)),1],el,'rows') || ismember([nodes(Y(3)),nodes(Y(4)),1],el,'rows'); continue; end   
    
    el(ind(1),:)=[nodes(Y(3)),nodes(Y(4)),1];
    el(ind(2),:)=[nodes(Y(1)),nodes(Y(2)),1];
    
    [~,inds1] = ismember([edge1(2),edge1(1),1],el,'rows');
    el(inds1,:)=[nodes(Y(4)),nodes(Y(3)),1];
            
    [~,inds2] = ismember([edge2(2),edge2(1),1],el,'rows');
    el(inds2,:)=[nodes(Y(2)),nodes(Y(1)),1];

    rew = Degree_correlation(el);
        
end