function [n_correct, n_test] = method_deep_cnn(trainingfiles, testfile, channels)
%
% svm_method(trainingfiles, testfile, channels)
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
    fprintf('loading %s\n',trainingfiles{i});
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
w = train(w,x,0.1);
x = apply(w,x);
nrm = normalize;
nrm = train(nrm,x,'z-score');
x = apply(nrm,x);

n_channels = length(channels);
n_samples = size(x,2);
n_trials = size(x,3);
% x = reshape(x,n_samples*n_channels,n_trials);

% wieghts_train = ones(size(y,1),size(y,2));
% wieghts_train(y==1)=sum(y==-1)/length(y);
% wieghts_train(y==-1)=sum(y==1)/length(y);
y=categorical(y);
XTrain = cell(round(0.8*n_trials),1);
XValidation = cell(n_trials - round(0.8*n_trials),1);

ind_rand = randperm(n_trials);
for n=1:length(XTrain)
    XTrain{n,1} = squeeze(x(:,:,ind_rand(n)))';
    TTrain{n,1} = y(ind_rand(n));
end

for n=length(XTrain)+1:n_trials
    XValidation{n-length(XTrain),1} = squeeze(x(:,:,ind_rand(n)))';
    TValidation{n-length(XTrain),1} = y(ind_rand(n));
end



numClasses = 2;

filterSize = 24;
numFilters = 100;
numFeatures = n_channels;

layers = [ ...
    sequenceInputLayer([n_samples,numFeatures])
    convolution1dLayer(filterSize,numFilters,'Padding','same')    
    eluLayer
    maxPooling1dLayer(3, 'Stride', 2)
    flattenLayer
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];

miniBatchSize = 50;

options = trainingOptions("adam", ...
    MiniBatchSize=miniBatchSize, ...
    MaxEpochs=10, ...
    L2Regularization=0.00005,...
    Shuffle='every-epoch',...
    ValidationFrequency=10,...
    ValidationPatience=20,...% for early stop
    SequencePaddingDirection="left", ...
    ValidationData={XValidation,TValidation}, ...
    Plots='none', ...% or "training-progress" , 'none'
    Verbose=1);

net = trainNetwork(XTrain,TTrain,layers,options);

%% load testfile and do classification
f = load(testfile);
n_runs = length(f.runs);
n_blocks = 15;
n_correct = zeros(1,n_blocks);
n_test = zeros(1,n_blocks);

for i = 1:n_runs
    x = f.runs{i}.x(channels,:,:);
    x = apply(w,x);
    x = apply(nrm,x);
    n_trials = size(x,3);
    %     x = reshape(x,n_channels*n_samples,n_trials);
    XValidation = cell(n_trials,1);
    for n=1:length(XValidation)
        XValidation{n,1} = squeeze(x(:,:,n))';
    end

    y_two_class = predict(net,XValidation, ...
        MiniBatchSize=miniBatchSize, ...
        SequencePaddingDirection="left");
    y_two_class = cell2mat(y_two_class);
    y = y_two_class(2:2:end)';
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

