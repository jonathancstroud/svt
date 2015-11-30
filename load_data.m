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

% A few of the users have missing ratings even in the dense columns,
% discard them
keep = ~any(isnan(J(:, dense_jokes)), 2);
J = J(keep, :);

% set random seed
rng(0);

% First split --------------------------------------------------------

% Eigentaste paper evaluates on 18,000 random users (out of 57000)
% - choose 18,000 of the ~73K for evaluation (randomly)
% - for the users in the test set, we keep their dense columns only
% - predict the values in the non-dense columns
% - error metric- Normalized MAE (from eigentaste paper)
% 
% Use this split when comparing against baseline methods from the
% eigentaste paper.

nTe = 18000;

[n, d] = size(J);
idx = randperm(n);

not_dense = true(1, d);
not_dense(dense_jokes)=false;

Xtr = J(idx(nTe+1:end), dense_jokes);
Ytr = J(idx(nTe+1:end), not_dense);

Xte = J(idx(1:nTe), dense_jokes);
Yte = J(idx(1:nTe), not_dense);


% Second split ----------------------------------------------------

% For the matrix completion task, we cannot rely on there being a set
% of dense columns. For this alternative split, we randomly order the
% ratings and provide a function that gives training/test matrices
% with a given level of sparsity.

rats = find(~isnan(J(:)));
n_rats = numel(rats);

% randomly permute all of the ratings
rats_rand = rats(randperm(n_rats));

% use "split" fn to get test set. Example:
% M = split(X, rats_rand, 0.5)


%% Mark data as loaded

jester_loaded = 1;
