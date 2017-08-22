function netobj = BNLearnStructure(netobj, data, maxnparents)
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

%if isfield(netobj, 'dag')==0,
%    learn='y';
%else
%    learn=input('There exist already a network.\nDo you want to learn the network? (y/n)','s');
%end
learn = 'y';

if strcmp(learn,'y'),

    fprintf(1,'...first learn the affordance network structure\n');

    % K2 ordering of nodes (this is actually the standard order 1:N)
    netobj.order = netobj.AFFORDNODES;

    % Structure learning using K2 algorithm
    ncases=size(data,2);

    % use only affordance data
    dataaff=netobj.data(netobj.AFFORDNODES,:);

   % Structure learning using K2 algorithm
    
    netobj.clamped_nodes(1:4)=1;
    
    % Learn the structure of the network using K2 algorithm (greedy)
    % for the affordance nodes
     netobj.idag(netobj.AFFORDNODES,netobj.AFFORDNODES) = ...
         learn_partial_struct_K2(dataaff, netobj.node_sizes(netobj.AFFORDNODES), ...
                                        netobj.order(netobj.AFFORDNODES), ...
                                       'scoring_fn','bic', ...
                                       'type', netobj.type(netobj.AFFORDNODES), ...
                                       'max_fan_in', 10, ...
                                       'clamped', repmat(netobj.clamped_nodes(netobj.AFFORDNODES)', 1, ncases), ...
                                       'verbose','yes', ...
                                       'initdag', zeros(8), ...
                                       'learnnodes', netobj.AFFORDNODES, ...
                                       'potparents', netobj.AFFORDNODES, ...
                                       'discrete', netobj.discrete_nodes(netobj.AFFORDNODES), ...
                                       'params', netobj.sParams(netobj.AFFORDNODES));
    %figure; draw_graph(netobj.idag(netobj.AFFORDNODES,netobj.AFFORDNODES), netobj.nodeNames(netobj.AFFORDNODES));
    %title('affordance network structure')

    fprintf(1,'...then learn the affordance-word network structure\n');
    
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
    %figure; draw_graph(netobj.dag, netobj.nodeNames); title('total network structure')
        
    %        if save_figures
    %         filename=strcat('K2_size',int2str(sz(i)),'.eps');
    %         print(gcf,'-depsc',filename);
    %         filename=strcat('K2_size',int2str(sz(i)),'.jpg');
    %         print(gcf,'-djpeg95',filename);
    %     end
    %        input('press enter to continue...\n')
    %end % this should be end of "for i=1:length(sz)"
    
end % should be end of "if strcmp(learn,'y')"
