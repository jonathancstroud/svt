%% Main
function []=main()
tic
clear all;

% Create Low Rank Matrix to Test
% use a small matrix to test or the jester data
rng(10);
Mtrue=zeros(100);
for i=1:14
    Mtrue=Mtrue+randn(100,1)*randn(1,100);
end
M=Mtrue;
M(rand(100,100)<.2)=0;
clear i ans;


% User Jester Matrix to Test
% if ~exist('jester_loaded')
%     load_data;
% end
% M = Ytr;
% M(isnan(M))=0;

% Spectral Matrix Completion %%%

% Set Variables
m=size(M,1);
n=size(M,2);
tol=1e-6;
niter=5000;
E = spones(M); %Indicator matrix of where M is nonzero
r = guessRank(M) ;
Mest=M;

% Trim Matrix
coldeg=sum(Mest~=0)>(2*mean(sum(E)));
rowdeg=sum(Mest~=0,2)>(2*mean(sum(E,2)));
Mest(:,coldeg)=0; 
Mest(rowdeg,:)=0; 
clear rowdeg coldeg;

% Cleaning
[X S Y]=svds(Mest,r);
X=X*sqrt(m); Y=Y*sqrt(n);
S = optS(X,Y,M,E);
dist(1) = norm( (M - X*S*Y').*E ,'fro')/sqrt(nnz(E) )  ;
fprintf(1,'0\t\t%e\n',dist(1) ) ;

for i = 1:niter

    %this is outlined in Remark 6.2 under Gradient Descent.
% Compute the Gradient 
	[W Z] = gradF(X,Y,S,M,E);

% Line search for the optimum jump length	
	alpha = optalpha(X,W,Y,Z,S,M,E) ;
	X = X + alpha*W;Y = Y + alpha*Z;S = optS(X,Y,M,E) ;
	
% Compute the distortion	
	dist(i+1) = norm( (M - X*S*Y').*E,'fro' )/sqrt(nnz(spones(M)));
	fprintf(1,'%d\t\t%e\n',i,dist(i+1) ) ;
	if( dist(i+1) < tol )
		break ;
	end
end
S = S ;%/rescal_param ;
disp('Jeeheh')
NMAE(Mtrue,X*S*Y')
toc
end
%% Opt S
function S =optS(X,Y,M,E)
[m r] = size(X);
C = X' * ( M ) * Y ; C = C(:) ;
for i = 1:r
        for j = 1:r
                ind = (j-1)*r + i ;
                temp = X' * (  (X(:,i) * Y(:,j)').*E ) * Y ;
                A(:,ind) = temp(:) ;
        end
end
S = A\C ;
S = reshape(S,r,r) ;
end
    %A*X=B where B is the true matrix and A is the estimated matrix
    %We are trying to estimate S (the eigenvalues) which best converts
    %matrix A.
%% Gradient F
function [W Z] = gradF(X,Y,S,M,E)
[m r] = size(X);
[n r] = size(Y);

XS = X*S ;
YS = Y*S' ;
XSY = XS*Y' ;

Qx = X'* ( (M - XSY).*E)*YS /m;
Qy = Y'* ( (M - XSY).*E)'*XS /n;

W = ( (XSY - M) .*E)*YS + X*Qx;
Z = ( (XSY - M).*E )'*XS + Y*Qy;
end
    %6.2 Gradient and Incoherance
    %6.3 Algorithm (with rho=0)
%% Opt Alpha
function out = optalpha(X,W,Y,Z,S,M,E)
norm2WZ = norm(W,'fro')^2 + norm(Z,'fro')^2;
f(1) = F_alpha(X,Y,S,M,E) ;

alpha = -1e-1 ;
for i = 1:20
        f(i+1) = F_alpha(X+alpha*W,Y+alpha*Z,S,M,E) ;

        if( f(i+1) - f(1) <= .5*(alpha)*norm2WZ )
            out = alpha ;
            return;
        end
        alpha = alpha/2 ;
end
out = alpha ;
end
  %in particular Remark 6.2, Gradient Descent, step 5 where gamma =
  %.5*(t)*norm2WZ.
%% Distance 
function out = F_alpha(X,Y,S,M,E)
[m r] = size(X) ;
out = sum( sum( ( (X*S*Y' - M).*E).^2 ) )/2 ;
end
    %in 6.1, the distance function d(x1,x2) is described.
%% Rank
function r = guessRank(M);
	[m n] = size(M);
	epsilon = nnz(M)/sqrt(m*n);
    S0 = svds(M,100) ;

    S1=S0(1:end-1)-S0(2:end); %matrix of differences in SV (s1-s2, s2-s3, etc)
    S1_ = S1./mean(S1(end-10:end)); %scale by mean of last 10 of first 100 SVs
    r1=0;
    lam=0.05;
    while(r1<=0) %condition so that rank !=1
        for idx=1:length(S1_)
            cost(idx) = lam*max(S1_(idx:end)) + idx;
        end
        [v2 i2] = min(cost);
        r1 = max(i2-1);
        lam=lam+0.05;
    end

	clear cost;
    for idx=1:length(S0)-1
        cost(idx) = (S0(idx+1)+sqrt(idx*epsilon)*S0(1)/epsilon  )/S0(idx);
    end
    [v2 i2] = min(cost);
    r2 = max(i2);

	r = max([r1 r2]);
end
    
