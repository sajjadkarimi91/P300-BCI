function w = train(w, x, p)
% computes percentiles for windsorizing
%
% INPUT:
%    b       - object of type windsor
%    x       - m*n*t matrix containing t EEG trials with m channels and 
%              n samples
%    p       - percentage of samples that will be clipped from each channel
%
% OUTPUT:
%    w       - updated object of type windsor
%
% Author: Ulrich Hoffmann - EPFL, 2006
% Copyright: Ulrich Hoffmann - EPFL


%% initialize variables
n_channels = size(x,1);
n_samples  = size(x,2);
n_trials   = size(x,3);
n_clip     = round(n_samples*n_trials*p/2);
x = reshape(x, n_channels, n_samples*n_trials);
w.limit_l = [];
w.limit_h = [];


%% compute (p/2)th percentiles for each channel
for i = 1:n_channels
    tmp = sort(x(i,:));
    w.limit_l(i) = tmp(n_clip);
    w.limit_h(i) = tmp(end-n_clip+1);
end
