clc
clear
close all
addpath(genpath(pwd))

%% common setting

new_sampling_rate = 32; % from 2048 to 32 Hz
sub_numbers =[1,3,4,6,7,9];
preprocess_flag = 0; % 0 for skiping preprocessesing & epoching step

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
            load_path = [pwd,'\dataset\subject',num2str(sub_numbers(i)),'\session',num2str(j)];
            save_path = [pwd,'\dataset\subject',num2str(sub_numbers(i)),'\s',num2str(j),'.mat'];
            extracttrials(load_path,save_path, new_sampling_rate);
            subjec_path{1,j}=save_path;
        end

        all_subjects_path{i}=subjec_path;

    end

end

%% Classifying data

% classifier_type = {'bayes_lda' , 'svm' , 'lasso_glm'};
classifier_type = {'deep_cnn','bayes_lda' };


for i= 1:length(sub_numbers)

    for j=1:4
        load_path = [pwd,'\dataset\subject',num2str(sub_numbers(i)),'\session',num2str(j)];
        save_path = [pwd,'\dataset\subject',num2str(sub_numbers(i)),'\s',num2str(j),'.mat'];
        subjec_path{1,j}=save_path;
    end

    all_subjects_path{i}=subjec_path;

    for j=1:length(classifier_type)
        [acc(i,j).vals] = classifiers_analysis( all_subjects_path{i} , classifier_type{j}, channels);
    end

    plot(acc(i,1).vals,'b')
    hold on
    plot(acc(i,2).vals,'r')
    pause(0.5)
end

%% plot the results

close all

for i= 1:length(sub_numbers)
    hold off
    plot(acc(i,1).vals,'b')
    hold on
    plot(acc(i,2).vals,'r')
    pause(0.1)

end

