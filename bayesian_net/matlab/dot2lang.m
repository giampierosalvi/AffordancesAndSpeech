function [status, result] = dot2lang(dotdef, outfile, format, method)
%
% DOT2LANG gererates a graph file using dot.
%
% [STATUS, RESULT] = DOT2LANG(DOTDEF, OUTFILE, FORMAT)
% DOTDEF is a string variable containing an acyclic directed graph in DOT
%   format.
% OUTFILE is the output file name (default output.pdf)
% FORMAT is a string containing the format for the output file, any format
%   supported by dot is allowed, including pdf (default), eps, png, and
%   many more.
% METHOD is any method supported by graphviz, including 'dot' (default),
% 'neato', 'twopi', 'circo' and 'fdp'.
%
% NOTE: it requires graphviz to be installed on your system
%
% See also: dag2dot
%
% (C) 2010 Giampiero Salvi, giampi@kth.se

nargchk(1, 4, nargin);
if nargin < 4, method = 'dot'; end
if nargin < 3, format = 'pdf'; end
if nargin < 2, outfile = 'output.pdf'; end

[status, result] = system(['echo "' dotdef '" | ' method ' -T' format ' > ' outfile]);
