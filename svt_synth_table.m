function [] = svt_synth_table(out_file)
% Recreate Table 5.1 from SVT paper
% Test SVT on synthetic data
% out_file: filename to save to

% efficient library for sparse svd
addpath lmsvd;

% Set up experiment parameters

nruns = 4; % number of times to average over
var = 2.0; % variance of synthetic data

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
    
    Mhat = zeros(n, n, nruns);
    time = zeros(1, nruns);
    iter = zeros(1, nruns);
    relerr = zeros(1, nruns);
    
    max_iter = 250;
    tau = 5*n;
    delta = 1.2*n*n/m;
    l = 5;
    eps = 1*10^-3;
    

    % average over several runs, in parallel
    parpool('local', 4);

    parfor j = 1:nruns
        [Mtrue, M] = synthetic(n, rank, m, var);
        k_0 = ceil(tau/(delta*norm(M(~isnan(M(:))))));
        [Mht, tim, itr, rel] = svt(M, Mtrue, max_iter, tau, k_0, delta, l, eps);
	Mhat(:, :, j) = Mht;
	time(j) = tim;
	iter(j) = itr;
	relerr(j) = rel;
    end
    
    %times(i) = time;
    %iters(i) = iter;
    %relerrs(i) = relerrs;

    rows(i).Mhat = Mhat;
    rows(i).time = time;
    rows(i).iter = iter;
    rows(i).relerr = relerr;
    
    fprintf('time = %06.1f, iter = %4.1f, relative error = %1.2f x 10^-4\n', ...
            mean(time), mean(iter), mean(relerr)/(10^-4));
    
    mySave(out_file, rows);
    
end


function [] = mySave(fn, rows)
% required to save from MATLAB's parfor

    save(fn, 'rows');
