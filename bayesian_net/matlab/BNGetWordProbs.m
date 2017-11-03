function probs = BNGetWordProbs(netobj, word_indices)
% BNGetWordProbs: returns probabilities of each word in the model
% 
% Inputs:
% netobj: affordance structure created by createBN
% word_indices: optional vector of word indices, default: netobj.WORDNODES
%
% Output:
% probs: vector of probabilities of each word corresponding to word_indices
% 
% NOTE: if some of the words are given as evidence and are not
% excluded from word_indices, the returned probability will be 1.0
%
% See also BNEnterWordEvidence
%
% (C) 2010-2017, Giampiero Salvi, <giampi@kth.se>

if ~isfield(netobj, 'engine') || ...
   ~strcmp(class(netobj.engine), 'jtree_inf_engine')
    netobj = BNEnterNodeEvidence(netobj, {});
end

if nargin<2
    word_indices = netobj.WORDNODES;
end

probs = zeros(1,length(word_indices));
for h=1:length(word_indices)
    marg = marginal_nodes(netobj.engine, word_indices(h));
    probs(h) = marg.T(2); % probability of the word being said
end
