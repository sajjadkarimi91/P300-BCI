function n = train(n, x, method)
% training procedure for normalize
% computes minima and maxima, or means and standard deviations for 
% normalization of EEG channels
%
% INPUT:
%    n       - object of type normalize
%    x       - m*n*t matrix containing t EEG trials with m channels and 
%              n samples
%    method  - either 'minmax' or 'z-score'
%
% OUTPUT:
%    n       - updated object of type normalize

n_channels = size(x,1);
n_samples  = size(x,2);
n_trials   = size(x,3);
x = reshape(x,n_channels,n_samples*n_trials);

switch method
    
    case 'minmax'
        n.min = min(x,[],2);
        n.max = max(x,[],2);
        n.method = 'minmax';
        
    case 'z-score'
        n.mean = mean(x,2);
        n.std = std(x,[],2);
        n.method = 'z-score';        
        
    otherwise
        fprintf('unknown normalization method');

end
        