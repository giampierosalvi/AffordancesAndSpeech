function make_report(netobj, name, savedots)

if nargin<3
    savedots = 0;
end

repdir = name;
figdir = [repdir '/figures'];

system(['mkdir -p ' figdir]);
numbername = {'zero', 'one', 'two', 'three', 'four', 'five'};
rep = sprintf('\\documentclass{report}\n\\usepackage{graphicx}\n\\graphicspath{{figures/}}\\usepackage{array}\\newcolumntype{C}{>{\\centering\\arraybackslash}p{1.5cm}}\n\\begin{document}\n');
%% General info
rep = [rep sprintf('\\section*{General Info}\n\\begin{itemize}\n')];
rep = [rep sprintf('\\item Name: \\verb|%s|\n', name)];
rep = [rep sprintf('\\item Likelihood: \\verb|%d|\n', netobj.L)];
rep = [rep sprintf('\\end{itemize}\n')];

subplot(2,1,1)
bar(sum(netobj.data(netobj.WORDNODES,:)'-1))
set(gca, 'xtick', 1:length(netobj.WORDNODES), 'xticklabel', netobj.nodeNames(netobj.WORDNODES))
rotateticklabel(gca,90);
ylabel('occurrence')
print2pdf([figdir '/wordfreq']);
rep = [rep sprintf('\\includegraphics[width=\\textwidth]{wordfreq}\\par\n')];
% affordance net
rep = [rep sprintf('\\section*{Affordance Network}\n')];
dot = dag2dot(netobj.dag(netobj.AFFORDNODES,netobj.AFFORDNODES), netobj.nodeNames(netobj.AFFORDNODES), netobj.AFFORDNODES, netobj.AFFORDNODES, 'overlap=false');
dot2lang(dot, [figdir '/affordances.pdf'], 'pdf', 'dot');
rep = [rep sprintf('\\includegraphics[width=\\textwidth]{affordances}\\par\n')];
% whole net
rep = [rep sprintf('\\section*{Whole Network}\n')];
dot = dag2dot(netobj.dag, netobj.nodeNames, 1:netobj.N, netobj.AFFORDNODES, 'overlap=false');
if savedots
    fh = fopen([figdir '/all.dot'], 'w');
    fprintf(fh, '%s', dot);
    fclose(fh);
end
dot2lang(dot, [figdir '/all.pdf'], 'pdf', 'dot');
rep = [rep sprintf('\\includegraphics[width=\\textwidth]{all}\\par\n')];
%% subnet plots
for nparents = 0:5
    % find words with nparents parents
    display_words = netobj.WORDNODES(sum(netobj.dag(:,netobj.WORDNODES),1)==nparents);
    if isempty(display_words)
        continue;
    end
    rep = [rep sprintf('\\section*{Words with %d parent(s)}\n', nparents)];
    if(nparents)
        parents = find(sum(netobj.dag(:,display_words),2));
        % iterate over all combinations of nparents elements from parents
        for par = nchoosek(parents,nparents)'
            if nparents==1
                par_words = netobj.WORDNODES(netobj.dag(par,netobj.WORDNODES)==1);
            else
                par_words = netobj.WORDNODES(sum(netobj.dag(par',netobj.WORDNODES))==nparents);
            end
            words = intersect(par_words, display_words);
            if isempty(words)
                continue;
            end
            dot = dag2dot(netobj.dag, netobj.nodeNames, words, netobj.AFFORDNODES, 'overlap=false');
            if savedots
                dotfname = [numbername{nparents+1} '_parents_' strcat(netobj.nodeNames{par}) '.dot'];
                fh = fopen([figdir '/' dotfname], 'w');
                fprintf(fh, '%s', dot);
                fclose(fh);
            end
            fname = [numbername{nparents+1} '_parents_' strcat(netobj.nodeNames{par}) '.pdf'];
            %rep = [rep '\begin{figure}'];
            rep = [rep sprintf('\\includegraphics[width=\\textwidth]{%s}\\par\n', fname)];
            %rep = [rep '\end{figure}'];
            dot2lang(dot, [figdir '/' fname], 'pdf', 'dot');
        end
    else
        dot = dag2dot(netobj.dag, netobj.nodeNames, display_words, netobj.AFFORDNODES, 'overlap=false');
        if savedots
            dotfname = [numbername{nparents+1} '_parents_None.dot'];
            fh = fopen([figdir '/' dotfname], 'w');
            fprintf(fh, '%s', dot);
            fclose(fh);
        end
        fname = [numbername{nparents+1} '_parents_None.pdf'];
        rep = [rep sprintf('\\includegraphics[width=\\textwidth]{%s}\\par\n', fname)];
        dot2lang(dot, [figdir '/' fname], 'pdf', 'dot');
    end
end
%% action/object selection table
rep = [rep sprintf('\\section*{Action/Object selection table}\n')];
rep = [rep make_action_object_select_table(netobj)];
rep = [rep make_improve_asr_table(netobj)];
rep = [rep sprintf('\\end{document}\n')];
fid = fopen([repdir '/report.tex'], 'w');
fprintf(fid, '%s', rep);
fclose(fid);
system(['cd ' repdir '; pdflatex report']);
