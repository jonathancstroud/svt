function [Xk] = svt(M, Mtrue)
% Singular Value Thresholding
% http://statweb.stanford.edu/~candes/papers/SVT.pdf

% They use lmsvd in the paper, matlab's svds seems to work fine
% addpath lmsvd

[n, d] = size(M);
Xk = M; Xk(isnan(Xk))=0;

% Hyperparameters
max_iter = 10;
tau = 2*d;
delta = 1.2*n*d/sum(~isnan(M(:)));
k_0 = 1;
l = 1;

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
    P = M - Xk; P(isnan(P)) = 0;
    Yk = Yk + delta*P;

    fprintf('iter %d: %f\n', i, NMAE(Mtrue, Xk));
end