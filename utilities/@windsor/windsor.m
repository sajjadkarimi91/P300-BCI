function w = windsor
% constructor for class windsor
% windsor can be used to "windsorize" EEG data
%
% METHODS:
%       train - computes percentiles of EEG channels
%       apply - clips samples with amplitudes smaller or bigger than 
%               previously compted percentiles
%
% Author: Ulrich Hoffmann - EPFL, 2006
% Copyright: Ulrich Hoffmann - EPFL

w.limit_l = [];         % (lower) percentiles for each EEG channel
w.limit_h = [];         % (upper) percentiles for each EEG channel
w = class(w,'windsor');
