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

% Change the coordinate system of p from WCS to CCS 
dp = systemtrans(p, cx, cy, w, cv);

% Calculate the x and y coordinates of the projection
P(1,:) = dp(1,:) ./ dp(3,:);
P(2,:) = dp(2,:) ./ dp(3,:);

% The depth is estimated with the z coordinate
D(1,:) = dp(3,:);

end

