function [n_correct, n_test] = method_bayslda(trainingfiles, testfile, channels)
%
% bayslda_method(trainingfiles, testfile, channels)
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
for i = 1:length(trainingfiles);
    %fprintf('loading %s\n',trainingfiles{i});
    f = load(trainingfiles{i});
    n_runs = length(f.runs);
    for j = 1:n_runs;
        x = cat(3,x,f.runs{j}.x);
        y = [y f.runs{j}.y];
    end
end


%% select channels, windsorize, normalize, bayesian lda  
x = x(channels,:,:);
w = windsor;
w = train(w,x,0.1);
x = apply(w,x);
n = normalize;
n = train(n,x,'z-score');
x = apply(n,x);

n_channels = length(channels);
n_samples = size(x,2);
n_trials = size(x,3);
x = reshape(x,n_samples*n_channels,n_trials);

b = bayeslda(1);
b = train(b,x,y);


%% load testfile and do classification
f = load(testfile);
n_runs = length(f.runs);
n_blocks = 15;
n_correct = zeros(1,n_blocks);
n_test = zeros(1,n_blocks);

for i = 1:n_runs
    x = f.runs{i}.x(channels,:,:);
    x = apply(w,x);
    x = apply(n,x);
    n_trials = size(x,3);
    x = reshape(x,n_channels*n_samples,n_trials);
    y = classify(b,x);
    scores = zeros(1,6);
   
    for j = 1:n_blocks        
        for strt_0 = 1 : min(n_blocks , floor(n_trials/6) - n_blocks)            
            for s = strt_0:floor(n_trials/6)
                                
                start = (s-1)*6+1;
                stop  = (s)*6;
                stimulussequence = f.runs{i}.stimuli(start:stop);                
                scores(stimulussequence) = scores(stimulussequence) + ...
                    y(start:stop);
                
                if(rem(s-strt_0+1,j)==0)                                        
                    n_test(j) = n_test(j)+1;                    
                    [~,idx] = max(scores);
                    if (idx == f.runs{i}.target)
                        n_correct(j) = n_correct(j)+1;
                    end                    
                    scores = zeros(1,6);                    
                end
                                
            end            
        end        
    end
    
end

