function [Xk, Uk, Sk, Vk, time, iter, relerr] = svt(M, Mtrue, max_iter, tau, delta, k_0, l, eps)
% Singular Value Thresholding
% http://statweb.stanford.edu/~candes/papers/SVT.pdf

addpath lmsvd

tic;

[n, d] = size(M);
Xk = M; Xk(isnan(Xk))=0;
Yk = k_0*delta*M; Yk(isnan(Yk)) = 0;

r = 0;
for i = 1:max_iter
    
    s = r+1;
    while 1
        % Compute top s singular values of Yk
        [U, S, V] = lmsvd(Yk, s, []);
        sigmas = diag(S);
        s = min(s + l, min(n, d)/2);
        if sigmas(s - l) <= tau
            break;
        end
    end
    
    r = max(find(sigmas > tau));

    Uk = U(:, 1:r); Vk = V(:, 1:r);
    sigmas = max(sigmas-tau, 0);
    Sk = diag(sigmas(1:r));

    % Low-rank approximation Xk
    Xk = Uk*Sk*Vk';
    P = M - Xk; P(isnan(M)) = 0;
    Mt = M; Mt(isnan(Mt))=0;

    if norm(P, 'fro')/norm(Mt, 'fro') <= eps
        break;
    end
    Yk = Yk + delta*P;

    fprintf('iter %d NMAE: %f\n', i, NMAE(Mtrue, Xk));
end

time = toc;
iter = i;
relerr = norm(P, 'fro')/norm(Mt, 'fro');