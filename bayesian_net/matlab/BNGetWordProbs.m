function probs = BNGetWordProbs(netobj, word_indexes)
% BNGetWordProbs: returns probabilities of each word in the model
% 
% Inputs:
% netobj: affordance structure created by createBN
% word_indexes: optional vector of word indexes, default: netobj.WORDNODES
%
% Output:
% probs: vector of probabilities of each word corresponding to word_indexes
%
% (C) 2010, Giampiero Salvi, <giampi@kth.se>

if ~isfield(netobj, 'engine') || ...
   ~strcmp(class(netobj.engine), 'jtree_inf_engine')
    error('you have to enter evidence first (see BNEnterEvidence)');
end

if nargin<2
    word_indexes = netobj.WORDNODES
end

probs = zeros(1,length(word_indexes));
for h=1:length(word_indexes)
    marg = marginal_nodes(netobj.engine, word_indexes(h));
    probs(h) = marg.T(2); % probability of the word being said
end
