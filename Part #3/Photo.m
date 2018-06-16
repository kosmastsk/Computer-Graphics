function Im = Photo(shader, f, C, K, u, bC, M, N, H, W, R, F, S, ka, kd, ks, ncoeff, Ia, I0)
%PHOTO Creates the colored image of a 3D object
%   Create the colored image of a 3D object, by calculating the color using
%   the light models of other functions
% > VARIABLES
% shader : boolean variable. 1 means Gouraud shading, 2 means Phong shading
% f      : distance of the screen and the centre in CCS
% C      : 3x1 vector with the coordinates of camera's centre
% K      : 3x1 vector with the coordinates of target point K
% u      : 3x1 unit up vector of camera
% bC     : 3x1 vector with the color of the background
% M, N   : dimension of the created image in pixels
% H, W   : physical dimension of the camera's screen
% R      : 3xr matrix with the coordinates of r vertices of the object
% F      : 3xT matrix that describes the triangles. The k-th column of F
% S      : 3xn matrix, each column is the coordinates of the i-th light source
%          with 1 <= i <= n
% ka     : [kaR, kaG, kaB]', 3xr vector with diffuse light factors: 
%          0 < ka < 1, 1 <= i <= r
% kd     : [kdR, kdG, kdB]', 3xr vector with diffuse light factors: 0 < ka < 1
% ks     : [ksR, ksG, ksB]', 3xr vector with diffuse light factors: 0 < ka < 1
% ncoeff : Phong coefficient
% Ia     : [IaR, IaG, IaB]', 3x1 vector with the intensity of diffuse light
%          radiation: 0 < Ia < 1
% I0     : 3xn matrix, each column is the light insensity (RGB) of the i-th 
%          light source with 1 <= i <= n and each value is between 0 and 1
% Im     : MxN array that contains the image

Im = zeros(M, N); % Create the canva for the image that we will create

%% Calculate the normal vectors for every vertex
Normals = VertNormals(R, F);

%% Project each triangle's vertices in an orthogonial screen of a camera
% If a a vertex is out of the screen, the triangle will not get colored 
% [P, D] = projectKu(w, cv, ck, cu, p)
[P, D] = projectKu(f, C, K, u, R);

%% Call the color filling function, depending on shader value
% DEPTH SORTING
% Create a new Kx1 matrix with the mean depth of each triangle
triangleD = zeros(length(F), 1);
for i = 1: length(F)
    triangleD(i) = mean(D(F(i, :)));
end

% Sort the triangles based on their depth
% First are the triangles in larger depth
[~, idx] = sort(triangleD, 'descend');
F = F(idx, :);

% Painter type
for t = 1 : length(F)
    if shader == 1
        Y = GouraudShading(p, Vn, Pc, C, S, ka, kd, ks, ncoeff, Ia, I0, X);
%         coords = pointtrans(V(F(t, :), :), eye(3)*10^4, translate);
%         I = triPaintGouraud(I, floor(coords), C(F(t, :), :));
    elseif shader == 2
        Y = PhongShading(p, Vn, Pc, C, S, ka, kd, ks, ncoeff, Ia, I0, X);
    else
        fprintf('*Painter type not found*\n\n');
    end
    % imshow(I)
end


end

