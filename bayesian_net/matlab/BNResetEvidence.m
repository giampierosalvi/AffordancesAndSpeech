function [netobj] = BNResetEvidence(netobj)
% BNResetEvidence: resets all evidence in netobj and netobj.engine
%
% See also createBN, BNEnterNodeEvidence, BNShowCurrentEvidence
%
% (C) 2010-2017, Giampiero Salvi, <giampi@kth.se>

for h=netobj.ALLNODES
    netobj.evidence{h}=[];
    netobj.soft_evidence{h}=[];
end
netobj = BNEnterNodeEvidence(netobj, {});
%netobj = BNEnterEvidence_private(netobj);
