function valueidx = BNWhichNodeValue(netobj, nodeidx, valuename)
% BNWhichNodeValue: returns node value index from value name
%
% Example:
% nodeidx = BNWhichNode(netobj, 'Action')
% valueidx = BNWhichNodeValue(netobj, nodeidx, 'tap')
%
% See also createBN, BNSetDefaults, BNWhichNode
%
% (C) 2010-2017 Giampiero Salvi <giampi@kth.se>

valueidx = find(strcmp(netobj.nodeValueNames{nodeidx}, valuename));
