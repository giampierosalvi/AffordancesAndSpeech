function dot = dag2dot(dag, names, subset, shaded, graphopts)
%
% DAG2DOT returns a string containing a directd acyclic graph definition in
%   dot format for high quality pictures. See DOT2LANG to generate pictures
%   files.
%
% DOT = DAG2DOT(DAG, [NAMES,] [SUBSET,] [SHADED])
% DOT is a string variable. NAMES is a cell array with node names
% for each node in DAG, default names are n1, n2, .... If SUBSET is
% given as a vector if indexes, only the corresponding nodes
% indexed and their parents are included in the dot file. If SHADED
% is given as a vector of indexes, the corresponding nodes are
% given a gray background.
%
% See also: dot2lang
%
% (C) 2009-2010 Giampiero Salvi, giampi@kth.se
    
nargchk(1, 5, nargin);
% check dag
dagsize = size(dag);
if dagsize(1) ~= dagsize(2)
  error('dag must be a square matrix\n');
end
% default: no extra option
if nargin < 5, graphopts = 'ratio=fill'; end
% default: no node is shaded
if nargin < 4, shaded = []; end
% default: all nodes are displayed
if nargin < 3, subset = 1:dagsize(1); end
% default: node names in the form n1, n2, ...
if nargin < 2
    names = cell(dagsize(1),1);
    for h = 1:dagsize(1)
        names{h} = ['n' num2str(h)];
    end
end
if length(names) ~= dagsize(1)
    error('names bust have the same length as the number of colunms of dag\n')
end
% find parents (the parents function in FullBNT only works with single index)
parents = find(sum(dag(:,subset),2));
% eliminate repetitions of the same node
plotnodes = unique(sort([parents' subset]));
isshaded = ismember(plotnodes, shaded);
dag = dag(plotnodes, plotnodes);
dagsize = size(dag);
names = names(plotnodes);
[from to] = ind2sub(dagsize, find(dag));
nlinks = length(from);
nnodes = dagsize(1);
% export graph definition
dot = '';
dot = [dot sprintf('digraph test {\n')];
dot = [dot sprintf('\tmargin="0";\n', graphopts)];
dot = [dot sprintf('\tgraph [%s];\n', graphopts)];
%dot = [dot sprintf('\tnode [label="\\N", color=black];\n')];
%dot = [dot sprintf('\tedge [color=black];\n')];

% export nodes
for h=1:nnodes
    if isshaded(h)
        dot = [dot sprintf('\tn%d [label=%s, style=filled, fillcolor=gray]\n', h-1, names{h})];
    else
        dot = [dot sprintf('\tn%d [label=%s]\n', h-1, names{h})];
    end
end

% export edges
for h=1:nlinks
    dot = [dot sprintf('\tn%d -> n%d\n', from(h)-1, to(h)-1)];
end

dot = [dot sprintf('}\n')];
