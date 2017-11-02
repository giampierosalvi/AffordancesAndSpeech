function [netobj] = BNEnterEvidence(netobj, evidence, incremental)
% BNEnterEvidence: low level function to enter evidence to
% inference engine. This is intended as a private method.
% The user should instead call any of:
% - BNEnterNodeEvidence.m
% - BNEnterWordEvidence.m
% - ...
%
% evidence: cell array with observations or empty matrices for unobserved
% nodes. See enter_evidence for details.
%
% incremental: retains evidence specified so far (default true)
%
% (C) 2010-2017, Giampiero Salvi, <giampi@kth.se>

if nargin < 3
    incremental = 1;
end

if incremental && isfield(netobj, 'evidence')
    for h=netobj.ALLNODES
        if ~isempty(evidence{h})
            netobj.evidence{h}=evidence{h};
        end
    end
else
    for h=netobj.ALLNODES
        netobj.evidence{h}=evidence{h};
    end
end

if ~incremental || ...
        ~isfield(netobj, 'engine') || ...
        ~strcmp(class(netobj.engine), 'jtree_inf_engine')
    netobj.engine= jtree_inf_engine(netobj.bnet,'clusters',{netobj.NONSTOCHNODES});
end
[netobj.engine, netobj.engine_loglik] = enter_evidence(netobj.engine, netobj.evidence);
