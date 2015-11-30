if ~exist('jester_loaded')
    load_data;
end

%% POP Algorithm
% http://goldberg.berkeley.edu/pubs/eigentaste.pdf
% NMAE of 0.203 reported

mu = nanmean(Ytr);
YhatPOP = repmat(mu, nTe, 1);

NMAE(Yte, YhatPOP) % 0.2076

%% K-Nearest Neighbors
% TODO



%% SVT
% TODO