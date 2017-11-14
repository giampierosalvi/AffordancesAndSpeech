function probdist = BNMarginalProb(netobj, inferenceNodeNames)

predictionNodes = arrfun(@(x) BNWhichNode(netobj,x), inferenceNodeNames);
marg = marginal_nodes(netobj.engine, predictionNodes);
probdist = marg.T
