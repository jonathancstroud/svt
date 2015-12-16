function [] = visualize_jokes()

    load_data;
    
    mu = nanmean(J);
    sigma = nanstd(J);
    Jc = bsxfun(@minus, J, mu);
    Jc = bsxfun(@times, Jc, 1./sigma);
    save('joke_stats.mat', 'mu', 'sigma');
    
    keyboard;
    Jc = Jc';
    [n, d] = size(Jc);
    m = sum(~isnan(Jc(:)));
        
    max_iter = 10;
    tau = 5000;
    delta = 2;
    l = 5;
    eps = 1*10^-3;
    k_0 = 5;
    
    [Jhat, U, S, V, ~, ~, ~] = ...
        svt(Jc, Jc, max_iter, tau, delta, k_0, l, eps);

    load('visualize_jokes.mat');
    load('joke_stats.mat');
    
    % plot the jokes in 2D
    figure(1); clf;
    for i = 1:100
        text(U(i, 1), U(i, 2), sprintf('%d', i)); hold on;
    end
    xlim([0.04, 0.15]);
    ylim([-0.3, 0.25]);
    axis off; hold off;
    drawnow;
    
    % 3D - hard to interpret
    figure(2); clf;
    for i = 1:100
        text(U(i, 1), U(i, 2), U(i, 3), sprintf('%d', i)); hold on;
    end
    xlim([0.04, 0.15]);
    ylim([-0.3, 0.25]);
    zlim([-0.35, 0.44]);
    drawnow;
    
    % Eventually try some other visualizations
