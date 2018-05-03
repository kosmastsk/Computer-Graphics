function color = findColor(x, a, b, CA, CB)
%FINDCOLOR Calculate a color with linear interpolation
%   Calculate the color of a point, with reference to the edge it belongs
%   and use linear interpolation for it's value

%% VARIABLES
% x: x-axis value of the point we want to color
% a, b: x-axis value of the active limit points of the current scanline 
% CA, CB: the color values of a and b 

%% LINEAR INTERPOLATION
% Distances
ab = (b - a); % Total length
ax = (x - a);

% Calculate the color
if a ~= b
    color = (((CB - CA) / ab ) * ax) + CA;
else 
    % if a == b then the color occurs 0(black), so the mean gives better
    % results
    color = (CA + CB) / 2;
end