%% Clear
clc
clear all
close all

%% Parameters
C=3;        %Number of classes
N=50;       %Number of data points for each class
D=30;       %Number of data points used for training
T=20;       %Number of data points used for testing
M=1000;     %Number of iterations for optimization algorithm
alpha=0.007;%Step size for optimization algorithm
N_feature=1;%Number of features
nbins=20;   %Number of bins in histogram
training_first=1;

%% Load data and construct problem vectors
%Task 1a
x1all = load('class_1','-ascii');
x2all = load('class_2','-ascii');
x3all = load('class_3','-ascii');

switch training_first
    case 1
        switch N_feature
            case 1 % Class two and three are third most difficult to seperate from each other
                   % through feature 4
                % Algorithm can't handle one-dimensional case.
                % Make vectors two-dimentional, by adding a feature with
                % only one value. Test and training should still be valid.
                x_training=[x1all(1:D,3) ones(D,1);... 
                            x2all(1:D,3) ones(D,1);...  
                            x3all(1:D,3) ones(D,1)];

                x_test=    [x1all(D+1:N,3) ones(T,1);...
                            x2all(D+1:N,3) ones(T,1);...
                            x3all(D+1:N,3) ones(T,1)];
                N_feature=N_feature+1;
            case 2 % Class two and three are second most difficult to seperate from each other
                   % through feature 1
                x_training=[x1all(1:D,3) x1all(1:D,4);...
                            x2all(1:D,3) x2all(1:D,4);...
                            x3all(1:D,3) x3all(1:D,4)];

                x_test=    [x1all(D+1:N,3) x1all(D+1:N,4);...
                            x2all(D+1:N,3) x2all(D+1:N,4);...
                            x3all(D+1:N,3) x3all(D+1:N,4)];
            case 3 % Class two and three are most difficult to seperate from each other
                   % through feature 2
               x_training=  [x1all(1:D,1) x1all(1:D,3) x1all(1:D,4);...
                             x2all(1:D,1) x2all(1:D,3) x2all(1:D,4);...
                             x3all(1:D,1) x3all(1:D,3) x3all(1:D,4)];

                x_test=    [x1all(D+1:N,1) x1all(D+1:N,3) x1all(D+1:N,4);...
                            x2all(D+1:N,1) x2all(D+1:N,3) x2all(D+1:N,4);...
                            x3all(D+1:N,1) x3all(D+1:N,3) x3all(D+1:N,4)];
            case 4
                x_training=[x1all(1:D,1) x1all(1:D,2) x1all(1:D,3) x1all(1:D,4);...
                            x2all(1:D,1) x2all(1:D,2) x2all(1:D,3) x2all(1:D,4);...
                            x3all(1:D,1) x3all(1:D,2) x3all(1:D,3) x3all(1:D,4)];

                x_test=[x1all(D+1:N,1) x1all(D+1:N,2) x1all(D+1:N,3) x1all(D+1:N,4);...
                        x2all(D+1:N,1) x2all(D+1:N,2) x2all(D+1:N,3) x2all(D+1:N,4);...
                        x3all(D+1:N,1) x3all(D+1:N,2) x3all(D+1:N,3) x3all(D+1:N,4)];

        end
    case 0
        switch N_feature
            case 1 % Class two and three are third most difficult to seperate from each other
                   % through feature 4
                % Algorithm can't handle one-dimentional case.
                % Make vectors two-dimentional, by adding a feature with
                % only one value. Test and training should still be valid.
                x_training=[x1all(T+1:N,3) ones(D,1);...
                            x2all(T+1:N,3) ones(D,1);...
                            x3all(T+1:N,3) ones(D,1)];

                x_test=    [x1all(1:T,3) ones(T,1);...
                            x2all(1:T,3) ones(T,1);...
                            x3all(1:T,3) ones(T,1)];
                N_feature=N_feature+1;
            case 2 % Class two and three are second most difficult to seperate from each other
                   % through feature 1
                x_training=[x1all(T+1:N,3) x1all(T+1:N,4);...
                            x2all(T+1:N,3) x2all(T+1:N,4);...
                            x3all(T+1:N,3) x3all(T+1:N,4)];

                x_test=    [x1all(1:T,3) x1all(1:T,4);...
                            x2all(1:T,3) x2all(1:T,4);...
                            x3all(1:T,3) x3all(1:T,4)];
            case 3 % Class two and three are most difficult to seperate from each other
                   % through feature 2
               x_training=  [x1all(T+1:N,1) x1all(T+1:N,3) x1all(T+1:N,4);...
                             x2all(T+1:N,1) x2all(T+1:N,3) x2all(T+1:N,4);...
                             x3all(T+1:N,1) x3all(T+1:N,3) x3all(T+1:N,4)];

                x_test=    [x1all(1:T,1) x1all(1:T,3) x1all(1:T,4);...
                            x2all(1:T,1) x2all(1:T,3) x2all(1:T,4);...
                            x3all(1:T,1) x3all(1:T,3) x3all(1:T,4)];
            case 4
                x_training=[x1all(T+1:N,1) x1all(T+1:N,2) x1all(T+1:N,3) x1all(T+1:N,4);...
                            x2all(T+1:N,1) x2all(T+1:N,2) x2all(T+1:N,3) x2all(T+1:N,4);...
                            x3all(T+1:N,1) x3all(T+1:N,2) x3all(T+1:N,3) x3all(T+1:N,4)];

                x_test=[x1all(1:T,1) x1all(1:T,2) x1all(1:T,3) x1all(1:T,4);...
                        x2all(1:T,1) x2all(1:T,2) x2all(1:T,3) x2all(1:T,4);...
                        x3all(1:T,1) x3all(1:T,2) x3all(1:T,3) x3all(1:T,4)];

        end
end

%% Training
%Problem 1.1.b
%MSE based training of a linear classifier

%Initialization
g_k=[1;zeros(C-1,1)];
t_k=zeros(C,1);
W=zeros(C, N_feature);

for m=1:M               %For all optimization iterations
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
%Finding the confusion matrices of the above training

confuse_matrix_test_set=zeros(3,3);
for c=1:C
    for t=1:T
        x_k=x_test(T*(c-1)+t,:);                                                                        %Access current row in test set
        [predictionmax, argpredictionmax]=max(sigmoid(W*x_k'));                                         %Evaluate which class W believes x_k belongs to
        confuse_matrix_test_set(c, argpredictionmax)=confuse_matrix_test_set(c, argpredictionmax)+1;    %Increase the approperiate elemnt in the confusion matrix
    end
end

confuse_matrix_training_set=zeros(3,3);
for c=1:C
    for d=1:D
        x_k=x_training(D*(c-1)+d,:);                                                                        %Access current row in test set
        [predictionmax, argpredictionmax]=max(sigmoid(W*x_k'));                                             %Evaluate which class W believes x_k belongs to
        confuse_matrix_training_set(c, argpredictionmax)=confuse_matrix_training_set(c, argpredictionmax)+1;%Increase the approperiate elemnt in the confusion matrix
    end
end

%Find the error rates
correct_test_set=0;
error_test_set=0;
for i=1:C
    for j=1:C
        if i==j
            correct_test_set=correct_test_set+confuse_matrix_test_set(i,j);
        else
            error_test_set=error_test_set+confuse_matrix_test_set(i,j);
        end
    end
end
error_rate_test=error_test_set/(error_test_set+correct_test_set);

correct_training_set=0;
error_training_set=0;
for i=1:C
    for j=1:C
        if i==j
            correct_training_set=correct_training_set+confuse_matrix_training_set(i,j);
        else
            error_training_set=error_training_set+confuse_matrix_training_set(i,j);
        end
    end
end
error_rate_training=error_training_set/(error_training_set+correct_training_set);

%% Histograms
%Problem 1.2.a

% lb=[4.2, 1.9, 1, 0];
% ub=[8, 4.5, 7, 2.6];
% figure
% for n=1:N_feature
%     format=lb(n): 1/nbins:ub(n);
%     
%     subplot(N_feature, C, C*(n-1)+1)
%     histogram(x1all(:,n),format)
%     xlabel('Class 1')
%     ylabel(['Feature ' num2str(n)]);
%     
%     subplot(N_feature, C, C*(n-1)+2)
%     histogram(x2all(:,n),format)
%     xlabel('Class 2')
%     ylabel(['Feature ' num2str(n)]);
%     
%     subplot(N_feature, C, C*(n-1)+3)
%     histogram(x3all(:,n),format)
%     xlabel('Class 3')
%     ylabel(['Feature ' num2str(n)]);
% end


%% Plotting
% % 3D scatter
% scatter3(x1all(:,1), x1all(:,3), x1all(:,4), 'r');
% hold on
% scatter3(x2all(:,1), x2all(:,3), x2all(:,4), 'b');
% hold on
% scatter3(x3all(:,1), x3all(:,3), x3all(:,4), 'g');

% xlabel('Sepal length');
% ylabel('Petal length');
% zlabel('Petal width');
% legend('Iris Setosa', 'Iris Versicolor', 'Iris Virginica');

% 1D scatter
% scatter(x_training(1:D,1), x_training(1:D,2))
% hold on
% scatter(x_training(D+1:2*D,1), x_training(D+1:2*D,2))
% hold on
% scatter(x_training(2*D+1:3*D,1), x_training(2*D+1:3*D,2))
% xlabel('Petal length');
% legend('Iris Setosa', 'Iris Versicolor', 'Iris Virginica');
