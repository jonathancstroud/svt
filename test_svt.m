%% Generate synthetic data

n = 1000;
r = 5;
m = n*n*0.12;

[Mtrue, M] = synthetic(n, r, m);

M(M==0) = nan;


%% Set SVT options

svt_opts.max_iter = 100;
svt_opts.tau = 5*n;
svt_opts.delta = 1.2*n*n/sum(~isnan(M(:)));
svt_opts.k_0 = ceil(svt_opts.tau/(svt_opts.delta*norm(M(~isnan(M(:)))))); % must be int!
svt_opts.l = 5;
svt_opts.eps = 10^-4;


%% Run and eval SVT

Mhat = svt(M, Mtrue, svt_opts);

% Verify a few things:
fprintf('NMAE (final): %f\n', NMAE(Mhat, Mtrue));
fprintf('Computing SVD of Mhat...\n');

[U, S, V] = svds(Mhat, 2*r); % cap it above

fprintf('True rank: %d\n', r);
fprintf('Estimated rank: %d\n', sum(diag(S)>10^-4));