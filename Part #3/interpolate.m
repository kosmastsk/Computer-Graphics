function value = interpolate(x, a, b, CA, CB)
%INTERPOLATE Apply linear interpolation
%   Calculate the value of a color/factor/etc of a point, with reference to the edge it belongs
%   and use linear interpolation to find it

%% VARIABLES
% x: x-axis value of the point we want to color
% a, b: x-axis value of the active limit points of the current scanline 
% CA, CB: the values of a and b

%% LINEAR INTERPOLATION
% Distances
ab = (b - a); % Total length
ax = (x - a);

% Calculate the color
if a ~= b
    value = (((CB - CA) ./ ab ) .* ax) + CA;
else 
    % if a == b then the color occurs 0(black), so the mean gives better
    % results
    value = (CA + CB) ./ 2;
end