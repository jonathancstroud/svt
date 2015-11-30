function [Mtr, Meval] = split(M, rats_rand, frac)
% Split data for matrix completion task
% Mtr: n x d matrix with (frac)% ratings kept
% Meval: n x d matrix with other (1-frac)% ratings remaining
% (lower frac means a harder problem)

    Mtr = M;
    Meval = M;
    Meval(rats_rand(1:floor(end*frac))) = nan;
    Mtr(rats_rand(floor(end*frac)+1:end)) = nan;
    
end