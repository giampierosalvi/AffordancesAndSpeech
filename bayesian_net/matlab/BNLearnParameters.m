function netobj = BNLearnParameters(netobj, data)
% learnParameters: creates a Bayesian net out of a DAG and learns
% the parameters.
% NEW_NETOBJ = learnParameters(NETOBJ, DATA)
% NETOBJ as returned by learnStructure
% DATA is a matrix with each column corresponding to a node, if missing,
% NETOBJ.DATA is used instead.
%
% (c) 2009, Giampiero Salvi, giampi@kth.se

% using internally stored data?
if nargin<2
    if isempty(netobj.data)
        error('no data specified');
    end
    disp('using internally stored trainig data');
    data = netobj.data;
end

if isfield(netobj, 'dag')==0,
    error(['The structure of the Bayesian network has not yet been ' ...
           'learned (see BNLearnStructure.m)'])
end

% if isfield(netobj, 'bnet')==0,
%     learn='y';
% else
%     learn=input('There exist already a network.\nDo you want to learn the network? (y/n)','s');
% end
learn='y';
if strcmp(learn,'y'),
    % create the network with the dag straucture
    netobj.bnet = mk_bnet(netobj.dag, netobj.node_sizes, 'discrete', netobj.discrete_nodes, 'observed', netobj.onodes);

    % create CPDS to learn parameters
    for node=netobj.ALLNODES,
        netobj.bnet.CPD{node} = tabular_CPD(netobj.bnet, node, netobj.pParams{node}{:});
    end

    % learn params with observed values
    netobj.bnet = learn_params(netobj.bnet, data);
end
% Likelihood of the full dataset
ncases=size(data,2);
netobj.L = log_lik_complete(netobj.bnet, data, repmat(netobj.clamped_nodes', 1, ncases));
