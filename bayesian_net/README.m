% This file describes the steps to train and test the
% word-affordance network.
%
% From the data (not true anymore):
% experiment 99 is described wrongly 2/4 times (falling instead of rising).
% experiment 102 seems correct to me (don't know why it was excluded before)
% experiment 201 the box is still, but the grasp was successful
%
% 2010-03-24, Giampiero Salvi, giampi@kth.se

%% 0) add BNT toolbox and local functions to the path
clear all; close all;
addpath(genpath('~/matlab/toolbox/FullBNT-1.0.4'))
addpath('./matlab')
addpath('~/matlab/toolbox/GraphVizMat')

%% 1) create initial word-affordance network
netobj_asr = createBN('config/networkDefinition.txt');
netobj_lab = createBN('config/networkDefinition.txt');

%% 2) set default properties (node types, initial connections...)
netobj_asr = BNSetDefaults(netobj_asr);
netobj_lab = BNSetDefaults(netobj_lab);

%% 3) load data from text file (coming from ../asr_htk/workdir)
netobj_asr = BNLoadData(netobj_asr, 'data/sent-all_mllr3_aff_bag.txt');
netobj_lab = BNLoadData(netobj_lab, 'data/sent-1-5_lab_aff_bag.txt');

%% 3) learn the structure of the net
netobj_asr = BNLearnStructure(netobj_asr);
netobj_lab = BNLearnStructure(netobj_lab);

%% 4) learn the parameters of the net
netobj_asr = BNLearnParameters(netobj_asr);
netobj_lab = BNLearnParameters(netobj_lab);

%% 5) make figures and generate latex report
make_report(netobj_asr, 'report_netobj_mllr3');
make_report(netobj_lab, 'report_netobj_lab');

% make plot of difference
dot = dagdiff2dot(netobj_lab.dag, netobj_asr.dag, netobj_lab.nodeNames, 1:netobj_lab.N, netobj_lab.AFFORDNODES, 'overlap=false');
fh = fopen('mixed_all.dot','w');
fprintf(fh, '%s', dot);
fclose(fh);
dot2lang(dot, 'mixed_all.pdf', 'pdf', 'dot');

% accuracy of the recognizer at the bag-of-word level:
% data from ../asr_htk/workdir/sent-all_mllr3_word.bagres
% totsent = 1270;
% totwords = 49;
% bagres = textread('../asr_htk/workdir/sent-all_mllr3_word.bagres');
% falseaccepts = bagres(:,2)./bagres(:,1);
% falserejects = bagres(:,3)./bagres(:,1);
% fa = sum(falseaccepts)/totsent;
% fr = sum(falserejects)/totsent;
% acc = 1 -fa -fr

%% 6) estimate word probabilities for each affordance configuration
netobj=netobj_lab;
fid = fopen('config/affdata.txt', 'r');
fidout = fopen('word_probabilities.txt', 'w');
% parse header
line=fgetl(fid);
header = regexp(line, '[^\s]*', 'match');
% write header
fprintf(fidout, 'Exp');
for h=netobj.WORDNODES;
    fprintf(fidout, '\t%s', netobj.nodeNames{h});
end
fprintf(fidout, '\n');
while(1)
    line=fgetl(fid);
    if ~ischar(line), break, end
    lcont = regexp(line, '[^\s]*', 'match');
    fprintf(fidout, '%s', lcont{1}); % experiment number
    evidence = cell(1,(length(lcont)-1)*2);
    count = 1;
    for h = 2:length(header)
        evidence{count} = header{h};
        count = count+1;
        evidence{count} = lcont{h};
        count = count+1;
    end
    netobj = BNEnterNodeEvidence(netobj, evidence);
    probs = BNGetWordProbs(netobj);
    probs = probs/sum(probs);
    fprintf(fidout, '\t%f', probs);
    fprintf(fidout, '\n');
end
fclose(fid);
fclose(fidout);

bar(probs);
set(gca, 'xtick', 1:length(netobj_lab.WORDNODES), 'xticklabel', netobj_lab.nodeNames(netobj_lab.WORDNODES))
rotateticklabel(gca,90);

%% 7) test prediction

testpoints = [100 300 500 700 900 1100 1270];
repetitions = 50;

% soft prediction accuracy
pred_lab = BNTestPrediction(netobj_lab, testpoints, repetitions, 'data/instructions_judgement.txt');
pred_asr = BNTestPrediction(netobj_asr, testpoints, repetitions, 'data/instructions_judgement.txt');
save('soft_prediction_accuracy.mat', 'pred_*');

% this is added to try to answer one of the reviewers question about the
% difference between the accuracy in the lab and asr case
% hard prediction accuracy
bestpred_lab = BNTestBestPrediction(netobj_lab, testpoints, repetitions, 'data/instructions_judgement.txt');
bestpred_asr = BNTestBestPrediction(netobj_asr, testpoints, repetitions, 'data/instructions_judgement.txt');
save('hard_prediction_accuracy.mat', 'bestpred_*');

load('soft_prediction_accuracy.mat');
load('hard_prediction_accuracy.mat');


% make figures
subplot(2,2,1,'align')
boxplot(pred_lab', 'labels', testpoints)
set(gca,'XTickLabel',{' '})
%xlabel('number of training samples')
ylabel('soft prediction accuracy')
set(gca,'ylim', [0.3 1])
title('labeled data')
set(gca,'Position',[0.1 0.5 0.43 0.36])
%print2pdf('prediction_lab')
%figure
subplot(2,2,2,'align')
boxplot(pred_asr', 'labels', testpoints)
%xlabel('number of training samples')
%ylabel('soft prediction accuracy')
set(gca,'XTickLabel',{' '})
set(gca,'YTickLabel',{' '})
set(gca,'ylim', [0.3 1])
title('recognized data')
set(gca,'Position',[0.55 0.5 0.43 0.36])
subplot(2,2,3,'align')
boxplot(bestpred_lab', 'labels', testpoints)
xlabel('number of training samples')
ylabel('hard prediction accuracy')
set(gca,'ylim', [0.3 1])
set(gca,'Position',[0.1 0.1 0.43 0.36])
%title('labelled data')
%print2pdf('prediction_lab')
%figure
subplot(2,2,4,'align')
boxplot(bestpred_asr', 'labels', testpoints)
xlabel('number of training samples')
%ylabel('hard prediction accuracy')
set(gca,'YTickLabel',{' '})
set(gca,'ylim', [0.3 1])
set(gca,'Position',[0.55 0.1 0.43 0.36])
%title('recognized data')
print2pdf('prediction_all')

%% 8) copy figures to paper
destdir = '../../../../../usr/gsalvi/2009-afford-and-speech-journal/figures';
models = {'netobj_lab', 'netobj_mllr3'};
for k=1:length(models)
    list = dir(['report_' models{k} '/figures/*.pdf']);
    for h=1:length(list)
        system(['cp report_' models{k} '/figures/' list(h).name ' ' destdir '/' models{k} '_' list(h).name]);
    end
end

%% 9) check what happens without affordances (answer to review)

% first run steps 0-5, then
% now learn the structure with just one parent for each word and no
% affordance dependencies
netobjnoaff_lab = BNLearnStructureNoAffordance(netobj_lab, [], 1);
netobjnoaff_asr = BNLearnStructureNoAffordance(netobj_asr, [], 1);
% now learn the parameters as usual
netobjnoaff_lab = BNLearnParameters(netobjnoaff_lab);
netobjnoaff_asr = BNLearnParameters(netobjnoaff_asr);
% run step 4

% evaluate
[questions, answers] = ReadInstructionsJudgements('data/instructions_judgement.txt');
spa_lab = BNSoftPredictionAccuracy(netobj_lab, questions, answers);
spa_asr = BNSoftPredictionAccuracy(netobj_asr, questions, answers);
hpa_lab = BNHardPredictionAccuracy(netobj_lab, questions, answers);
hpa_asr = BNHardPredictionAccuracy(netobj_asr, questions, answers);
spanoaff_lab = BNSoftPredictionAccuracy(netobjnoaff_lab, questions, answers);
spanoaff_asr = BNSoftPredictionAccuracy(netobjnoaff_asr, questions, answers);
hpanoaff_lab = BNHardPredictionAccuracy(netobjnoaff_lab, questions, answers);
hpanoaff_asr = BNHardPredictionAccuracy(netobjnoaff_asr, questions, answers);

% make R compatible table for statistical analysis
Rtable = sprintf('scmethod,transcriptions,affordance,score\n');
Rtable = [Rtable sprintf('soft,lab,yes,%f\n', spa_lab)];
Rtable = [Rtable sprintf('hard,lab,yes,%f\n', hpa_lab)];
Rtable = [Rtable sprintf('soft,asr,yes,%f\n', spa_asr)];
Rtable = [Rtable sprintf('hard,asr,yes,%f\n', hpa_asr)];
Rtable = [Rtable sprintf('soft,lab,no,%f\n', spanoaff_lab)];
Rtable = [Rtable sprintf('hard,lab,no,%f\n', hpanoaff_lab)];
Rtable = [Rtable sprintf('soft,asr,no,%f\n', spanoaff_asr)];
Rtable = [Rtable sprintf('hard,asr,no,%f\n', hpanoaff_asr)];
fid = fopen('final_prediction_results.data', 'w');
fprintf(fid, '%s', Rtable);
fclose(fid);

% create table
% training data       |   labeled          recognized
% prediction accuracy | soft    hard     soft     hard
% without affordances |
% with affordances    |
m_spa_lab = roundn(mean(spa_lab),2); s_spa_lab = roundn(std(spa_lab),2); 
m_spa_asr = roundn(mean(spa_asr),2); s_spa_asr = roundn(std(spa_asr),2);
m_hpa_lab = roundn(mean(hpa_lab),2); s_hpa_lab = roundn(std(hpa_lab),2);
m_hpa_asr = roundn(mean(hpa_asr),2); s_hpa_asr = roundn(std(hpa_asr),2);
m_spanoaff_lab = roundn(mean(spanoaff_lab),2); s_spanoaff_lab = roundn(std(spanoaff_lab),2);
m_spanoaff_asr = roundn(mean(spanoaff_asr),2); s_spanoaff_asr = roundn(std(spanoaff_asr),2);
m_hpanoaff_lab = roundn(mean(hpanoaff_lab),2); s_hpanoaff_lab = roundn(std(hpanoaff_lab),2);
m_hpanoaff_asr = roundn(mean(hpanoaff_asr),2); s_hpanoaff_asr = roundn(std(hpanoaff_asr),2);
table = sprintf('\\begin{tabular}{l|cccc}\n');
table = [table sprintf('\\hline\\hline\n')];
table = [table sprintf('training data       & \\multicolumn{2}{c}{labeled}  & \\multicolumn{2}{c}{recognized} \\\\\n')];
table = [table sprintf('prediction accuracy & soft   (std)  & hard   (std)  & soft   (std)  & hard   (std) \\\\ \\hline\n')];
table = [table sprintf('without affordances & %2.2f (%2.2f) & %2.2f (%2.2f) & %2.2f (%2.2f) & %2.2f (%2.2f) \\\\\n', m_spanoaff_lab, s_spanoaff_lab, m_hpanoaff_lab, s_hpanoaff_lab, m_spanoaff_asr, s_spanoaff_asr, m_hpanoaff_asr, s_hpanoaff_asr)];
table = [table sprintf('with affordances    & %2.2f (%2.2f) & %2.2f (%2.2f) & %2.2f (%2.2f) & %2.2f (%2.2f) \\\\\n', m_spa_lab, s_spa_lab, m_hpa_lab, s_hpa_lab, m_spa_asr, s_spa_asr, m_hpa_asr, s_hpa_asr)];
table = [table sprintf('\\hline\\hline\n\\end{tabular}')];
fid = fopen('final_prediction_results.tex', 'w');
fprintf(fid, '%s', table);
fclose(fid);
