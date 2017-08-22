function [questions, answers] = ReadInstructionsJudgements(filename)

% assuming data in the format (for each line):
% Instruction grasp tap touch green1 green2 yellow blue circle box small medium big


% load data
fid = fopen(filename);
% parse header
line=fgetl(fid);
% load data (converting strings into indexes)
questions = {};
answers = [];
count = 1;
while(1)
    line=fgetl(fid);
    if ~ischar(line), break, end
    lcont = regexp(line, '[^\t]*', 'match');
    questions{count} = regexp(lcont{1}, '[^\s]*', 'match');
    vec = zeros(1,length(lcont)-1);
    for h=2:length(lcont), vec(h-1)=str2num(lcont{h}); end
    answers = [answers; vec];
    count = count+1;
end
fclose(fid);

% take majority vote (fix some mistakes in the answers)
answers = answers>2;
