%% Import and process data
% Read vowdata_nohead.dat into [files, dur, F0s...] 
% formated by %s%4.1f%4.1f%4.1...
% "files" are interpreted by the rule below
% character 1, vowel_code: m=man, w=woman, b=boy, g=girl
% characters 2-3, talker_group_code: talker number
% characters 4-5, talker_number: vowel (ae=”had”, ah=”hod”, aw=”hawed”, eh=”head”,
% er=”heard”, ei=”haid”, ih=”hid”, iy=”heed”, oa=/o/ as in “boat”,
% oo=”hood”, uh=”hud”, uw=”who’d”)

[files,dur,F0s,F1s,F2s,F3s,F4s,F120,F220,F320,F150,F250,F350,F180,F280,F380] = ...
textread('vowdata_nohead.dat',...
'%s%4.1f%4.1f%4.1f%4.1f%4.1f%4.1f%4.1f%4.1f%4.1f%4.1f%4.1f%4.1f%4.1f%4.1f%4.1f');

%Forms character arrays to order the data
vowel = str2mat('ae','ah','aw','eh','er','ei','ih','iy','oa','oo','uh','uw');
talker_group = str2mat('m','w','b','g');

filenames=char(files);          % convert cell array to character matrix
[nfiles,nchar]=size(filenames); % Extract file size parameters

for ifile=1:nfiles  %For all talkers, put their data into the right spot in the character arrays
    vowel_code(ifile) = strmatch(filenames(ifile,4:5),vowel);               %Put talker into character 4-5 array
    talker_group_code(ifile) = strmatch(filenames(ifile,1),talker_group);   %Put talker into character 1 array
    talker_number(ifile) = str2num(filenames(ifile,2:3));                   %Put talker into character 2-3 array
end

%% Parameters
frequencies=[F0s,F1s,F2s,F3s,F4s,F120,F220,F320,F150,F250,F350,F180,F280,F380];
frequency_names=['F0s ';'F1s ';'F2s ';'F3s ';'F4s ';'F120';'F220';'F320';'F150';'F250';'F350';'F180';'F280';'F380'];
Nfreq=size(frequencies, 2);
nbins=20;
N_tg=length(talker_group);
N_w=length(vowel);


%% Histogram over frequencies
figure(1)
for nfreq=1:Nfreq
    for n_tg=1:N_tg
        subplot(Nfreq,N_tg,N_tg*(nfreq-1)+n_tg);
        current_frequency=frequencies(:,nfreq);
        hist(current_frequency(find(talker_group_code==n_tg)),nbins);
        xlabel(talker_group(n_tg));
        ylabel(frequency_names(nfreq, :));
    end
end

%% Calculate mean over frequencies
%Pattern: Men has the deepest (lowest frequency) voice.
%Then comes women, then comes boys, then comes girls.
for nfreq=1:Nfreq
    for n_tg=1:N_tg
        current_frequency=frequencies(:,nfreq);
        x = current_frequency(find(talker_group_code==n_tg));
        mx = mean(x);
        disp(['Mean ', frequency_names(nfreq, :), ' for ', talker_group(n_tg), ' : ',num2str(mx)]);
    end
end

%% Remove outliers F0
% Working on copy => non destructive
x = F0s(find(talker_group_code==1));
mx = mean(x);
disp('Mean F0 for males:')
disp(mx);

sd2         = std(x) * 2;
ind_higher  = find(x > mx+sd2);
ind_lower   = find(x < mx - sd2);
ind         = intersect(ind_higher, ind_lower);
x(ind)      = [];
mx          = mean(x);
disp('Mean F0 for males (outliers removed): ')
disp(mx);

%% find mean and covariance for vowels
means=zeros(1,Nw);
for nfreq=1:Nfreq
    for nw=1:Nw
        x = F0s(find(vowel_code==nw));
        mx = mean(x);
        means(nw)=means(nw)+mx;
    end
end
means=means./Nfreq;

