function accuracy = performance_analysis(filelist , classifier_type, channels)
%
% crossvalidate(filelist)
%
% Uses n - 1 of the n files in *filelist* to build a classifier and tests the
% classifier on the left-out file. This is done once for each file and
% results are averaged. Average classification accuracy and bitrate are plotted.
% The files in *filelist* have to be built with extracttrials.
%
% Example: crossvalidate({'s1','s2','s3','s4'})

% Author: Ulrich Hoffmann - EPFL, 2006
% Copyright: Ulrich Hoffmann - EPFL


%% do the crossvalidation
n_correct = zeros(length(filelist),15);
n_test = zeros(length(filelist),15);

for i = 1:length(filelist)
    trainingfiles = filelist;
    trainingfiles(i) = [];

    if(strcmp(classifier_type,'bayes_lda'))
        [n_correct(i,:),n_test(i,:)] = testclassification(trainingfiles,filelist{i}, channels);
    elseif strcmp(classifier_type,'svm')
        [n_correct(i,:),n_test(i,:)] = testclassification_svm(trainingfiles,filelist{i}, channels);
    elseif strcmp(classifier_type,'lasso_glm')
        [n_correct(i,:),n_test(i,:)] = testclassification_lassoGLM(trainingfiles,filelist{i}, channels);
    end

end


% plot the results
accuracy = sum(n_correct) ./ sum(n_test);    % each file contains six runs


