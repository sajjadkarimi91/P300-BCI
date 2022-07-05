function x = apply(n, x)
% normalization procedure for EEG data
% uses minima and maxima or means and standard deviations stored in
% the object n
%
% INPUT:
%    n       - object of type normalize
%    x       - m*n*t matrix containing t EEG trials with m channels and 
%              n samples
%
% OUTPUT:
%    x       - normalized x

n_channels = size(x,1);
n_samples  = size(x,2);
n_trials   = size(x,3);

x = reshape(x,n_channels,n_samples*n_trials);

switch n.method
    
    case 'minmax'
        x = x -  repmat(n.min,1,n_samples*n_trials);
        x = x ./ repmat(n.max-n.min,1,n_samples*n_trials);  
        x = 2*x - ones(n_channels,n_samples*n_trials); 
        
    case 'z-score'
        x = x -  repmat(n.mean,1,n_samples*n_trials);
        x = x ./ repmat(n.std,1,n_samples*n_trials);  
        
    otherwise
        fprintf('unknown normalization method');

end

x = reshape(x,n_channels,n_samples,n_trials);