%% README
% We have 4 formants, which acts as our features.
% For each formant, 4 different modes can be used
% Fx20: vowel is held at 20% the original length
% Fx50: vowel is held at 50% the original length
% Fx80: vowel is held at 50% the original length
% Fxs: vowel is held at 100% the original length
%
% We have 12 classes, which is our vowels.
% Each wovel has 139 samples.
% These samples are distributed over 45 males, 48 females,
% 27 boys and 19 girls.

%% Clear
clc
clear all
close all

%% Import data
% Read vowdata_nohead.dat into [files, dur, F0s...] 
% formated by %s%4.1f%4.1f%4.1...
% "files" are interpreted by the rule below

[files,dur,F0s,F1s,F2s,F3s,F4s,F120,F220,F320,F150,F250,F350,F180,F280,F380] =  ...
textread('vowdata_nohead.dat',                                                  ...
'%s%4.1f%4.1f%4.1f%4.1f%4.1f%4.1f%4.1f%4.1f%4.1f%4.1f%4.1f%4.1f%4.1f%4.1f%4.1f');

%Forms character arrays to order the data
vowel = str2mat('ae','ah','aw','eh','ei','er','ih','iy','oa','oo','uh','uw');
vowel_names = ['ae';'ah';'aw';'eh';'ei';'er';'ih';'iy';'oa';'oo';'uh';'uw'];
talker_group = str2mat('m','w','b','g');

filenames=char(files);          % convert cell array to character matrix
[nfiles,~]=size(filenames);     % Extract file size parameter

for ifile=1:nfiles  %For all data points, put their data into the right spot in the character arrays
    vowel_code(ifile) = strmatch(filenames(ifile,4:5),vowel);               %Match current datapoint with wovel number, store result in array
    talker_group_code(ifile) = strmatch(filenames(ifile,1),talker_group);   %Match current datapoint with talker group, store result in array
    talker_number(ifile) = str2num(filenames(ifile,2:3));                   %Match current datapoint with talker number, store result in array
end

%% Parameters
frequencies=[F0s,F1s,F2s,F3s,F4s,F120,F220,F320,F150,F250,F350,F180,F280,F380];
frequency_names=['F0s ';'F1s ';'F2s ';'F3s ';'F4s ';'F120';'F220';'F320';'F150';'F250';'F350';'F180';'F280';'F380'];

N_bins=20;              % Bins for histograms

N_talkers=139;          % Number of talkers
N_vowels=length(vowel); % Number of wovels

feature_mode=100;       % Decide data registration mode
N_features= 3;          % Number of features used for classification

N_training= 70;         % Number of data points per class used for training
N_test=     N_talkers-N_training;   % Number of data points per class used for testing

N = N_talkers*N_vowels; % Total number of data points, if preprocessing data, this will be changed

% Define colors for plotting
colors_pure_RGB=['y';'m';'c';'r';'g';'b';'k'];
colors_mixed_RGB=[[0 0.4470 0.7410];[0.8500 0.3250 0.0980];[0.9290 0.6940 0.1250];[0.4940 0.1840 0.5560];[0.4660 0.6740 0.1880];[0.3010 0.7450 0.9330];[0.6350 0.0780 0.1840]];
size_color_array=size(colors_pure_RGB,1);
%% Choose features
%Extract features based on feature mode

features=       zeros(N_vowels*N_talkers, N_features);
feature_names=  zeros(1,N_features);

switch feature_mode
    case 20     
        features=       [F120 F220 F320];
        feature_names=  ['F120';'F220';'F320'];
    case 50     
        features=       [F150 F250 F350];
        feature_names=  ['F150';'F250';'F350'];
    case 80     
        features=       [F180 F280 F380];
        feature_names=  ['F180';'F280';'F380'];
    case 100    
        features=       [F1s F2s F3s];
        feature_names=  ['F1s';'F2s';'F3s'];
end

%% Preprocess data
% Bad or corrupted data will be removed from both trainingset and testset.
% The number of training datapoints are kept constant.
% These modifications will alter the data set.
% The results acquired from preprocessed data should not be trusted
% completely.

% Remove corrupted data (data with zeros)
% data_indeks=1;
% while true
%     sum(features(data_indeks, :)==0);
%     if sum(features(data_indeks, :)==0)~=0
%         features(data_indeks,:);
%         features(data_indeks,:) = [];
%         vowel_code(data_indeks) = [];
%         continue
%     end
%     if size(features,1) > data_indeks
%         data_indeks=data_indeks+1;
%     else
%         break
%     end
% end


% Remove outliers in dataset (NB: This will disturb the testset, and lead to
% results that are seemingly better performing than they actually are)
% for n_vowels=1:N_vowels
%     main_set_indeks=find(vowel_code==n_vowels);
%     current_data=features(main_set_indeks,:);
%     temp_mean=mean(current_data);
%     max_dev=std(current_data)*2;
%     
%     ind_delete=[];
%     for current_set_indeks=1:size(current_data,1)
%         for n_features=1:N_features
%             if features(main_set_indeks(current_set_indeks), n_features)>temp_mean(1,n_features)+max_dev(1,n_features)
%                 ind_delete=union(ind_delete, main_set_indeks(current_set_indeks));
%             elseif features(main_set_indeks(current_set_indeks), n_features)<temp_mean(1,n_features)-max_dev(1,n_features)
%                 ind_delete=union(ind_delete, main_set_indeks(current_set_indeks));
%             end
%         end
%     end
%     features(ind_delete,:)=[];
%     vowel_code(ind_delete)=[];
% end

% Update size of dataset
% N=size(features,1);
 
% Shuffle datapoints, to avoid training on men/women, and testing on
% boys/girls
% new_index=randperm(N);
% features=features(new_index,:);
% vowel_code=vowel_code(new_index);


%% Separate training and test data
% Split data-array in two, one for testing, one for training
% Also make vowel code arrays to extract the right vowels

training_features=zeros(N_training, N_features);
training_vowel_code=zeros(1,N_training);

fill_cursor_test=0;
for n_vowels=1:N_vowels
    main_set_index=find(vowel_code==n_vowels);
    size_vowel_set=size(main_set_index,2);
    size_test_set=size_vowel_set-N_training;
    
    training_features((n_vowels-1)*N_training+1:        ...
    n_vowels*N_training, :) =                           ...
    features(main_set_index(1:N_training),:);

    test_features(fill_cursor_test+1:                   ...
    fill_cursor_test+size_test_set, :) =                ...
    features(main_set_index(N_training+1:size_vowel_set),:);

    training_vowel_code(1,(n_vowels-1)*N_training+1:    ...
    n_vowels*N_training)=                               ...
    ones(1,N_training)*n_vowels;

    test_vowel_code(1, fill_cursor_test+1:              ...
    fill_cursor_test+size_test_set) =                   ...
    ones(1,size_test_set)*n_vowels;
    
    fill_cursor_test=fill_cursor_test+size_test_set;
end

%% Histogram
% Displaying all classes and chosen number of features (N_features)

% figure(1)
% for n_features=1:N_features            
%     for nw=1:N_vowels                  
%         subplot(N_features,N_vowels,N_vowels*(n_features-1)+nw);
%         current_feature=features(:,n_features);
%         hist(current_feature(find(vowel_code==nw)),N_bins);
%         xlabel(vowel_names(nw, :));
%         ylabel(feature_names(n_features, :));
%     end
% end

%% Calculate mean and covarianance 
% Using training data set

means=zeros(N_vowels, N_features);
covariances=zeros(N_vowels, N_features, N_features);
covariances_diag=zeros(N_vowels, N_features, N_features);

% Mean
for n_features=1:N_features
    for n_vowels=1:N_vowels
        current_vowel_indeks=find(training_vowel_code==n_vowels);
        current_data=training_features(current_vowel_indeks,n_features);
        means(n_vowels, n_features) = mean(current_data);
%       disp(['Mean ', feature_names(n_features, :), ' for ', vowel_names(n_vowels, :), ' : ',num2str(means(n_vowels, n_features))]);
    end
end

% Covariance
for n_vowels=1:N_vowels
    current_vowel_indeks=find(training_vowel_code==n_vowels);
    current_data=training_features(current_vowel_indeks, :);
    covariances(n_vowels, :, :) = cov(current_data);
%   disp(['Covariance for ', vowel_names(n_vowels, :)]) % Displaying covariance
%   disp(cov(current_data))
end

% Diagonal covariance
for n_vowels=1:N_vowels
    current_vowel_indeks=find(training_vowel_code==n_vowels);
    current_data=training_features(current_vowel_indeks, :);
    current_cov=cov(current_data);
    for n_features=1:N_features
        covariances_diag(n_vowels, n_features, n_features) = current_cov(n_features,n_features);
    end
end

% Comment/uncomment this line to change covariance matrix type
% covariances=covariances_diag;

%% Calculate single Gaussian with equation (training)
% Caluclate single Gaussian distribution
% Calculating for all classes

x=sym('x', [N_features 1]);
single_gaussian=sym('x',[N_vowels 1]);

for n_vowels=1:N_vowels
    sigma=reshape(covariances(n_vowels, :, :), [N_features, N_features]);
    mu=means(n_vowels, :)';
    single_gaussian(n_vowels)= 1/sqrt((2*pi)^N_features*det(sigma))*exp(-1/2*((x-mu)'/sigma*(x-mu)));
end

%% Calculating GMM with fitgmdist (training)

options = statset('MaxIter',1000,'TolFun',1e-6);
GMMs=cell(N_vowels, 1);
for n_vowels=1:N_vowels
    current_data = training_features(find(training_vowel_code==n_vowels),:);
    GMMs{n_vowels}=fitgmdist(   current_data, 3,                ...
                                'RegularizationValue',0.0001,   ...
                                'Options',options,              ...
                                'CovarianceType','full',        ... % Change covariance matrix type
                                'ProbabilityTolerance',1e-8,    ...
                                'Replicates',10);
end

%% Finding confusion matrix by evaluating full Gaussian equations (testing)
% NB: Time and resource consuming

% confuse_matrix=zeros(N_vowels, N_vowels);
% for n_vowels_outer=1:N_vowels
%     current_vowel_indeks=find(test_vowel_code==n_vowels_outer);
%     size_test_set=size(current_vowel_indeks, 2);
%     for i = 1:size_test_set
%         current_indeks=current_vowel_indeks(i);
%         current_data=test_features(current_indeks,:);
%         current_all_probs=zeros(1, N_vowels);
%         for n_vowels_inner=1:N_vowels
%             current_gaussian=single_gaussian(n_vowels_inner);
%             current_all_probs(1,n_vowels_inner)=subs(current_gaussian,[x(1), x(2), x(3)],current_data);
%         end
%         [~, current_best_class_fit]=max(current_all_probs);
%         confuse_matrix(n_vowels_outer, current_best_class_fit)=...
%         confuse_matrix(n_vowels_outer, current_best_class_fit)+1;
%     end
% end

%% Finding confusion matrix by mvnpdf evaluation from mean and covariance at each datapoint (testing)

confuse_matrix=zeros(N_vowels, N_vowels);
for n_vowels_outer=1:N_vowels
    current_vowel_indeks=find(test_vowel_code==n_vowels_outer);
    size_test_set=size(current_vowel_indeks, 2);
    for i = 1:size_test_set
        current_indeks=current_vowel_indeks(i);
        current_data=test_features(current_indeks,:);
        current_all_probs=zeros(1, N_vowels);
        for n_vowels_inner=1:N_vowels
            sigma=reshape(covariances(n_vowels_inner,:,:), [N_features,N_features]);
            mu=means(n_vowels_inner, :);
            current_all_probs(1,n_vowels_inner)=mvnpdf(current_data, mu, sigma);
        end
        [~, current_best_class_fit]=max(current_all_probs);
        confuse_matrix(n_vowels_outer, current_best_class_fit)=...
        confuse_matrix(n_vowels_outer, current_best_class_fit)+1;
    end
end

%% Finding confusion matrix by evaluating gmdistribution objects (testing)

% confuse_matrix=zeros(N_vowels, N_vowels);
% for n_vowels_outer=1:N_vowels
%     current_vowel_indeks=find(test_vowel_code==n_vowels_outer);
%     size_test_set=size(current_vowel_indeks, 2);
%     for i = 1:size_test_set
%         current_indeks=current_vowel_indeks(i);
%         current_data=test_features(current_indeks,:);
%         current_all_probs=zeros(1, N_vowels);
%         for n_vowels_inner=1:N_vowels
%             current_all_probs(1,n_vowels_inner)=pdf(GMMs{n_vowels_inner}, current_data);
%         end
%         [~, current_best_class_fit]=max(current_all_probs);
%         confuse_matrix(n_vowels_outer, current_best_class_fit)=...
%         confuse_matrix(n_vowels_outer, current_best_class_fit)+1;
%     end
% end

%% Finding the error rate of the confusion matrix

correct=0;
error=0;
for i=1:N_vowels
    for j=1:N_vowels
        if i==j
            correct=correct+confuse_matrix(i,j);
        else
            error=error+confuse_matrix(i,j);
        end
    end
end
hitrate=correct/(correct+error);
errorrate=error/(error+correct);

%% Plot

% figure
% 3D scatter with 3 features and all classes
% for n_vowels=1:N_vowels
%     if n_vowels <= size_color_array
%         scatter3(   features(find(n_vowels==vowel_code),1),       ...
%                     features(find(n_vowels==vowel_code),2),       ...
%                     features(find(n_vowels==vowel_code),3),       ...
%                     colors_pure_RGB(n_vowels,:),                  ...
%                     'LineWidth', 0.75);
%         hold on
%     else
%         scatter3(   features(find(n_vowels==vowel_code),1),       ...
%                     features(find(n_vowels==vowel_code),2),       ...
%                     features(find(n_vowels==vowel_code),3),       ...
%                     'MarkerEdgeColor',                            ...
%                     colors_mixed_RGB(n_vowels-size_color_array,:),...
%                     'LineWidth', 0.75);
%     end
% end
% legend('ae','ah','aw','eh','ei','er','ih','iy','oa','oo','uh','uw');

% 3D scatter with 3 features, class 1 and mean for class 1
% vowel_1_indeks=find(vowel_code==1);
% scatter3(   features(vowel_1_indeks,1), features(vowel_1_indeks,2), features(vowel_1_indeks, 3), ...
%             'LineWidth', 0.75);
% hold on
% scatter3(means(1,1), means(1,2), means(1,3), 'LineWidth', 0.75)
% legend('ae','mean')
% 
% xlabel(feature_names(1, :))
% ylabel(feature_names(2, :))
% zlabel(feature_names(3, :))

% Single Gaussian 3D plot for first class
% f=single_gaussian(1);
% f_handle=@(x1, x2, x3) f;
% fimplicit3(f, [-10000 10000 -10000 10000 -10000 10000])
% xlabel(feature_names(1, :))
% ylabel(feature_names(2, :))
% zlabel(feature_names(3, :))
% legend('Single Gaussian class model')

% GMM 3D plot for first class
% x0=0;
% y0=0;
% z0=0;
% gmPDF = @(x,y,z) arrayfun(@(x0,y0,z0) pdf(GMMs{1},[x0 y0,z0]),x,y, z);
% fimplicit3(gmPDF,[-10000 10000 -10000 10000 -10000 10000])
% xlabel(feature_names(1, :))
% ylabel(feature_names(2, :))
% zlabel(feature_names(3, :))
% legend('Gaussian mix (k=3) class model')

% Plot confuse matrix
% f = figure;
% set(gcf,'color','w');
% uit = uitable(f);
% uitable('Data',confuse_matrix,'Position',[0 0 700 350])

% Plotting heatmap
% heat_map=zeros(N_vowels,1);
% for n_vowels=1:N_vowels
%     heat_map(n_vowels,1)=log(norm(reshape(covariances(n_vowels,:,:),[3,3]),2));
% end
% clims = [10.9 13.1];
% imagesc(heat_map,clims)
% colorbar


% Plotting covariance matrix
% disp_cov=[]
% for n_vowels=1:N_vowels
%     disp_cov=[disp_cov;reshape(covariances_diag(n_vowels,:,:),[3,3])];
% end
% 
% f = figure;
% set(gcf,'color','w');
% uit = uitable(f);
% uitable('Data',disp_cov(19:36,:),'Position',[0 0 350 400]);
