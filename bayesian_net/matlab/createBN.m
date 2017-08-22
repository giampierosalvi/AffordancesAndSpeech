function netobj = createBN(deffilename)

% createBN: creates Bayesian Network from definition file
% Defines all the constants needed to run the word-affordance
% experiments. NETOBJ is a struct, look at the function to see the
% contained fields.
%
% Definition file format: for each node one line in the file contains the
% node name and a list of node value names, for example:
% ...
% Action grasp tap touch
% ...
% baltazar - baltazar
% ...
%
% (c) 2010, Giampiero Salvi, giampi@kth.se

netobj.nodeNames = {};
netobj.nodeValueNames = {};
netobj.node_sizes = [];

fid = fopen(deffilename);
ln = 0;
while(1)
    line=fgetl(fid);
    if ~ischar(line), break, end
    ln = ln+1;
    lcont = regexp(line, '[^\s]*', 'match');
    netobj.nodeNames{ln} = lcont{1};
    netobj.nodeValueNames{ln} = lcont(2:end);
    netobj.node_sizes = [netobj.node_sizes length(netobj.nodeValueNames{ln})];
end
fclose(fid);

% total number of nodes
netobj.N = ln;
netobj.ALLNODES = 1:netobj.N;

% creating initial empty DAG
netobj.idag = zeros(netobj.N,netobj.N);
