function h = plotObj(V, C, F)
%plotObj Plot a 2d or 3d object
%   plotObj(V,C,F,D) plots the object defined 
%   by the following parameters:

%   V: 3xL (or 2xL) matrix containing the coordinates
%   of L vertices of the triangles that 
%   comprise the object
%
%   C: Lx3 matrix whose rows contain the color (in RGB)
%   of each vertex
%
%   F: Kx3 matrix that contains the triangle definitions
%   of the object. The i-th row contains the
%   indexes of the points (given in V), that constitute
%   the i-th triangle of the object
%

% If input is in homegenous coordinates convert it
if size(V, 1) == 4
    V = V(1:3, :);
end

close all;
h = patch('Faces', F, 'Vertices', V', 'FaceVertexCdata',C,'facecolor','interp','edgecolor','none'); 
axis equal;

% cv = campos
% ck = camtarget
% cu = camup
cv = [0.0019, 0.4589, 24.5259]';
ck = [0.0019, 0.4589, 0.3073]';
cu = [0, 1, 0]';
campos(cv);
camtarget(ck);
camup(cu);
end

