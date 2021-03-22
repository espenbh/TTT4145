%% Initialization
%train_test_sg5;

C=3;        %Number of classes
N=50;       %Number of data points for each class
D=30;       %Number of data points used for training
T=20;       %Number of data points used for testing
M=100;      %Number of iterations for optimization algorithm
alpha=0.01; %Step size for optimization algorithm
N_feature=2;%Number of features

%% Load data
x1all = load('class_1','-ascii');
x2all = load('class_2','-ascii');
x3all = load('class_3','-ascii');

% x1= [x1all(:,4) x1all(:,1) x1all(:,2)];
% x2= [x2all(:,4) x2all(:,1) x2all(:,2)];
% x3= [x3all(:,4) x3all(:,1) x3all(:,2)];

x=[x1all(1:D,3) x1all(1:D,4);...
   x2all(1:D,3) x2all(1:D,4);...
   x3all(1:D,3) x3all(1:D,4)];

% x1= [x1all(:,4)];
% x2= [x2all(:,4)];
% x3= [x3all(:,4)];

%% Training
%Implementing MSE linear classifier.
%W 
%Initialization
W=zeros(C, D);
W0=zeros(C, D);

%Implementing gradient descent
for m=2:M                       %For all steps
    MSE_gradient=0;             %Initialize gradient in current step
    for k=1:D*C                 %For all training data points
        g_k=sigmoid(x(k), W, W0);
        t_k=zeros(3,30);
        MSE_gradient=MSE_gradient+((g_k-t_k).*g_k.*(1-g_k))*x(k)';
    end
    W(m)=W(m-1)-alpha*MSE_gradient;
end

%% Processing

%% Plotting
