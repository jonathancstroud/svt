% Runs Comparison of Mean, SVT and SMC on Syntetic Matricies of varying
% sizes/ranks/sparsity

%%%%%% this uses version of lmsvd that commented out lines 49-51

function []=synthcomp()
nmat=[1e3;5e3;1e4;5e4;1e5];
rankmat=[10;50;100];
sparsemat=[.30;.50;.70];

results=zeros(size(nmat,1)*size(rankmat,1)*size(sparsemat,1),10);

count=1;
for i=1:size(nmat,1)
    n=nmat(i);
    for j=1:size(rankmat,1)
        rank=rankmat(j);
        % Create Synthetic Matrix Mtrue
        Mtrue=synthetic2(n,rank);
        
        for k=1:size(sparsemat,1)          
            % Create Synthetic Matrix M & Mest
            m=round((1-sparsemat(k))*n*n);
            idx = randperm(n*n);
            M = NaN(n);
            M(idx(1:m)) = Mtrue(idx(1:m));            
            Mest=M;
            Mest(isnan(Mest))=0;
            
            % Mean
            [mean,meantime]=simpleMean(Mest);
            meanerr=calcError(Mtrue,M,mean);
            
            % SVT
            tau=5*n;
            delta=1.2*n*n/sum(~isnan(M(:)));
            k_0=ceil(tau/(delta*norm(M(~isnan(M(:))))));
            l=5;
            eps=10^-4;
            [svtest,svttime,~,~]=svt(M, Mtrue, 5000, tau, delta, k_0, l, eps);
            svterr=calcError(Mtrue,M,svtest);
            
            % SMC
            [smc,smctime]=smc_keshavan(Mest);
            smcerr=calcError(Mtrue,M,smc);
            
            % Save a Bunch of Files
            fname=sprintf('Mtrue%d.csv',count);
            csvwrite(fname,Mtrue);
            fname=sprintf('M%d.csv',count);
            csvwrite(fname,M);
            results(count,:)=[count,n,rank,m,meanerr,svterr,smcerr,meantime,svttime,smctime];
            fname=sprintf('results%d.csv',count);
            csvwrite(fname,results);
            count=count+1;
        end
    end
end
end

function error=calcError(Mtrue,M, Mest)
    test=Mtrue;
    test(~isnan(M))=nan;
    error=nansum(nansum((test-Mest).^2));
end

function [FinalEst,time]=simpleMean(M)
    tic
    nTe = size(M,1);
    mu = nanmean(M);
    FinalEst = repmat(mu, nTe, 1);
    time=toc;
end

function M= synthetic2(n, rank)
% Generate synthetic data matrix as in SVT paper
% 
% Inputs:
%    n: scalar - size of unknown matrix (square)
%    rank: scalar - rank of unknown matrix
%    m: scalar - number of elements to sample
rank = min(rank, n);
U = randn(n, rank)*2;
V = randn(n, rank)*2;
M = U*V';
end
