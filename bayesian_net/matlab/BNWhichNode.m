function nodeidx = BNWhichNode(netobj, nodename)
% BNWhichNode: returns node index from node name
%
% Example:
% nodeidx = BNWhichNode(netobj, 'Size')
%
% See also createBN, BNSetDefaults, BNWhichNodeValue
%
% (C) 2010-2017 Giampiero Salvi <giampi@kth.se>

nodeidx = find(strcmp(netobj.nodeNames, nodename));
