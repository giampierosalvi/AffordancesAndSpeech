function [netobj] = BNEnterNodeEvidence(netobj, nodevaluepairs, incremental)
%
%
% nodevaluepairs: cell array pairs of node name and value name for the
% observed nodes.
%
% incremental: retains evidence specified so far (default true)
%
% Example:
% netobj = BNEnterNodeEvidence(netobj, {'Color', 'yellow', 'Size', 'big'})
%
% (C) 2010, Giampiero Salvi, <giampi@kth.se>

if nargin < 3
    incremental = 1;
end

if ~incremental || ~isfield(netobj, 'evidence')
    for h=netobj.ALLNODES
        netobj.evidence{h}=[];
    end
end

for h=1:2:length(nodevaluepairs)
    nodename = nodevaluepairs(h);
    nodevalue = nodevaluepairs(h+1);
    nodeidx = find(strcmpi(nodename, netobj.nodeNames));
    if isempty(nodeidx)
        warning('node %s unknown, ignoring\n', nodename{1});
    else
        valueidx = find(strcmpi(nodevalue, netobj.nodeValueNames{nodeidx}));
        if isempty(valueidx)
            error('value %s not valid for node %s', nodevalue{1}, nodename{1});
        else
            netobj.evidence{nodeidx} = valueidx;
        end
    end
end
netobj = BNEnterEvidence(netobj, netobj.evidence, incremental);
