function [] = table51()
% Recreate Table 5.1 from SVT paper

addpath lmsvd;

rows(1).n = 1000;
   rows(1).rank = 10; rows(1).mdr = 6;
rows(2).n = 1000;
   rows(2).rank = 50; rows(2).mdr = 4;
rows(3).n = 1000;
   rows(3).rank = 100; rows(3).mdr = 3;


rows(4).n = 5000;
   rows(4).rank = 10; rows(4).mdr = 6;
rows(5).n = 5000;
   rows(5).rank = 50; rows(5).mdr = 5;
rows(6).n = 5000;
   rows(6).rank = 100; rows(6).mdr = 4;

rows(7).n = 10000;
   rows(7).rank = 10; rows(7).mdr = 6;
rows(8).n = 10000;
   rows(8).rank = 50; rows(8).mdr = 5;
rows(9).n = 10000;
   rows(9).rank = 100; rows(9).mdr = 4;

rows(10).n = 20000;
   rows(10).rank = 10; rows(10).mdr = 6;
rows(11).n = 20000;
   rows(11).rank = 50; rows(11).mdr = 5;

rows(12).n = 30000;
   rows(12).rank = 10; rows(12).mdr = 6;
   
   
for i = 1:numel(rows)

    n = rows(i).n;
    rank = rows(i).rank;
    mdr = rows(i).mdr;
    m = mdr * rank * (2*n - rank);
    
    fprintf('n = %5d, rank = %3d, m/dr = %1d, m/n2 = %0.3f\n', ...
        n, ...
        rank, ...
        mdr, ...
        m/(n^2));
    
    time = zeros(1, 5);
    iter = zeros(1, 5);
    relerr = zeros(1, 5);
    
    max_iter = 100;
    tau = 5*n;
    delta = 1.2*n*n/m;
    l = 5;
    eps = 10^-4;
        
    
    % average over 5 runs
    for j = 1:5
        [Mtrue, M] = synthetic(n, rank, m);
        k_0 = ceil(tau/(delta*norm(M(~isnan(M(:))))));
        [time(j), iter(j), relerr(j)] = svt(M, Mtrue, max_iter, tau, k_0, delta, l, eps);
    end
    
    rows(i).time = time;
    rows(i).iter = iter;
    rows(i).relerr = relerr;
    
    fprintf('time = %06.1f, iter = %4.1f, relative error = %1.2f x 10^-4', mean(time), mean(iter), mean(relerr)/(10^-4));  
    
    save('table51_1.mat', 'rows');
    
end
    
    