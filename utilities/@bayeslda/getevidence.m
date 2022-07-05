function e = getevidence(b)
% returns log evidence from object b
%
% INPUT:
%    b       - object of type bayeslda
%
% OUTPUT:
%    e       - log evidence
%
% Author: Ulrich Hoffmann - EPFL, 2006
% Copyright: Ulrich Hoffmann - EPFL

e = b.evidence;