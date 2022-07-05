clc
clear
close all
addpath(genpath(pwd))

%% common setting

sub_numbers =[1,3,4,6,7,9];
preprocess_flag = 1; % 0 for skiping preprocessesing & epoching step

%% subsets of electrodes for classification

% Fz, Cz, Pz, Oz
% channels = [31 32 13 16];

% Fz, Cz, Pz, Oz, P7, P3, P4, P8
channels = [31 32 13 16 11 12 19 20];

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

            load_path = [pwd,'\data_set\subject',num2str(sub_numbers(i)),'\session',num2str(j)];
            save_path = [pwd,'\data_set\subject',num2str(sub_numbers(i)),'\s',num2str(j)];
            extracttrials(load_path,save_path);
            subjec_path{1,j}=save_path;
        end

        all_subjects{i}=subjec_path;

    end

end

%% Classifying data

% classifier_type = {'bayes_lda' , 'svm' , 'lasso_glm'};
classifier_type = {'bayes_lda', 'svm' };


for i= 1:length(sub_numbers)

    for j=1:4

        load_path = [pwd,'\subject',num2str(sub_numbers(i)),'\session',num2str(j)];

        save_path = [pwd,'\subject',num2str(sub_numbers(i)),'\s',num2str(j)];
        subjec_path{1,j}=save_path;

    end

    all_subjects{i} = subjec_path;

    for j=1:length(classifier_type)
        [acc(i).vals] = crossvalidate( all_subjects{i} , classifier_type{j}, channels);
    end



    subplot(3,2,i)
    plot((acc_bayes_lda(i).x))
    hold on
    plot((acc_svm(i).x))

    pause(0.05)

end

%% plot the results

close all

for i= 1:length(sub_numbers)

    subplot(3,2,i)
    plot((acc_bayes_lda(i).x))
    hold on

end

