function [p300_event, non_p300_event] = erp_analysis(trainingfiles, channels)
%
% p300_pattern(trainingfiles, testfile, channels)
%
% Uses the data in *trainingfiles* to build a classifier and tests
% the classifier on the data in *testfile*. *n_correct* contains for each
% number of blocks (1-20) the number of correctly classified items. If no
% output arguments are given *n_correct* is plotted.
% The training files and the test file have to be built with extracttrials.
%
% Example: testclassification({'s2','s3','s4'},'s1')

% Author: Ulrich Hoffmann - EPFL, 2006
% Copyright: Ulrich Hoffmann - EPFL



%% load training files and concatenate data and labels into two big arrays
x = [];
y = [];
for i = 1:length(trainingfiles)    
    f = load(trainingfiles{i});
    n_runs = length(f.runs);
    for j = 1:n_runs
        x = cat(3,x,f.runs{j}.x);
        y = [y f.runs{j}.y];
    end
end


%% select channels, windsorize, normalize, bayesian lda
x = x(channels,:,:);
w = windsor;
w = train(w,x,0.05);
x = apply(w,x);

% n = normalize;
% n = train(n,x,'z-score');
% x = apply(n,x);


p300_event     = mean(x(:,:,y==1),3);
non_p300_event = mean(x(:,:,y==-1),3);


end