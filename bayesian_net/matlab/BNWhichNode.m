function node = BNWhichNode(netobj, nodename)
% BNWhichNode: returns node index from node name
%
% (C) 2010-2017 Giampiero Salvi <giampi@kth.se>

node = find(strcmp(netobj.nodeNames, nodename));
