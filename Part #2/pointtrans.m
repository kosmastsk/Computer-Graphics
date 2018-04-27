function cq = pointtrans(cp, R, ct)
%POINTTRANS Affine transformation of a vector
%   Apply an Affine transformation to a vector cp, by rotating using the
%   rotation matrix R and shifting according to the vector t

% VARIABLES
% cp: 3x1 vector with the coordinates of a point p
% R : 3x3 rotation matrix
% ct: 3x1 vector with the coordinates of the shifting vector t
% cq: the result of the Affine transformation

%% Apply the transformation

cq = (R * cp) + repmat(ct, size(R,2), 1);

end

