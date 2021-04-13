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
C1=length(talker_group);


%% Histogram

figure(1)
for nfreq=1:Nfreq
    for c1=1:C1
        subplot(Nfreq,C1,C1*(nfreq-1)+c1);
        current_frequency=frequencies(:,nfreq);
        hist(current_frequency(find(talker_group_code==c1)),nbins);
        xlabel(talker_group(c1));
        ylabel(frequency_names(nfreq, :));
    end
end
