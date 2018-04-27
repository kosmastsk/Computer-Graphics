function dp = systemtrans(cp, b1, b2, b3, co)
%SYSTEMTRANS Changing the coordinate system of a point
%   Having the initial coordinates of a point, calculate the new
%   coordinates with respect to a a new coordinate system that has a
%   different start point (o + vo) and is rotated with the transformation L
%
%   VARIABLES
%   cp : 3x1 column with the coordinates of the point
%   b1 : x-axis of the new coordinate system
%   b2 : y-axis of the new coordinate system
%   b3 : z-axis of the new coordinate system
%   co : 3x1 column with the coordinates of the vector vo
%   dp : 3xn new coordinates of the n points

%% Apply the transformation
% Calculate the unit vectors
b = [b1;b2;b3];
unit_b = b ./ norm(b);
unit_bo = cp ./ norm(cp);

% Calculate the transform matrix


% Calculate the new coordinates 
dp = inv(L) * (cp - co);


end
