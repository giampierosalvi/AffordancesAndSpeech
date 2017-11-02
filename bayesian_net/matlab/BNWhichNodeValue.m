function idx = BNWhichNodeValue(netobj, node, valuename)
% BNWhichNodeValue: returns node value index from value name
%
% (C) 2010-2017 Giampiero Salvi <giampi@kth.se>

idx = find(strcmp(netobj.nodeValueNames{node}, valuename));
