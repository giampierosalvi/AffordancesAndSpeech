function dot = dagdiff2dot(dag1, dag2, names, subset, shaded, graphopts)
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
    
nargchk(2, 6, nargin);
% check dag
dagsize = size(dag1);
if dagsize(1) ~= dagsize(2)
  error('dag1 must be a square matrix\n');
end
if size(dag2,1) ~= dagsize(1) || size(dag2,2) ~= dagsize(1)
    error('dag2 must have the same size as dag1\n');
end
% default: no extra option
if nargin < 6, graphopts = 'ratio=fill'; end
% default: no node is shaded
if nargin < 5, shaded = []; end
% default: all nodes are displayed
if nargin < 4, subset = 1:dagsize(1); end
% default: node names in the form n1, n2, ...
if nargin < 3
    names = cell(dagsize(1),1);
    for h = 1:dagsize(1)
        names{h} = ['n' num2str(h)];
    end
end
if length(names) ~= dagsize(1)
    error('names bust have the same length as the number of colunms of dag\n')
end
% find links only present in dag1
onlydag1 = (dag1-dag2) == 1;
% find links only present in dag2
onlydag2 = (dag2-dag1) == 1;
onlydag12 = dag1&dag2;
% merge the two dags
dag = dag1|dag2;
% find parents (the parents function in FullBNT only works with single index)
parents = find(sum(dag(:,subset),2));
% eliminate repetitions of the same node
plotnodes = unique(sort([parents' subset]));
isshaded = ismember(plotnodes, shaded);
dag = dag(plotnodes, plotnodes);
onlydag1 = onlydag1(plotnodes, plotnodes);
onlydag2 = onlydag2(plotnodes, plotnodes);
onlydag12 = onlydag12(plotnodes, plotnodes);
dagsize = size(dag);
names = names(plotnodes);
[from1 to1] = ind2sub(dagsize, find(onlydag1));
[from2 to2] = ind2sub(dagsize, find(onlydag2));
[from12 to12] = ind2sub(dagsize, find(onlydag12));
nlinks1 = length(from1);
nlinks2 = length(from2);
nlinks12 = length(from12);
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
for h=1:nlinks1
    dot = [dot sprintf('\tn%d -> n%d [style=dashed, color=red]\n', from1(h)-1, to1(h)-1)];
end
for h=1:nlinks2
    dot = [dot sprintf('\tn%d -> n%d [color=red]\n', from2(h)-1, to2(h)-1)];
end
for h=1:nlinks12
    dot = [dot sprintf('\tn%d -> n%d\n', from12(h)-1, to12(h)-1)];
end

dot = [dot sprintf('}\n')];
