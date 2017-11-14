function probdist = BNMarginalProb(netobj, inferenceNodeNames)
% BNMarginalProb: returns marginal probability distribution
%   over the nodes in inferenceNodeNames
% Input:
% netobj: object as created by createBN
% inferenceNodeNames: cell array of strings with node names (see netobj.nodeNames)
% Example:
% nodeidx = BNWhichNode(netobj, 'Size')
%
% See also createBN, BNEnterNodeEvidence
%
% (C) 2010-2017 Giampiero Salvi <giampi@kth.se>

predictionNodes = arrayfun(@(x) BNWhichNode(netobj,x), inferenceNodeNames);
marg = marginal_nodes(netobj.engine, predictionNodes);
probdist = marg.T;
