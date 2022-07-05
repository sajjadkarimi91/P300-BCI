clc
clear
close all
addpath(genpath(pwd))

%% subsets of electrodes
% Fz, Cz, Pz, Oz
% channels = [31 32 13 16];

% Fz, Cz, Pz, Oz, P7, P3, P4, P8
channels = [31 32 13 16 11 12 19 20];

% Fz, Cz, Pz, Oz, P7, P3, P4, P8, O1, O2, C3, C4, FC1, FC2, CP1, CP2
% channels = [31 32 13 16 11 12 19 20 15 17 8 23 5 26 9 22];

% All electrodes
% channels = [1:32];

sub_numbers =[1,3,4,6,7,9];

for i= 1:length(sub_numbers)

    clc
    sub_numbers(i)
    clear subjec_path

    for j=1:4

        load_path = [pwd,'\data_set\subject',num2str(sub_numbers(i)),'\session',num2str(j)];
        save_path = [pwd,'\data_set\subject',num2str(sub_numbers(i)),'\s',num2str(j)];
        %         extracttrials(load_path,save_path);
        subjec_path{1,j}=save_path;
    end

    subject_all{i}=subjec_path;

end



% classifier_type = {'bayes_lda' , 'svm' , 'lasso_glm'};
classifier_type = {'bayes_lda', 'svm' };


for i= 1:length(sub_numbers)

    for j=1:4

        load_path = [pwd,'\subject',num2str(sub_numbers(i)),'\session',num2str(j)];

        save_path = [pwd,'\subject',num2str(sub_numbers(i)),'\s',num2str(j)];
        subjec_path{1,j}=save_path;

    end

    subject_all{i} = subjec_path;
    [ACC_1(i).x] = crossvalidate( subject_all{i} , classifier_type{1});
    [ACC(i).x] = crossvalidate( subject_all{i} , classifier_type{2});


    subplot(3,2,i)
    plot((ACC_1(i).x))
    hold on
    plot((ACC(i).x))

    pause(0.05)

end

close all

for i= 1:length(sub_numbers)


    subplot(3,2,i)
    plot((ACC_1(i).x))
    hold on
    plot((ACC(i).x))

end

% [ACC(i).x, BIT(i).x] = crossvalidate( subject_all{1})

%%
% ACC(8).x=[];
%  BIT(8).x=[];
% 8 electrod
sub_numbers=[1:4 6:9];
i=8;
sub_numbers(i)
%      location1=sprintf('F:\\REPORTS\\HW\\HW_BSP\\HW2\\dataset\\subject%d',subb(i));
%      userpath(location1)
figure
[ACC(i).x, BIT(i).x] = crossvalidate({'sss1','sss2','sss3','sss4'});
figure
%   [ACC(i).y, BIT(i).y]=crossvalidate1({'PCA1','PCA2','PCA3','PCA4'});
[ACC(i).y, BIT(i).y] = crossvalidate1({'DWTdb61','DWTdb62','DWTdb63','DWTdb64'});

% %%
% Acx=[];
% Acy=[];
% for i=1:8
%     Acx(i,:)= ACC(i).x;
%     Bx(i,:)=BIT(i).x;
%     Acy(i,:)=ACC(i).y;
%     By(i,:)=BIT(i).y;
% end
% %%
%   t=linspace(0,1,256);
%   for i=1:32
%       i=1
%  dd(i,:)=mean(runs{1,4}.x(i,:,find(runs{1,1}.y(1:90)==1)),3);
%  hold on
%  plot(t,dd(i,:))
%   end
%   figure
%   plot(t, mean(dd))
%   eegplot(dd,'srate',64)