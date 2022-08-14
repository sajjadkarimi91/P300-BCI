clc
clear
close all
addpath(genpath(pwd))

%% common setting

new_sampling_rate = 128;
sub_numbers =[3,7];

%% subsets of electrodes for classification
% https://www.epfl.ch/labs/mmspg/research/page-58317-en-html/bci-2/bci_datasets/


% Best channels for P300 are  Cz, Pz,C3, C4, CP1, CP2
channels =                   [32  13  8  23   9    22];

channel_names = {'Cz'; 'Pz';'C3'; 'C4'; 'CP1'; 'CP2'};
for ch = 1:length(channel_names)
    chanlocs(ch).labels = channel_names{ch};
end

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
    [p300_event, non_p300_event, p300_epoches, nonp300_epoches] = erp_analysis(subjec_path, channels);


    epochs{1}{1}.data = p300_epoches;
    epochs{1}{1}.chanlocs = chanlocs;
    epochs{1}{1}.srate = new_sampling_rate;
    epochs{1}{1}.xmin = -0.1;
    epochs{1}{1}.xmax = 0.9-1/new_sampling_rate;

    epochs{2}{1}.data = nonp300_epoches;
    epochs{2}{1}.chanlocs = chanlocs;
    epochs{2}{1}.srate = new_sampling_rate;
    epochs{2}{1}.xmin = -0.1;
    epochs{2}{1}.xmax = 0.9-1/new_sampling_rate;

    for ch = 1:length(channel_names)
        plot_erp(epochs, channel_names{ch}, 'plotstd', 'fill', 'labels',{'P300','Baseline'});
    end

    pause()

end


