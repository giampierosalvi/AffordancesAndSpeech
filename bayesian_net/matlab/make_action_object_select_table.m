function textab = make_action_object_select_table(netobj)

threshold = 0.01;

% 7 utterances
spoken{1} = {'small', 'grasped'};
spoken{2} = {'moving', 'green'};
spoken{3} = {'ball', 'sliding'};
spoken{4} = {'big', 'rolling'};
spoken{5} = {'has', 'rising'};
spoken{6} = {'sliding', 'small'};
spoken{7} = {'rises', 'yellow'};

% 6 objects
% 6 objects
obj{1}.color = 'green1'; obj{1}.size = 'big';    obj{1}.shape = 'circle'; obj{1}.txtcolor = 'light green';
obj{2}.color = 'yellow'; obj{2}.size = 'medium'; obj{2}.shape = 'circle'; obj{2}.txtcolor = 'yellow';
obj{3}.color = 'green2'; obj{3}.size = 'small';  obj{3}.shape = 'box'; obj{3}.txtcolor = 'dark green';
obj{4}.color = 'blue';   obj{4}.size = 'medium'; obj{4}.shape = 'box'; obj{4}.txtcolor = 'blue';
obj{5}.color = 'blue';   obj{5}.size = 'big';    obj{5}.shape = 'box'; obj{5}.txtcolor = 'blue';
obj{6}.color = 'green2'; obj{6}.size = 'small';  obj{6}.shape = 'circle'; obj{6}.txtcolor = 'dark green';

actionnode = BNWhichNode(netobj, 'Action');
colornode = BNWhichNode(netobj, 'Color');
shapenode = BNWhichNode(netobj, 'Shape');
sizenode = BNWhichNode(netobj, 'Size');

maxprobs = zeros(length(spoken), length(obj));
maxacts = zeros(length(spoken), length(obj));
for sp=1:length(spoken)
    netobj = BNEnterWordEvidence(netobj, spoken{sp}, 0);
    marg = marginal_nodes(netobj.engine, [actionnode colornode shapenode sizenode]);
    for ob = 1:length(obj)
        coloridx = BNWhichNodeValue(netobj, colornode, obj{ob}.color);
        shapeidx = BNWhichNodeValue(netobj, shapenode, obj{ob}.shape);
        sizeidx = BNWhichNodeValue(netobj, sizenode, obj{ob}.size);
        [maxprobs(sp,ob) maxacts(sp,ob)] = max(marg.T(:,coloridx,shapeidx,sizeidx));
    end
end

[dummy, whichbold] = max(maxprobs, [], 2);

%textab = sprintf('\\documentclass[landscape]{article}\n');
%textab = [textab sprintf('\\begin{document}\n\\tiny\n')];
textab = sprintf('\\tiny\n\\begin{tabular}{l|ccccccc}\\hline\n');
textab = [textab sprintf(' & \\multicolumn{7}{c}{Verbal input}\\\\\n')];
textab = [textab sprintf(' objects on the table ')];
for sp=1:length(spoken)
    textab = [textab sprintf('& ``%s %s''''', spoken{sp}{1}, spoken{sp}{2})];
end
textab = [textab sprintf(' \\\\\\hline\n')];
for ob=1:length(obj)
    textab = [textab sprintf(' %s %s %s ', obj{ob}.txtcolor, obj{ob}.size, obj{ob}.shape)];
    for sp=1:length(spoken)
        if round(maxprobs(sp,ob)*100)/100<threshold
            textab = [textab sprintf('& - ')];
        else
           if whichbold(sp)==ob
                textab = [textab sprintf('& \\textbf{%s, p=%4.2f} ', netobj.nodeValueNames{1}{maxacts(sp,ob)}, maxprobs(sp,ob))];
            else
                textab = [textab sprintf('& %s, p=%4.2f ', netobj.nodeValueNames{1}{maxacts(sp,ob)}, maxprobs(sp,ob))];
            end
        end
    end
    textab = [textab sprintf('\\\\\n')];
end
textab = [textab sprintf('\\hline\n\\end{tabular}\n')];
