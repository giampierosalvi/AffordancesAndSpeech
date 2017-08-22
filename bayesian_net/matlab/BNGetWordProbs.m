function probs = BNGetWordProbs(netobj)
%
%
%
% (C) 2010, Giampiero Salvi, <giampi@kth.se>

if ~isfield(netobj, 'engine') || ...
   ~strcmp(class(netobj.engine), 'jtree_inf_engine')
    error('you have to enter evidence first (see BNEnterEvidence)');
end

probs = zeros(1,length(netobj.WORDNODES));
for h=1:length(netobj.WORDNODES)
    marg = marginal_nodes(netobj.engine, netobj.WORDNODES(h));
    probs(h) = marg.T(2); % probability of the word being said
end
