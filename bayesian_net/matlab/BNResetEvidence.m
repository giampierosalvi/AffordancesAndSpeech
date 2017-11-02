function [netobj] = BNResetEvidence(netobj)
% BNResetEvidence:
% resets all evidence in netobj and netobj.engine
%
% (C) 2010-2017, Giampiero Salvi, <giampi@kth.se>

for h=netobj.ALLNODES
    netobj.evidence{h}=[];
    netobj.soft_evidence{h}=[];
end
netobj = BNEnterEvidence_private(netobj);