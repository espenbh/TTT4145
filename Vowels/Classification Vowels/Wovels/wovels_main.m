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
% These samples are distributed over 45 males, 48 women,
% 27 boys and 19 girls.

%% Clear
clc
clear all

%% Import data
% Read vowdata_nohead.dat into [files, dur, F0s...] 
% formated by %s%4.1f%4.1f%4.1...
% "files" are interpreted by the rule below

[files,dur,F0s,F1s,F2s,F3s,F4s,F120,F220,F320,F150,F250,F350,F180,F280,F380] = ...
textread('vowdata_nohead.dat',...
'%s%4.1f%4.1f%4.1f%4.1f%4.1f%4.1f%4.1f%4.1f%4.1f%4.1f%4.1f%4.1f%4.1f%4.1f%4.1f');

%Forms character arrays to order the data
vowel = str2mat('ae','ah','aw','eh','er','ei','ih','iy','oa','oo','uh','uw');
vowel_names = ['ae';'ah';'aw';'eh';'er';'ei';'ih';'iy';'oa';'oo';'uh';'uw'];
talker_group = str2mat('m','w','b','g');

filenames=char(files);          % convert cell array to character matrix
[nfiles,~]=size(filenames); % Extract file size parameters

for ifile=1:nfiles  %For all data points, put their data into the right spot in the character arrays
    vowel_code(ifile) = strmatch(filenames(ifile,4:5),vowel);               %Match wovel number with current datapoint
    talker_group_code(ifile) = strmatch(filenames(ifile,1),talker_group);   %Match talker group with current data point
    talker_number(ifile) = str2num(filenames(ifile,2:3));                   %Match talker number with current data point
end

%% Parameters
frequencies=[F0s,F1s,F2s,F3s,F4s,F120,F220,F320,F150,F250,F350,F180,F280,F380];
frequency_names=['F0s ';'F1s ';'F2s ';'F3s ';'F4s ';'F120';'F220';'F320';'F150';'F250';'F350';'F180';'F280';'F380'];
Nform=size(frequencies, 2); %Number of formant types in original data set

Nbins=20;                   % Bins for histograms
Nt=139;                     % Number of talkers
N_tg=4;                     % Number of talker groups
Nw=length(vowel);           % Number of wovels

feature_mode=100;
N_features=3;

%% Choose features

features=       zeros(Nw*Nt, N_features);
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


%% Histogram over classes and features
% figure(1)
% for n_features=1:N_features     % For all features
%     for nw=1:Nw                 % For all classes
%         subplot(N_features,Nw,Nw*(n_features-1)+nw);
%         current_feature=features(:,n_features);
%         hist(current_feature(find(vowel_code==nw)),nbins);
%         xlabel(vowel_names(nw, :));
%         ylabel(feature_names(n_features, :));
%     end
% end

%% Calculate mean over vowels and features
means=zeros(Nw, N_features);
covariances=zeros(Nw, N_features, N_features);

for n_features=1:N_features
    for nw=1:Nw
        current_feature=features(:,n_features);
        x = current_feature(find(vowel_code==nw));
        means(nw, n_features) = mean(x);
%       disp(['Mean ', feature_names(n_features, :), ' for ', vowel_names(nw, :), ' : ',num2str(means(nw, n_features))]);
    end
end


for nw=1:Nw
    x = features((nw-1)*Nt+1:nw*Nt, :);
    covariances(nw, :, :) = cov(x);
    disp(['Covariance for ', vowel_names(nw, :)]) 
    covariances(nw, :, :)
end

%% Caluclate and plot single Gaussian distribution for all features and classes
% syms x
% single_gaussian=sym('x',[Nw N_features]);
% for nw=1:Nw
%     %x=sym('x', [1 3])
%     sigma=reshape(covariances(nw, :, :), [3,3])
%     mu=means(nw, :)
%     X = features((nw-1)*Nt+1:nw*Nt, :)
%     mvnpdf(X, mu, sigma)
%     %single_gaussian(nw)=mvnpdf(x);
% end

%% Training with single Gaussian


%% Plot
%3D scatter with 3 features and all vowels.
for nw=1:Nw
    scatter3(features((nw-1)*Nt+1:nw*Nt,1), features((nw-1)*Nt+1:nw*Nt,2), features((nw-1)*Nt+1:nw*Nt, 3))
    hold on
end

xlabel('F1s');
ylabel('F2s');
zlabel('F3s');
legend('ae','ah','aw','eh','er','ei','ih','iy','oa','oo','uh','uw');


%% Remove outliers F0
% Working on copy => non destructive
% x = F0s(find(talker_group_code==1));
% mx = mean(x);
% disp('Mean F0 for males:')
% disp(mx);
% 
% sd2         = std(x) * 2;
% ind_higher  = find(x > mx+sd2);
% ind_lower   = find(x < mx - sd2);
% ind         = intersect(ind_higher, ind_lower);
% x(ind)      = [];
% mx          = mean(x);
% disp('Mean F0 for males (outliers removed): ')
% disp(mx);

