function g = reset(g)
% RESET - reset information

% for k = 1:length(g.nodes)
%     g.nodes(k).visited = 0;
%     g.nodes(k).timeStamp = 0;
% end
[g.nodes.visited] = deal(0);
[g.nodes.timeStamp] = deal(0);