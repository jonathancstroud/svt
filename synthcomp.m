% Runs Comparison of Mean, SVT and SMC on Syntetic Matricies of varying
% sizes/ranks/sparsity

function []=synthcomp()
nmat=[10;1e2;1e3;1e4];
rankmat=[.10;.20;.30];
sparsemat=[.30;.50;.70];

results=zeros(size(nat,1)*size(rankmat,1)*size(sparsemat,1),10);

round=1;
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
            [svt,svttime,~,~]=svt(M, Mtrue, 5000, tau, delta, k_0, l, eps);
            svterr=calcError(Mtrue,M,svt);
            
            % SMC
            [smc,smctime]=smc_keshavan(Mest);
            smcerr=calcError(Mtrue,M,smc);
            
            % Save a Bunch of Files
            fname=sprintf('Mtrue%d.csv',round);
            csvwrite(fname,'Mtrue');
            fname=sprintf('M%d.csv',round);
            csvwrite(fname,'M');
            results(round,:)=[round,n,rank,m,meanerr,svterr,smcerr,meantime,svttime,smctime];
            
            round=round+1;
        end
    end
end
csvwrite('results.csv','results');

%create new method of calculating error.
end

function error=calcError(Mtrue,M, Mest)
    test=Mtrue;
    test(~isnan(M))=nan;
    error=nansum(nansum((test-Mest).^2));
end

function [FinalEst,time]=simpleMean(M)
    tic
    nTe = size(M,1);
    mu = nanmean(Ytr);
    FinalEst = repmat(mu, nTe, 1);
    time=toc;
end
