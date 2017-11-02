function [netobj] = BNEnterWordEvidence(netobj, wordlist, incremental)
% BNEnterWordEvidence:
% helper function to simplify entering hard evidence on words. In
% turns it calls BNEnterNodeEvidence with the corresponding node
% name, node value pairs.
%
% wordlist: cell array with the words observed. If a word is unknown to
% the Bayesian network, a warning is generated and the word is ignored.
%
% incremental: retains evidence specified so far (default true)
%
% Example:
% netobj = BNEnterWordEvidence(netobj, {'robot', 'box', 'red', 'big'})
%
% equivalent to:
% netobj = BNEnterNodeEvidence(netobj, {'robot', 'robot', 'box', 'box', 'red', 'red', 'big', 'big'})
%
% (C) 2010-2017, Giampiero Salvi, <giampi@kth.se>

if nargin < 3
    incremental = 1;
end

if ~incremental || ~isfield(netobj, 'evidence')
    for h=netobj.ALLNODES
        netobj.evidence{h}=[];
    end
end

for h=1:length(wordlist)
    idx = find(strcmpi(wordlist(h), netobj.nodeNames(netobj.WORDNODES)));
    if isempty(idx)
        warning('word %s not in dictionary, ignoring\n', wordlist{h});
    else
        netobj.evidence{idx+netobj.WORDNODES(1)-1} = 2;
    end
end
netobj = BNEnterEvidence(netobj, netobj.evidence, incremental);
