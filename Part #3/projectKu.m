function [P, D] = projectKu(w, cv, ck, cu, p)
%PROJECTKU Calculate the projection of the 3D points
%   Having a projection camera, calculate the projection points of a point
%   in the 3D world and its depth.
%   
%   VARIABLES
%   w  : distance between the screen and the centre
%   cv : coordinates of the shifting vector vc
%   ck : coordinate of camera's target K
%   cu : coordinate of the up vector u
%   p  : 3xn column with coordinates of n points
%   P  : 2xn array for saving the projection
%   D  : 1xn array for saving the depth of each point

%% Calculations

% normalized CK is the axis of the camera
CK = ck - cv;
zc = CK ./ norm(CK);

% calculate the t vector, which is parallel to yc
t = cu - dot(cu, zc) * zc;
yc = t ./ norm(t);

% the last coordinate is the cross product of the two coordinates
xc = cross(yc, zc);

% Since we have the coordinates, we just need to call the previous method
[P, D] = projectCamera(w, cv, xc, yc, p);

end