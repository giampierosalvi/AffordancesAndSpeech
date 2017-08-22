function textab = make_improve_asr_table(netobj)

threshold = 0.00000001;

% 7 utterances
spoken{1} = {'tapping', 'small','sliding'};
spoken{2} = {'tapping', 'box','slides'};
spoken{3} = {'tapped', 'ball','rolls'};

asrprobs = [0.1 0.07 0.01]';
asrbest = 1;

% 6 objects
obj{1}.color = 'green1'; obj{1}.size = 'big';    obj{1}.shape = 'circle'; obj{1}.txtcolor = 'light green';
obj{2}.color = 'yellow'; obj{2}.size = 'medium'; obj{2}.shape = 'circle'; obj{2}.txtcolor = 'yellow';
obj{3}.color = 'green2'; obj{3}.size = 'small';  obj{3}.shape = 'box'; obj{3}.txtcolor = 'dark green';
obj{4}.color = 'blue';   obj{4}.size = 'medium'; obj{4}.shape = 'box'; obj{4}.txtcolor = 'blue';
obj{5}.color = 'blue';   obj{5}.size = 'big';    obj{5}.shape = 'box'; obj{5}.txtcolor = 'blue';
obj{6}.color = 'green2'; obj{6}.size = 'small';  obj{6}.shape = 'circle'; obj{6}.txtcolor = 'dark green';

hypprobs = zeros(length(spoken), length(obj));
for ob = 1:length(obj)
    %netobj = BNEnterWordEvidence(netobj, spoken{sp}, 0);
    netobj = BNEnterNodeEvidence(netobj, {'Color', obj{ob}.color, 'Shape', obj{ob}.shape, 'Size', obj{ob}.size}, 0);
    for sp=1:length(spoken)
        wordprobs = zeros(1, length(spoken{sp}));
        for word=1:length(spoken{sp})
            marg = marginal_nodes(netobj.engine, [BNWhichNode(netobj, spoken{sp}(word))]);
            wordprobs(word) = marg.T(2); % probability of the word being said
        end
        hypprobs(sp, ob) = prod(wordprobs);     
    end
end

postprobs = hypprobs .* (asrprobs * ones(1,length(obj))); % probs from equation 4
globprobs = sum(postprobs'); % summing over all possible objects on table
[dummy, whichbold] = max(globprobs);

%textab = sprintf('\\documentclass[landscape]{article}\n');
%textab = [textab sprintf('\\begin{document}\n\\tiny\n')];
textab = sprintf('\\begin{tabular}{l|CCC}\\hline\n');
textab = [textab sprintf(' & \\multicolumn{3}{c}{N-best list from ASR (N=3)}\\\\\\hline\n')];
textab = [textab sprintf(' objects on the table ')];
for sp=1:length(spoken)
    if sp==asrbest
        textab = [textab sprintf('& ``%s %s %s'''' \\textbf{p=%4.3f}', spoken{sp}{1}, spoken{sp}{2}, spoken{sp}{3}, asrprobs(sp))];
    else
        textab = [textab sprintf('& ``%s %s %s'''' p=%4.3f', spoken{sp}{1}, spoken{sp}{2}, spoken{sp}{3}, asrprobs(sp))];
    end
end
textab = [textab sprintf(' \\\\\\hline\n')];
for ob=1:length(obj)
    textab = [textab sprintf(' %s %s %s ', obj{ob}.txtcolor, obj{ob}.size, obj{ob}.shape)];
    for sp=1:length(spoken)
        if hypprobs(sp,ob)<threshold
            textab = [textab sprintf('& 0.0 ')];
        else
            textab = [textab sprintf('& %4.3E ', hypprobs(sp,ob))];
        end
    end
    textab = [textab sprintf('\\\\\n')];
end
textab = [textab sprintf('\\hline\nfinal score ')];
for sp=1:length(spoken)
    if sp==whichbold
        textab = [textab sprintf('& \\textbf{%4.3E} ', globprobs(sp))];
    else
        textab = [textab sprintf('& %4.3E ', globprobs(sp))];
    end
end
textab = [textab sprintf('\\\\\\hline\n\\end{tabular}\n')];
