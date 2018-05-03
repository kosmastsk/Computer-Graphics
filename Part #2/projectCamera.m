function [P, D] = projectCamera(w, cv, cx, cy, p)
%PROJECTCAMERA Calculate the projection of the 3D points
%   Having a projection camera, calculate the projection points of a point
%   in the 3D world and its depth.
%   
%   VARIABLES
%   w  : distance between the screen and the centre
%   cv : coordinates of the shifting vector vc
%   cx : coordinate of cx
%   cy : coordinate of cy
%   p  : 3xn column with coordinates of n points
%   P  : 2xn array for saving the projection
%   D  : 1xn array for saving the depth of each point

%% Calculations
% Calculate cz as the cross product of cx and cy
cz = cross(cx, cy);

% Change the coordinate system of p from WCS to CCS 
dp = systemtrans(p, cx, cy, cz, cv);

% Calculate the projection of each point
for i = 1 : size(p,1)
    if dp(3,i) > 0 % Check what is visible
        P(1,i) = - w * dp(1,i)/dp(3,i); % x points
        P(2,i) = - w * dp(2,i)/dp(3,i); % y points
        % The depth is equal to the z coordinate
        D(1,i) =  - w * dp(3,i);
    end
end

end