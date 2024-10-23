
function [Result] = isposdef(A)
% 
% Tests if Matrix A is positive definited.
% A must be square
%
% Brett Gray 16-Jun-03

sizeA = size(A);
nr = sizeA(1);
nc = sizeA(2);

if nr ~= nc
  error('ERROR - A must be a square matrix')
end

EigenVals = eig(A);
Result = 1;

n = 1;
while n <= nr
  if EigenVals(n) <= 0
    Result = 0;
  end
  n = n + 1;
end