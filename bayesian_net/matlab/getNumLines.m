function nlines = getNumLines(filename)
% getNumLines: returns the number of lines in filename
%
% (C) Giampiero Salvi <giampi@kth.se>

[status, result] = system(['wc -l < ' filename]);
nlines = str2num(result);
