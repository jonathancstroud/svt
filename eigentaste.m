clc
clear all
close all

%Eigentaste 

if ~exist('jester_loaded')
    load_data;
end

%nxm matrix of raw user ratings

R=Xtr;
no_iter =4; % total no. of iterations

%nxk normalized matrix of user ratings in G


A= Xtr;
n=length(A);
mu_j=ones(n,1)*mean(A);
var_j=ones(n,1)*var(A);

A=(A-mu_j)./sqrt(var_j);

%Pearson Correlation matrix

C=1/(n-1)*A'*A;

% Eigen Decomposition

[E Lambda ]=eig(C);
[lambda index]=sort(diag(Lambda),'descend');
E=E(:,index);
Lambda=Lambda(:,index);

figure (1)
plot(lambda/sum(lambda))
title('Curve of variances')

x=A*(E(:,1:2));

figure (2)
plot(x(:,1),x(:,2),'*')
x2=max(x(:,1));
x1=min(x(:,1));
y2=max(x(:,2));
y1=min(x(:,2));
hold on
rectangle('Position',[x1 y1 (x2-x1) (y2-y1)])

for iter=1:4
    rectangle('Position',[0 0 x2 y2]);
    rectangle('Position',[x1 y1 -x1 -y1]);
    rectangle('Position',[0 y1 x2 -y1]);
    rectangle('Position',[x1 0 -x1 y2]);
end

point_x=[x1 x1 x2 x2];
point_y=[y1 y2 y1 y2];



for iter=1:no_iter
    
    point_x(iter+1,:)=point_x(iter,:)/2;
    point_y(iter+1,:)=point_y(iter,:)/2;
    for i=1:4
        figure (2)
        hold on
        plot([0 2*point_x(iter+1,i)],[point_y(iter+1,i) point_y(iter+1,i)],'k');
        plot([point_x(iter+1,i) point_x(iter+1,i)],[0 2*point_y(iter+1,i)],'k');
    end
end

count=1;
cluster=zeros(round(n/2),500);
for i=1:iter+1
    
    j=no_iter+2-i;
    
    temp=min(j+1,(iter+1));
    x_coord=[(point_x(j:temp,1))' 0 (point_x(temp:-1:j,3))'];
    y_coord=[(point_y(j:temp,1))' 0 (point_y(temp:-1:j,2))'];
    count2=0;
    
    for k=1:length(x_coord)-1
        for l=1:length(y_coord)-1
            if(k==1 || k==(length(x_coord)-1) || l==1 || l== (length(y_coord)-1))
            
            x_coord2=[x_coord(k) x_coord(k+1) x_coord(k+1) x_coord(k) x_coord(k)];
            y_coord2=[y_coord(l) y_coord(l) y_coord(l+1) y_coord(l+1) y_coord(l)];
            
            in_partition=inpolygon(x(:,1),x(:,2),x_coord2,y_coord2);
            n_points(count)=sum(in_partition);
            cluster(1:n_points(count),count)=find(in_partition==1);
            count=count+1;
            end
        end
    end
            
            
end


% Test_data

R=Xte;

%nxk normalized matrix of user ratings in G


A= Xte;
n=length(A);
mu_j=ones(n,1)*mean(A);
var_j=ones(n,1)*var(A);

A=(A-mu_j)./sqrt(var_j);

%Pearson Correlation matrix

C=1/(n-1)*A'*A;

% Eigen Decomposition

[E Lambda ]=eig(C);
[lambda index]=sort(diag(Lambda),'descend');
E=E(:,index);
Lambda=Lambda(:,index);

figure (1)
plot(lambda/sum(lambda))
title('Curve of variances')

x=A*(E(:,1:2));

figure (3)
plot(x(:,1),x(:,2),'*')


% figure (4)
% plot(n_points)
        
count=1;
cluster2=zeros(round(n/2),500);
for i=1:iter+1
    
    j=no_iter+2-i;
    
    temp=min(j+1,(iter+1));
    x_coord=[(point_x(j:temp,1))' 0 (point_x(temp:-1:j,3))'];
    y_coord=[(point_y(j:temp,1))' 0 (point_y(temp:-1:j,2))'];
    count2=0;
    
    for k=1:length(x_coord)-1
        for l=1:length(y_coord)-1
            if(k==1 || k==(length(x_coord)-1) || l==1 || l== (length(y_coord)-1))
            
            x_coord2=[x_coord(k) x_coord(k+1) x_coord(k+1) x_coord(k) x_coord(k)];
            y_coord2=[y_coord(l) y_coord(l) y_coord(l+1) y_coord(l+1) y_coord(l)];
            
            in_partition=inpolygon(x(:,1),x(:,2),x_coord2,y_coord2);
            n_points2(count)=sum(in_partition);
            cluster2(1:n_points2(count),count)=find(in_partition==1);
            count=count+1;
            end
        end
    end
            
            
end

y_mean=zeros(length(n_points),90);
for i=1:length(n_points)
    y_mean(i,:)=nanmean(Ytr(cluster(1:n_points(i),i),:));
end
    
y_test=zeros(n,90);

for i=1:length(n_points2)
   y_test(cluster2(1:n_points2(i),i),:)=ones(n_points2(i),1)*y_mean(i,:);
end

%0.187 reported 

NMAE(Yte, y_test) %0.1921
    
    
    
    
    
    
    
    
    



