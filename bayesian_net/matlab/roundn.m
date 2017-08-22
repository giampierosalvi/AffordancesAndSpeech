function y = roundn(x, n)
% ROUNDN - round to the nth digit

y = round(x*10^n)/10^n;
