function netobj = BNLearnStructureNoAffordance(netobj, data, maxnparents)
% learnStructure: learns the structure of the Bayesian network 
% network.
% NEW_NETOBJ = learnStructure(NETOBJ, [DATA])
% NETOBJ is returned by createBN
% DATA is a matrix with each column corresponding to a node, if missing,
% NETOBJ.DATA is used instead.
%
% depends: FullBNT toolbox
% on my computer I need to add the path to the BNT toolbox
% addpath(genpath('/home/giampi/matlab/toolbox/FullBNT-1.0.4'))
%
% (c) 2009, Giampiero Salvi, giampi@kth.se

if nargin < 3
    MAXNPARENTS = 10;  % This limits the number of parent nodes
else
    MAXNPARENTS = maxnparents;
end

% using internally stored data?
if nargin<2 || isempty(data)
    if isempty(netobj.data)
        error('no data specified');
    end
    disp('...using internally stored trainig data');
    data = netobj.data;
end

fprintf(1,'...first remove affordance dependencies\n');
netobj.idag(netobj.AFFORDNODES,netobj.AFFORDNODES) = zeros(length(netobj.AFFORDNODES));

fprintf(1,'...learn the affordance-word network structure (maxnparents=%d)\n', MAXNPARENTS);
    
% K2 ordering of nodes (this is actually the standard order 1:N)
netobj.order = netobj.ALLNODES;

% Structure learning using K2 algorithm
ncases=size(data,2);

% Learn the structure of the network using K2 algorithm (greedy)
% (modified version of learn_struct_K2 that allows for initial DAG)
netobj.dag = learn_partial_struct_K2(data, netobj.node_sizes, netobj.order, ...
                                  'scoring_fn','bic', ...
                                  'type', netobj.type, ...
                                  'max_fan_in', MAXNPARENTS, ...
                                  'clamped', repmat(netobj.clamped_nodes', 1, ncases), ...
                                  'verbose','yes', ...
                                  'initdag', netobj.idag, ...
                                  'learnnodes', netobj.learnnodes, ...
                                  'potparents', netobj.potparents, ...
                                  'discrete', netobj.discrete_nodes, ...
                                  'params', netobj.sParams);
                              