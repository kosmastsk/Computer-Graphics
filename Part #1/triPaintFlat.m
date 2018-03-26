function Y = triPaintFlat(X, V, C)
%TRIPAINTFLAT Apply a color to each triangle
%   The color that each triangle with get painted with, is calculated
%   as the mean of the color of its' edges

%% VARIABLES
% X: Image with the some already existing triangles. MxNx3 matrix
% V: Integer array 3x2 that contains a column with coordinates for each
% edge of the triangle
% C: 3x3 matrix that contains a column with RGB values for each edge.
% Y: MxNx3 matrix that contains for every part of the triangle, the RGB
% values, as well as the pre-existing triangles of X
% Suppose canva size: MxN

%% INITIALIZE

% Calculate color value in RGB, as the mean value
color = mean(C);

% Using the edge's value, paint the pixels inside


end