
if ~exist('jester_loaded')
    load_data;
end


%% POP Algorithm
% http://goldberg.berkeley.edu/pubs/eigentaste.pdf
% NMAE of 0.203 reported

mu = nanmean(Xtr);
Yhat = repmat(mu, nTe, 1);

NMAE(Yte, Yhat)

%% K-Nearest Neighbors
% TODO