function [sentence, normprob] = BNScoreSentences(netobj, sentenceFilename, N)
% BNScoreSentences scores sentences according to word probabilities
%
% N: number of sentences (default: run getNumLines)
%
% (C) 2017, Giampiero Salvi <giampi@kth.se>

if nargin<3
    N=getNumLines(sentenceFilename);
end

% open file
fid = fopen(sentenceFilename);

% get list of words in correct order
words = netobj.nodeNames(netobj.WORDNODES);
% ...and corresponding probabilities
wordProbs = BNGetWordProbs(netobj);

% convert sentences to vectors of word indices
sentences = cell(1,N);
sentenceProbs = ones(1,N);

% read the sentences
sentenceidx = 1;
while(1)
    line=fgetl(fid);
    if ~ischar(line), break, end
    sentences{sentenceidx} = line;
    sentWords = regexp(line, '[^\s]*', 'match');
    sentLen = length(sentWords);
    %ldata = zeros(1, length(lcont));
    for h=1:sentLen
        idx = find(strcmpi(sentWords(h), words));
        if isempty(idx)
            error('out of vocabulary word: %s\n', sentWords{h});
        end
        sentenceProbs(sentenceidx) = sentenceProbs(sentenceidx) * wordProbs(idx);
    end
    sentencePrbos(sentenceidx) = sentenceProbs(sentenceidx)/sentLen;
    sentenceidx = sentenceidx+1;
end

[maxprob, maxidx] = max(sentenceProbs);
sentence = sentences{maxidx};
normprob = maxprob;
