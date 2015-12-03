n = 10;
r = 2;
m = 25;

[M, Md] = synthetic(n, r, m);

Md(Md==0) = nan;

Mhat = svt(Md, M);
