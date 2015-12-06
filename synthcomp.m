% Runs Comparison of Mean, SVT and SMC on Syntetic Matricies of varying
% sizes/ranks/sparsity

function []=synthcomp()
nmat=[1e2;1e3;1e4];
rankmat=[.10;.20;.30];
sparsemat=[.30;.50;.70];

results=zeros(size(nmat,1)*size(rankmat,1)*size(sparsemat,1),10);

count=1;
for i=1:size(nmat,1)
    n=nmat(i);
    for j=1:size(rankmat,1)
        rank=round(n*rankmat(j));
        for k=1:size(sparsemat,1)
            
            % Create Synthetic Matrix
            m=round((1-sparsemat(k))*n*n);
            [Mtrue,M]=synthetic(n,rank,m);
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
            csvwrite(fname,'Mtrue');
            fname=sprintf('M%d.csv',count);
            csvwrite(fname,'M');
            results(count,:)=[count,n,rank,m,meanerr,svterr,smcerr,meantime,svttime,smctime];
            count=count+1;
        end
    end
end
csvwrite('results.csv','results');
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
