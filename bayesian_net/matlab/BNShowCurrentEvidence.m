function BNShowCurrentEvidence(netobj)
% BNShowCurrentEvidence:
% human readable report showing the evidence currently entered in
% the engine
%
% (C) 2010-2017, Giampiero Salvi, <giampi@kth.se>

for h=netobj.ALLNODES
    if ~isempty(netobj.evidence{h})
        disp(['Hard evidence on node ', netobj.nodeNames{h}, ': ', netobj.nodeValueNames{h}{netobj.evidence{h}}])
    end
    if ~isempty(netobj.soft_evidence{h})
        disp(['Soft evidence on node ', netobj.nodeNames{h}, ':'])
        for k=1:length(netobj.nodeValueNames{h})
            disp([netobj.nodeValueNames{h}{k}, ': ', num2str(netobj.soft_evidence{h}(k))])
        end
    end
end
