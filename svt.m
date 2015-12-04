function [Xk] = svt(M, Mtrue, svt_opts)
% Singular Value Thresholding
% http://statweb.stanford.edu/~candes/papers/SVT.pdf

% They use lmsvd in the paper, matlab's svds seems to work fine
% addpath lmsvd

fprintf('---SVT options---\n');
disp(svt_opts)

max_iter = svt_opts.max_iter;
tau = svt_opts.tau;
delta = svt_opts.delta;
k_0 = svt_opts.k_0; % must be int!
l = svt_opts.l;
eps = svt_opts.eps;



[n, d] = size(M);
Xk = M; Xk(isnan(Xk))=0;

% Hyperparameters

% Set Y0
Yk = k_0*delta*M;% Yk(isnan(Yk))=0; Yk = Yk+randn(size(M));

% Projection
Yk(isnan(Yk)) = 0;

r = 0;
for i = 1:max_iter
    
    
    s = r+1;
    while 1
        % Compute top s singular values of Yk
        [U, S, V] = svds(Yk, s);
        sigmas = diag(S);
        
        s = s + l;
        
        if sigmas(s - l) <= tau
            break;
        end
        
    end
    
    r = max(find(sigmas > tau));

    U = U(:, 1:r); V = V(:, 1:r);
    sigmas = max(sigmas-tau, 0);

    % Low-rank approximation Xk
    Xk = U*diag(sigmas(1:r))*V';

    % Project onto Yk
    
    P = M - Xk; P(isnan(M)) = 0;
    Mt = M; Mt(isnan(Mt))=0;

    if norm(P, 'fro')/norm(Mt, 'fro') <= eps
        break;
    end
    
    
    Yk = Yk + delta*P;

    fprintf('iter %d NMAE: %f\n', i, NMAE(Mtrue, Xk));
end