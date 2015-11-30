function nmae = NMAE(Y, Yhat)
% Normalized Mean Absolute Error (NMAE)
% from http://goldberg.berkeley.edu/pubs/eigentaste.pdf

nmae = nanmean(nanmean(abs(Yhat-Y), 2)/20);

