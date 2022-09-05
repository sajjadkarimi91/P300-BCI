clc
clear
close all
addpath(genpath(pwd))

%% common setting

new_sampling_rate = 32; % from 2048 to 32 Hz
sub_numbers = [3,4] ;%[1,3,4,6,7,9];
preprocess_flag = 1; % 0 for skipping preprocessing & epoching step

dataset_dir = [pwd,'\dataset'];

%% subsets of electrodes for classification
% https://www.epfl.ch/labs/mmspg/research/page-58317-en-html/bci-2/bci_datasets/

% Fz, Cz, Pz, Oz
channels = [31 32 13 16];

% Fz, Cz, Pz, Oz, P7, P3, P4, P8
% channels = [31 32 13 16 11 12 19 20];

% Fz, Cz, Pz, Oz, P7, P3, P4, P8, O1, O2, C3, C4, FC1, FC2, CP1, CP2
% channels = [31 32 13 16 11 12 19 20 15 17 8 23 5 26 9 22];

% All electrodes
% channels = [1:32];

%% EEG epoching & preprocessing

if preprocess_flag>0
    for i= 1:length(sub_numbers)

        clc
        sub_numbers(i)
        clear subjec_path

        for j=1:4
            load_path = [dataset_dir,'\subject',num2str(sub_numbers(i)),'\session',num2str(j)];
            save_path = [dataset_dir,'\subject',num2str(sub_numbers(i)),'\s',num2str(j),'.mat'];
            extracttrials_modified(load_path,save_path, new_sampling_rate);
            subjec_path{1,j}=save_path;
        end

        all_subjects_path{i}=subjec_path;

    end

end

%% Classifying data

% classifier_type = {'bayes_lda' , 'svm' , 'lasso_glm','deep_cnn'};
classifier_type = {'bayes_lda' };


for i= 1:length(sub_numbers)
    clc
    sub_numbers(i)
    for j=1:4
        load_path = [dataset_dir,'\subject',num2str(sub_numbers(i)),'\session',num2str(j)];
        save_path = [dataset_dir,'\subject',num2str(sub_numbers(i)),'\s',num2str(j),'.mat'];
        subjec_path{1,j}=save_path;
    end

    all_subjects_path{i}=subjec_path;

    for j=1:length(classifier_type)
        [acc(i,j).vals] = classifiers_analysis( all_subjects_path{i} , classifier_type{j}, channels);
    end

    plot(acc(i,1).vals,'b')
    pause(0.5)
end

% plot the results

close all

for i= 1:length(sub_numbers)
    figure
    for j=1:length(classifier_type)
        plot(acc(i,j).vals,'linewidth',1.5)
        hold on
        grid on
    end
    ylabel('ACC')
    xlabel('trail number')
    legend(classifier_type,'Location','best')
    title(['subject: ',num2str(sub_numbers(i))])

end


%% Classifying data

% classifier_type = {'bayes_lda' , 'svm' , 'lasso_glm','deep_cnn'};
classifier_type = {'bayes_lda' };
channels_cell = {[31 32 13 16],[31 32 13 16 11 12 19 20],[31 32 13 16 11 12 19 20 15 17 8 23 5 26 9 22],1:32};
channels_cell_name = {'4-channel','8-channel','16-channel','32-channel'};

for i= 1:length(sub_numbers)
    clc
    sub_numbers(i)
    for j=1:4
        load_path = [dataset_dir,'\subject',num2str(sub_numbers(i)),'\session',num2str(j)];
        save_path = [dataset_dir,'\subject',num2str(sub_numbers(i)),'\s',num2str(j),'.mat'];
        subjec_path{1,j}=save_path;
    end

    all_subjects_path{i}=subjec_path;

    for j=1:length(channels_cell)
        [acc(i,j).vals] = classifiers_analysis( all_subjects_path{i} , classifier_type{1}, channels_cell{j});
    end

    plot(acc(i,1).vals,'b')
    pause(0.5)
end

% plot the results

close all

for i= 1:length(sub_numbers)
    figure
    for j=1:length(channels_cell)
        plot(acc(i,j).vals,'linewidth',1.5)
        hold on
        grid on
    end
    ylabel('ACC')
    xlabel('trail number')
    legend(channels_cell_name,'Location','best')
    title(['subject: ',num2str(sub_numbers(i))])

end

