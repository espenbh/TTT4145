%% Clear
clc
clear all

%% Initialization
C=3;        %Number of classes
N=50;       %Number of data points for each class
D=30;       %Number of data points used for training
T=20;       %Number of data points used for testing
M=100;      %Number of iterations for optimization algorithm
alpha=0.01; %Step size for optimization algorithm
N_feature=4;%Number of features

%% Load data and construct problem vectors
%Task 1a
x1all = load('class_1','-ascii');
x2all = load('class_2','-ascii');
x3all = load('class_3','-ascii');

switch N_feature
    case 1
        x_training=[x1all(1:D,4);...
                    x2all(1:D,4);...
                    x3all(1:D,4)];
        
        x_test=    [x1all(D+1:N,4);...
                    x2all(D+1:N,4);...
                    x3all(D+1:N,4)];
    case 2
        x_training=[x1all(1:D,3) x1all(1:D,4);...
                    x2all(1:D,3) x2all(1:D,4);...
                    x3all(1:D,3) x3all(1:D,4)];
        
        x_test=    [x1all(D+1:N,3) x1all(D+1:N,4);...
                    x2all(D+1:N,3) x2all(D+1:N,4);...
                    x3all(D+1:N,3) x3all(D+1:N,4)];
    case 3
       x_training=  [x1all(1:D,4) x1all(1:D,1) x1all(1:D,2);...
                    x2all(1:D,4) x2all(1:D,1) x2all(1:D,2);...
                    x3all(1:D,4) x3all(1:D,1) x3all(1:D,2)];
        
        x_test=    [x1all(D+1:N,4) x1all(D+1:N,1) x1all(D+1:N,2);...
                    x2all(D+1:N,4) x2all(D+1:N,1) x2all(D+1:N,2);...
                    x3all(D+1:N,4) x3all(D+1:N,1) x3all(D+1:N,2)];
    case 4
        x_training=[x1all(1:D,1) x1all(1:D,2) x1all(1:D,3) x1all(1:D,4);...
                    x2all(1:D,1) x2all(1:D,2) x2all(1:D,3) x2all(1:D,4);...
                    x3all(1:D,1) x3all(1:D,2) x3all(1:D,3) x3all(1:D,4)];
                
        x_test=[x1all(D+1:N,1) x1all(D+1:N,2) x1all(D+1:N,3) x1all(D+1:N,4);...
                x2all(D+1:N,1) x2all(D+1:N,2) x2all(D+1:N,3) x2all(D+1:N,4);...
                x3all(D+1:N,1) x3all(D+1:N,2) x3all(D+1:N,3) x3all(D+1:N,4)];
        
end

%% Training
%Problem 1.1.b
%MSE based training of a linear classifier

%Initialization
g_k=zeros(C,1);
g_k(1,1)=1;
t_k=zeros(C,1);
W=zeros(C, N_feature);

for m=1:100 %For all optimization iterations
    grad_W_MSE=0;
    for d=1:D
        x_k=x_training(d,:);
        g_k=sigmoid(W*x_k');
        t_k=zeros(C,1);
        t_k(round(x_k(N_feature)+1),:)=1;
        grad_W_MSE=grad_W_MSE+((g_k-t_k).*g_k.*(1-g_k))*x_k;
    end
    W=W-alpha*grad_W_MSE;
end


%% Processing
%Problem 1.1.c
%Finding the confusion matrix of the above training
confuse_matrix=zeros(3,3);
for c=1:C
    for t=1:T
        prediction=max(round(W*x_test(T*(c-1)+t,:)'));
        confuse_matrix(c, prediction)=confuse_matrix(c, prediction-1)+1;
    end
end

%% Plotting
scatter3(x1all(:,1), x1all(:,2), x1all(:,3), 'r');
hold on
scatter3(x2all(:,1), x2all(:,2), x2all(:,3), 'b');
hold on
scatter3(x3all(:,1), x3all(:,2), x3all(:,3), 'g');

xlabel('Sepal length');
ylabel('Sepal width');
zlabel('Petal length');

