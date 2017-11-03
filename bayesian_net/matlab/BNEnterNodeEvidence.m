function [netobj] = BNEnterNodeEvidence(netobj, nodeValuePairs, ...
                                        incremental, nodeDistPairs)
% BNEnterNodeEvidence:
% enter hard or soft evidence by means of node names and value
% names or probability distributions
%
% Inputs:
% nodeValuePairs: cell array containing pairs of node name and
%                 value name for the observed nodes (hard evidence).
% incremental:    retains evidence specified so far (default true)
% nodeDistPairs:  cell array containing pairs of node name and
%                 probability distributions for the observed nodes
%                 (soft evidence)
% Output:
% netobj:         updated object
%
% NOTE: to know the order of values in a node with nodeName, refer
% to netobj.nodeValueNames{BNWhichNode(nodeName)}
%
% NOTE: if both nodeValuePairs and nodeDistPairs refer to the same
% nodes, the second will override the first.
%
% Example:
% netobj = BNEnterNodeEvidence(netobj, {'Color', 'yellow', 'Size', 'big'})
%
% netobj = BNEnterNodeEvidence(netobj, {'Color', 'yellow', 'Size',
% 'big'}, [], {'Action', [0.1 0.3 0.6]})
%
% (C) 2010-2017, Giampiero Salvi, <giampi@kth.se>

% reset evidence if incremental defined as 0
if nargin > 2
    if isempty(incremental) || incremental == 1
        % nothing to do here
    else
        netobj = BNResetEvidence(netobj);
    end
end

% first take care of hard evidence
for h=1:2:length(nodeValuePairs)
    nodename = nodeValuePairs{h};
    nodevalue = nodeValuePairs{h+1};
    nodeidx = BNWhichNode(netobj, nodename);
    if isempty(nodeidx)
        warning('node %s unknown, ignoring\n', nodename);
        continue
    end
    valueidx = BNWhichNodeValue(netobj, nodeidx, nodevalue);
    if isempty(valueidx)
        warning('value %s not valid for node %s, ignoring\n', ...
                nodevalue, nodename);
        continue
    end
    % everything went fine: update hard evidence
    netobj.evidence{nodeidx} = valueidx;
    % ...and, in case remove soft evidence
    if ~isempty(netobj.soft_evidence{nodeidx})
        netobj.soft_evidence{nodeidx} = [];
    end
end

% now take care of soft evidence
if nargin > 3
    for h=1:2:length(nodeDistPairs)
        nodename = nodeDistPairs{h};
        nodeDist = nodeDistPairs{h+1};
        nodeidx = BNWhichNode(netobj, nodename);
        if isempty(nodeidx)
            warning('node %s unknown, ignoring\n', nodename);
            continue
        end
        if length(nodeDist) ~= length(netobj.nodeValueNames{nodeidx})
            warning('distribution for node %s has wrong length, ignoring\n', nodename)
            continue
        end
        if sum(nodeDist)-1 > eps
            warning('distribution for node %s does not sum to 1, ignoring\n', nodename)
            continue
        end
        % everything went fine: update soft evidence
        netobj.soft_evidence{nodeidx} = nodeDist;
        % ...and, in case remove hard evidence
        if ~isempty(netobj.evidence{nodeidx})
            netobj.evidence{nodeidx} = [];
        end
    end
end
% finally send evidence to engine
if ~isfield(netobj, 'engine') || ...
        ~strcmp(class(netobj.engine), 'jtree_inf_engine')
    netobj.engine= jtree_inf_engine(netobj.bnet,'clusters',{netobj.NONSTOCHNODES});
end
[netobj.engine, netobj.engine_loglik] = enter_evidence(netobj.engine, ...
                                                  netobj.evidence, ...
                                                  'soft', netobj.soft_evidence);
