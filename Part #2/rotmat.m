function R = rotmat(theta, u)
%ROTMAT Calculates the rotation matrix R 
%   Rotation through an angle theta with a rotation axis that is parallel
%   to the u vector and (0,0) belongs to it
%
%   VARIABLES
%   theta: rotation angle in rad
%   u    : 3x1 coordinates of a unit vector
%   R    : rotation map

%% Apply the rodrigues' formula
% In order to be a rotation matrix, must be true that:
% i)  R * transpose(R) == transpose(R) * R = I
% ii) det(R) = +1

R = [
    (1-cos(theta))*(u(1))^2 + cos(theta),       (1-cos(theta))*u(1)*u(2) - sin(theta)*u(3), (1-cos(theta))*u(1)*u(3) + sin(theta)*u(2);
    (1-cos(theta))*u(2)*u(1) + sin(theta)*u(3), (1-cos(theta))*(u(2))^2 + cos(theta),       (1-cos(theta))*u(2)*u(3) - sin(theta)*u(1);
    (1-cos(theta))*u(3)*u(1) - sin(theta)*u(2), (1-cos(theta))*u(3)*u(2) + sin(theta)*u(1), (1-cos(theta))*(u(3))^2 + cos(theta)      
    ];

end

