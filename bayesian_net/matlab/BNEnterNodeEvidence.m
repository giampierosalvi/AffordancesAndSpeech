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
% (C) 2010, Giampiero Salvi, <giampi@kth.se>

if nargin > 2 && incremental == 0
    netobj = BNResetEvidence(netobj)
end

% first take care of hard evidence
for h=1:2:length(nodeValuePairs)
    nodename = nodeValuePairs(h);
    nodevalue = nodeValuePairs(h+1);
    nodeidx = BNWhichNode(netobj, nodename);
    if isempty(nodeidx)
        warning('node %s unknown, ignoring\n', nodename{1});
        continue
    end
    valueidx = BNWhichNodeValue(netobj, nodevalue);
    if isempty(valueidx)
        warning('value %s not valid for node %s, ignoring\n', ...
                nodevalue{1}, nodename{1});
        continue
    end
    % everything went fine: update hard evidence
    netobj.evidence{nodeidx} = valueidx;
    % ...and, in case remove soft evidence
    if ~isempty(netobj.soft_evidence{nodeidx})
        netobj.soft_evidence{nodeidx} = []
    end
end

% now take care of soft evidence
if nargin > 3
    for h=1:2:length(nodeDistPairs)
        nodename = nodeDistPairs(h);
        nodeDist = nodeDistPairs(h+1);
        nodeidx = BNWhichNode(netobj, nodename);
        if isempty(nodeidx)
            warning('node %s unknown, ignoring\n', nodename{1});
            continue
        end
        if length(nodeDist) ~= length(netobj.nodeValueNames{nodeidx})
            warning('distribution for node %s has wrong length, ignoring\n', nodename{1})
            continue
        end
        if sum(nodeDist)-1 > eps
            warning('distribution for node %s does not sum to 1, ignoring\n', nodename{1})
            continue
        end
        % everything went fine: update soft evidence
        netobj.soft_evidence{nodeidx} = nodeDist;
        % ...and, in case remove hard evidence
        if ~isempty(netobj.evidence{nodeidx})
            netobj.evidence{nodeidx} = []
        end
    end
end
% finally send evidence to engine
netobj = BNEnterEvidence_private(netobj);
