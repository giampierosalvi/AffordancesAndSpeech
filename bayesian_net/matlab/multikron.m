function c = multikron(A, b)
% multikron: multidimensional Kronecker product
% A: multidimensional array
% b: vector
% c: is a multidim array of size [size(a) length(b)]
%
% (c) 2009, Giampiero Salvi, giampi@kth.se

b = b(:); % ensuring b is a vector
outputsize = [size(A) length(b)];

A = A(:); % this is just for practical reasons

c = [];
for h = 1:length(b)
    c = [c; A*b(h)];
end
c = squeeze(reshape(c, outputsize));
