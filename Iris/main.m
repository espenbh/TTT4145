%% Clear
clc
clear all

%% Parameters
C=3;        %Number of classes
N=50;       %Number of data points for each class
D=30;       %Number of data points used for training
T=20;       %Number of data points used for testing
M=1000;     %Number of iterations for optimization algorithm
alpha=0.007;%Step size for optimization algorithm
N_feature=4;%Number of features

%% Load data and construct problem vectors
%Task 1a
x1all = load('class_1','-ascii');
x2all = load('class_2','-ascii');
x3all = load('class_3','-ascii');

switch N_feature
    case 1
        x_training=[x1all(1:D,1);...
                    x2all(1:D,1);...
                    x3all(1:D,1)];
        
        x_test=    [x1all(D+1:N,1);...
                    x2all(D+1:N,1);...
                    x3all(D+1:N,1)];
    case 2
        x_training=[x1all(1:D,1) x1all(1:D,2);...
                    x2all(1:D,1) x2all(1:D,2);...
                    x3all(1:D,1) x3all(1:D,2)];
        
        x_test=    [x1all(D+1:N,1) x1all(D+1:N,2);...
                    x2all(D+1:N,1) x2all(D+1:N,2);...
                    x3all(D+1:N,1) x3all(D+1:N,2)];
    case 3
       x_training=  [x1all(1:D,1) x1all(1:D,2) x1all(1:D,3);...
                     x2all(1:D,1) x2all(1:D,2) x2all(1:D,3);...
                     x3all(1:D,1) x3all(1:D,2) x3all(1:D,3)];
        
        x_test=    [x1all(D+1:N,1) x1all(D+1:N,2) x1all(D+1:N,3);...
                    x2all(D+1:N,1) x2all(D+1:N,2) x2all(D+1:N,3);...
                    x3all(D+1:N,1) x3all(D+1:N,2) x3all(D+1:N,3)];
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
g_k=[1;zeros(C-1,1)];
t_k=zeros(C,1);
W=zeros(C, N_feature);

for m=1:100             %For all optimization iterations
    grad_W_MSE=0;       %Initialize gradient to zero
    for c=1:C           %For all datapoints
        for d=1:D
            x_k=x_training(D*(c-1)+d,:);    %Access current row in data set
            g_k=sigmoid(W*x_k');            %Choose which class W believes x_k belongs to 
            t_k=zeros(C,1);                 %Choose which class x_k actually belongs to
            t_k(c)=1;                       
            grad_W_MSE=grad_W_MSE+...       %How should W change to make g_k and t_k equal
            ((g_k-t_k).*g_k.*(1-g_k))*x_k;   
        end
    end
    W=W-alpha*grad_W_MSE;                   %Apply the gradient to W, so it moves closer to the right values
end


%% Processing and evaluation
%Problem 1.1.c
%Finding the confusion matrix of the above training

confuse_matrix=zeros(3,3);
for c=1:C
    for t=1:T
        x_k=x_test(T*(c-1)+t,:);                                                    %Access current row in test set
        [predictionmax, argpredictionmax]=max(sigmoid(W*x_k'));                     %Evaluate which class W believes x_k belongs to
        confuse_matrix(c, argpredictionmax)=confuse_matrix(c, argpredictionmax)+1;  %Increase the approperiate elemnt in the confusion matrix
    end
end

%Find the error rate
correct=0;
error=0;
for i=1:C
    for j=1:C
        if i==j
            correct=correct+confuse_matrix(i,j);
        else
            error=error+confuse_matrix(i,j);
        end
    end
end

%% Histograms
%Problem 1.2.a
figure
for n=1:N_feature
    subplot(N_feature, C, C*(n-1)+1)
    histogram(x1all(:,n),10)
    xlabel('Class 1')
    ylabel(['Feature ' num2str(n)]);
    
    subplot(N_feature, C, C*(n-1)+2)
    histogram(x2all(:,n),10)
    xlabel('Class 2')
    ylabel(['Feature ' num2str(n)]);
    
    subplot(N_feature, C, C*(n-1)+3)
    histogram(x3all(:,n),10)
    xlabel('Class 3')
    ylabel(['Feature ' num2str(n)]);
end


%% Plotting
% scatter3(x1all(:,1), x1all(:,2), x1all(:,3), 'r');
% hold on
% scatter3(x2all(:,1), x2all(:,2), x2all(:,3), 'b');
% hold on
% scatter3(x3all(:,1), x3all(:,2), x3all(:,3), 'g');
% 
% xlabel('Sepal length');
% ylabel('Sepal width');
% zlabel('Petal length');

