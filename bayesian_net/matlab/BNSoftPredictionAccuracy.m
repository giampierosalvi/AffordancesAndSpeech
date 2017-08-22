function results = BNSoftPredictionAccuracy(netobj, questions, answers)

Ntest = length(questions);

actionnode = BNWhichNode(netobj, 'Action');
colornode = BNWhichNode(netobj, 'Color');
shapenode = BNWhichNode(netobj, 'Shape');
sizenode = BNWhichNode(netobj, 'Size');
predictionNodes =  [actionnode colornode shapenode sizenode];

results = zeros(1,Ntest);
for qnum = 1:Ntest
    % enter evidence
    netobj = BNEnterWordEvidence(netobj, questions{qnum}, 0);
    % get probabilities for affordance nodes
    marg = marginal_nodes(netobj.engine, predictionNodes);
    % convert answers into multidimensional array
    ans_sizes = netobj.node_sizes(predictionNodes);
    ans_array = 1;
    first_idx = 0;
    for dim=1:length(ans_sizes) % [3 4 2 3]
        idxs = first_idx + (1:ans_sizes(dim));
        first_idx = first_idx + ans_sizes(dim); 
        ans_array = multikron(ans_array, answers(qnum,idxs));
    end
    % compare to answer
    scores = ans_array .* marg.T;
    results(qnum) = sum(scores(:));
end
