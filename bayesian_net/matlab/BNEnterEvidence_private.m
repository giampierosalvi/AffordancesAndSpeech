function [netobj] = BNEnterEvidence_private(netobj)
% BNEnterEvidence_private: low level function to enter evidence to
% the inference engine. This is intended as a private method.
% The user should instead call any of:
% - BNEnterNodeEvidence
% - BNEnterWordEvidence
% - ...
%
% (C) 2010-2017, Giampiero Salvi, <giampi@kth.se>

if ~isfield(netobj, 'engine') || ...
        ~strcmp(class(netobj.engine), 'jtree_inf_engine')
    netobj.engine= jtree_inf_engine(netobj.bnet,'clusters',{netobj.NONSTOCHNODES});
end
[netobj.engine, netobj.engine_loglik] = enter_evidence(netobj.engine, ...
                                                  netobj.evidence, ...
                                                  'soft', netobj.soft_evidence);
