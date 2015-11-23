
%% Load Jester dataset: http://eigentaste.berkeley.edu/dataset/
J1 = csvread('data/jester-data-1.csv'); J1 = J1(:, 2:end); J1(J1==99)=nan;
J2 = csvread('data/jester-data-2.csv'); J2 = J2(:, 2:end); J2(J2==99)=nan;
J3 = csvread('data/jester-data-3.csv'); J3 = J3(:, 2:end); J3(J3==99)=nan;

% J1 and J2 are much denser than J3
J = [J1; J2; J3];

% 10 of the columns are used to "seed" users and have dense ratings
dense_jokes = [5, 7, 8, 13, 15, 16, 17, 18, 19, 20];

%% Load joke texts
% TODO


%% Load Jester2.0+: http://eigentaste.berkeley.edu/dataset/
% Jplus = csvread('data/jesterfinal151cols.csv');


%% Define training/test splits
% Eigentaste paper evaluates on 18,000 random users (out of 57000)
% Here's how I propose we do the split:
% - We use 18,000 of the ~73K for evaluation (randomly chosen)
% - For the users in the test set, we keep their dense columns only
% - Predict the values in the non-dense columns
% - Error metric- Normalized MAE (from eigentaste paper)


% A few of the users have missing ratings even in the dense columns,
% discard them
keep = ~any(isnan(J(:, dense_jokes)), 2);
J = J(keep, :);

nTe = 18000;

% set random seed
rng(0);

[n, d] = size(J);
idx = randperm(n);

Xtr = J(idx(nTe+1:end), :);
Xte = J(idx(1:nTe), :);
Yte = Xte;

not_dense = true(1, d);
not_dense(dense_jokes)=false;
Xte(:, not_dense) = nan;




%% Mark data as loaded

jester_loaded = 1;
