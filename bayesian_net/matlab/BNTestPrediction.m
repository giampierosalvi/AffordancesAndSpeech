function results = BNTestPrediction(netobj, trainingrange, repetitions, datafn)

% test predictions by summing the marginal probability over all cases
% considered correct by the human judges

% read data
[questions, answers] = ReadInstructionsJudgements(datafn);

% size of data
Ntrain = size(netobj.data, 2);
Ntest = length(questions);
Nsteps = length(trainingrange);

% results holder (preallocate)
results = zeros(length(trainingrange), repetitions);

% this is to run in parallel on 4 cores
matlabpool(4);

for step = 1:Nsteps;
    traindatalen = trainingrange(step);
    parfor rep = 1:repetitions
        % first train the net
        examples = randsample(Ntrain,traindatalen);
        netobjt = BNLearnStructure(netobj, netobj.data(:,examples));
        netobjt = BNLearnParameters(netobjt, netobj.data(:,examples));

        % then test
        tmpres = BNSoftPredictionAccuracy(netobjt, questions, answers);
        results(step,rep) = mean(tmpres);
    end
end
matlabpool close;
