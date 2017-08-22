function print2pdf(basename)
%
% print2pdf Prints to pdf with bounding box (uses eps2pdf)
%
% 2010, Giampiero Salvi, <giampi@kth.se>

filename = [basename '.eps'];
print('-depsc', filename)
system(['epstopdf ' filename]);
system(['rm -f ] ' filename]);
