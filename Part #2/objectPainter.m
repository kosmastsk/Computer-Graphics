function I = objectPainter(V, C, F, D, painterType)
%OBJECTPAINTER Calling the proper function, depending on the painterType,
%to color the pixels inside the triangles
%   The order of painting occurs from the depth of each triangle
%   Initial format: RGB(1,1,1) canva, size:MxN (1150x1300)

% VARIABLES
% I: Coloured image MxNx3 which contains K coloured triangles
% V: Lx2 matrix with the coordinates of each triangles' vertices
% F: Kx3 matrix with the vertices of each triangle
% C: Lx3 matrix with the RGB color of each vertex
% D: Lx1 array with the depth of each vertex
% painterType: Control variable, string, Gouraud or Flat

%% INITIALIZATION
% Set the width and height of the canva
M = 1150;
N = 1300;

% Initialize the white canva
I = ones(M, N, 3);

%% DEPTH SORTING
% Create a new Kx1 matrix with the mean depth of each triangle
triangleD = zeros(length(F), 1);
for i = 1: length(F)
    triangleD(i) = mean(D(F(i, :)));
end

% Sort the triangles based on their depth
% First are the triangles in larger depth
[~, idx] = sort(triangleD, 'descend');
F = F(idx, :);

%% PAINTER TYPE
for t = 1 : length(triangleD)
    if strcmp(painterType, 'Flat')
        I = triPaintFlat(I, V(F(t, :), :), C(F(t, :), :));
    elseif strcmp(painterType, 'Gouraud')
        I = triPaintGouraud(I, V(F(t, :), :), C(F(t, :), :));
    else
        fprintf('*Painter type not found*\n\n');
    end
    % imshow(I)
end

%% TESTING with patch
% tic
% for k = 1 : 3954
%     patch( V(F(k,:),1) , V(F(k,:),2), mean( C(F(k,:),:) ) )
% end
% toc
% Elapsed time is 1.626998 seconds.

end