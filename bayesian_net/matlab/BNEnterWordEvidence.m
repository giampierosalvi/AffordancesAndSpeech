function [netobj] = BNEnterWordEvidence(netobj, wordlist, incremental)
% BNEnterWordEvidence:
% helper function to simplify entering hard evidence on words. In
% turns it calls BNEnterNodeEvidence with the corresponding node
% name, node value pairs.
%
% Inputs:
% wordlist:    cell array with the words observed.
% incremental: retains evidence specified so far (default true)
% Output:
% netobj:      updated object
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

nwords = length(wordlist);
node_value_pairs = cell(1, nwords*2);

for h=1:nwords
    node_value_pairs{2*h-1} = wordlist{h};
    node_value_pairs{2*h} = wordlist{h};
end
netobj = BNEnterNodeEvidence(netobj, node_value_pairs, incremental);
