function netobj = BNSetDefaults(netobj)
% BNSetDefaults
% Here I tried to collect all the defaults that are specific to our word
% affordance model. I put everything in the same file to help spot
% mistakes, for example parameters that are defined differently when we
% learn the structure and the distributions.
% Parameters that are set here are:
% - list of affordance and word nodes
% - type of each node
% - distribution kind
% - initial structure of the affordance network
% - prior distribution for each node
% - which nodes are learned during training

% the first 8 nodes are affordance nodes
netobj.AFFORDNODES = 1:8;
netobj.NUMAFFORD = length(netobj.AFFORDNODES);
% the rest are word nodes
netobj.WORDNODES = 9:netobj.N;
netobj.NUMWORDS = length(netobj.WORDNODES);

% Defaults from BNLearnStruct --------------------------------------------

% All nodes are discrete
netobj.discrete_nodes = netobj.ALLNODES; 
% All nodes are observable
netobj.onodes = netobj.ALLNODES;
% Action, Color, Shape, Size are special because their value is not
% stochastic
[dummy1,netobj.NONSTOCHNODES,dummy2]=intersect(netobj.nodeNames, {'Action', 'Color', 'Shape', 'Size'});
%netobj.NONSTOCHNODES = [];

% All nodes are of the tabular type
netobj.type = repmat({'tabular'}, 1, netobj.N);

% these are the parameters used in learning the structure
netobj.sParams = cell(netobj.N,1);
% For the affordance network
for node=netobj.AFFORDNODES,
    netobj.sParams{node}={'prior_type', 'dirichlet', 'dirichlet_weight', 1};
end
% For the words
for node=netobj.WORDNODES,
    netobj.sParams{node}={'prior_type', 'none'};
    %netobj.sParams{node}={'prior_type', 'dirichlet', 'dirichlet_weight', 1 };
end

% initial structure NOTE: Comments do not correspond to arcs!!!! Don't know why
%netobj.idag(netobj.AFFORDNODES,netobj.AFFORDNODES) = [
%0 0 0 0 0 1 1 1; % Action influences Hv, OHV Ct
%0 0 0 0 0 0 0 0; % Color does not influence
%0 0 0 0 0 0 1 1; % Shape influences Hv, OHV Ct
%0 0 0 0 0 0 1 0; % Size influences Hv, OHV Ct
%0 0 0 0 0 0 0 0; % Velocity does not influence
%0 0 0 0 1 0 0 0; % HV influences OV 
%0 0 0 0 1 0 0 1; % Di influences Ov, Ct
%0 0 0 0 1 0 0 0; % Co influences Ov
%];
%netobj.idag(1,6)=1; netobj.idag(1,7)=1; netobj.idag(1,8)=1; % Action influences Hv, OHV Ct
%netobj.idag(3,7)=1; netobj.idag(3,8)=1; % Shape influences Hv, OHV Ct
%netobj.idag(4,7)=1;  % Size influences Hv, OHV Ct
%netobj.idag(6,5)=1;  % HV influences OV 
%netobj.idag(7,5)=1; netobj.idag(7,8)=1; % Di influences Ov, Ct
%netobj.idag(8,5)=1; % Co influences Ov

% LUIS says (8-7-10): This is the structure actually learned from data
netobj.idag(netobj.AFFORDNODES,netobj.AFFORDNODES) = [
     0     0     0     0     1     1     1     1;
     0     0     0     0     0     0     0     0;
     0     0     0     0     1     0     0     1;
     0     0     0     0     1     0     0     0;
     0     0     0     0     0     1     0     0;
     0     0     0     0     0     0     0     1;
     0     0     0     0     0     0     0     0;
     0     0     0     0     0     0     0     0;
     ];

% only learning the affordance to word associations
netobj.learnnodes = netobj.WORDNODES;
netobj.potparents = netobj.AFFORDNODES;

% Clamped nodes are nodes actively set to a particular value
% (Therefore, we don't infere anything about them)
% NOTE: claped=1 is equivalent to adjustable=0
netobj.clamped_nodes=zeros(1,netobj.N);
% Luis (8-7-10) removed this
%netobj.clamped_nodes(netobj.NONSTOCHNODES) = 1;

% Defaults from BNLearnParameters ----------------------------------------
% LUIS says(8-7-10): We should keep just the same param types for structure
% and parameter learning. I've commented the pParams codenetobj.pParams = cell(netobj.N,1);
%for node=netobj.AFFORDNODES,
%    if netobj.clamped_nodes(node)
%        % don't learn the parameters
%        netobj.pParams{node}={'CPT', 'unif', 'adjustable', 0, 'prior_type','dirichlet','dirichlet_weight', 1};
%    else
%        netobj.pParams{node}={'CPT', 'unif','prior_type','dirichlet','dirichlet_weight', 1};
%    end
%end
%for node=netobj.WORDNODES,
%    netobj.pParams{node}={'CPT', 'unif','prior_type','dirichlet','dirichlet_weight', 1};
%end
netobj.pParams=netobj.sParams;
