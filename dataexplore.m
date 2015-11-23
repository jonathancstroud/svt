
if ~exist('jester_loaded')
    load_data;
end

% Check ratings distribution from each

figure(1); clf;

subplot(1, 3, 1);
hist(J1(~isnan(J1(:))), 10);
title('Jester-1');
fprintf('Split 1 sparsity: %f\n', mean(isnan(J1(:))));

subplot(1, 3, 2);
hist(J2(~isnan(J2(:))), 10);
title('Jester-2');
fprintf('Split 2 sparsity: %f\n', mean(isnan(J2(:))));

subplot(1, 3, 3);
hist(J3(~isnan(J3(:))), 10);
title('Jester-3');
fprintf('Split 3 sparsity: %f\n', mean(isnan(J3(:))));

% Check mean rating distribution for each joke
J = [J1; J2; J3];

Jcount1 = mean(~isnan(J1));
Jcount2 = mean(~isnan(J2));
Jcount3 = mean(~isnan(J3));

figure(2);
plot(Jcount1); hold on;
plot(Jcount2); hold on;
plot(Jcount3);



Jmean = nanmean(J);
[JmeanSorted, idx] = sort(Jmean);

figure(3);
hist(JmeanSorted, 10);




