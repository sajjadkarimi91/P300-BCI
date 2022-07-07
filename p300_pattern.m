clc
clear
close all
addpath(genpath(pwd))

%% common setting

new_sampling_rate = 128;
sub_numbers =[1,3,6,7];

%% subsets of electrodes for classification
% https://www.epfl.ch/labs/mmspg/research/page-58317-en-html/bci-2/bci_datasets/

% Fz, Cz, Pz, Oz
% channels = [31 32 13 16];

% Fz, Cz, Pz, Oz, P7, P3, P4, P8
channels = [31 32 13 16 11 12 19 20];

% Fz, Cz, Pz, Oz, P7, P3, P4, P8, O1, O2, C3, C4, FC1, FC2, CP1, CP2
% channels = [31 32 13 16 11 12 19 20 15 17 8 23 5 26 9 22];

% All electrodes
% channels = [1:32];

% Cz, Pz,C3, C4, CP1, CP2
channels = [32 13 8 23 9 22];

%% EEG epoching & preprocessing

for i= 1:length(sub_numbers)

    clc
    sub_numbers(i)
    clear subjec_path

    for j=1:4
        load_path = [pwd,'\dataset\subject',num2str(sub_numbers(i)),'\session',num2str(j)];
        save_path = [pwd,'\dataset\subject',num2str(sub_numbers(i)),'\ss',num2str(j),'.mat'];
        extract_trials_p300(load_path,save_path, new_sampling_rate);
        subjec_path{1,j}=save_path;
    end
    [p300_event, non_p300_event] = erp_analysis(subjec_path, channels);

    figure
    plot(linspace(-100,900,new_sampling_rate), p300_event')
    hold on
    plot(linspace(-100,900,new_sampling_rate), non_p300_event','r')
    grid on

end


%% plot the results

close all

for i= 1:length(sub_numbers)

    subplot(3,2,i)
    plot(acc(i).vals)
    hold on

    subplot(3,2,i)
    plot(acc(i).vals)
    hold on

    pause(0.05)
end

