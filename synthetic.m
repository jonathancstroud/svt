function [M, Md] = synthetic(n, rank, m)
% Generate synthetic data matrix as in SVT paper
% 
% Inputs:
%    n: scalar - size of unknown matrix (square)
%    rank: scalar - rank of unknown matrix
%    m: scalar - number of elements to sample


rank = min(rank, n);
m = min(n*n, m);

U = randn(n, rank)*2;
V = randn(n, rank)*2;
M = U*V';

idx = randperm(n*n);

Md = zeros(n, n);
Md(idx(1:m)) = M(idx(1:m));
Md(Md==0) = nan;