function EEG_Filtered = sjk_eeg_filter(EEG,fs,fc1,fc2)
% EEG is N x T matrix which N is # of Electrodes & T is # of time samples
% fs is sampling frequency and fc1 and fc2 are cutt of frequencies
EEG = double(EEG);
b=fir1(2*fs,[2*fc1/fs 2*fc2/fs]);

[N , T,num_trail] = size(EEG );
EEG_Filtered = zeros(N , T, num_trail) ;

% Filter each EEG channels
for j=1:num_trail
    for i = 1 : N        
        EEG_Filtered(i , :,j) = filtfilt(b(:)',1,squeeze(EEG(i , :,j)));        
    end
end
