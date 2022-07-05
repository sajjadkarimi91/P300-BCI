function x = apply(w, x)
% windsorizes the data in x
% this means that values that are smaller or bigger than the percentile
% values in w.limit_l and w.limit_h are clipped
%
% INPUT:
%    w       - object of type windsor
%    x       - m*n*t matrix containing t EEG trials with m channels and 
%              n samples
%
% OUTPUT:
%    x       - x windsorized
%
% Author: Ulrich Hoffmann - EPFL, 2006
% Copyright: Ulrich Hoffmann - EPFL


%% initialize variables
n_channels = size(x,1);
n_samples  = size(x,2);
n_trials   = size(x,3);


%% clip the data
x = reshape(x,n_channels,n_samples*n_trials);
l = repmat(w.limit_l',1,n_samples*n_trials);
h = repmat(w.limit_h',1,n_samples*n_trials);
i_l = x < l;
i_h = x > h;
x(i_l) = l(i_l);
x(i_h) = h(i_h);
x = reshape(x,n_channels, n_samples, n_trials);
