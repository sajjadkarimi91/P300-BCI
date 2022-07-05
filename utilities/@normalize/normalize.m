function n = normalize
% constructor for class normalize
% normalize can be used to normalize multichannel data 
%
% METHODS:
%       train - computes characteristics (e.g. minima, and maxima) 
%               of EEG channels
%       apply - normalize EEG channels according to previously computed 
%               characteristics
%
% Author: Ulrich Hoffmann - EPFL, 2006
% Copyright: Ulrich Hoffmann - EPFL

n.min = [];                 % minimal amplitude for all EEG channels
n.max = [];                 % maximal amplitude for all EEG channels
n.mean = [];                % mean amplitude for all EEG channels
n.std = [];                 % standard deviation for all EEG channels
n.method = '';              % normalization method "minmax" or "z-score"

n = class(n,'normalize');
