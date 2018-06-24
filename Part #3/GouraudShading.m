function Y = GouraudShading(p, Vn, Pc, C, S, ka, kd, ks, ncoeff, Ia, I0, X)
%GOURAUDSHADING Calculates the color of a triangle's vertices using Gouraud
%   Calculate the color in each vertex, using the full light model and the
%   apply linear interpolation for the pixels inside 
% > VARIABLES
% p      : 2x3 matrix with the coordinates of the vertices projection
% Vn     : 3x3 matrix that contains in its columns the normal vectors of the vertices
% Pc     : 3x1 vector contains the mean weight the triangle, before projection
% C      : 3x1 column with the coordinates of the viewer
% S      : 3xn matrix, each column is the coordinates of the i-th light source
%          with 1 <= i <= n
% ka     : [kaR, kaG, kaB]', 3x3 vector with diffuse light factors: 
%          0 < ka < 1, 1 <= i <= 3 (i for vertex)
% kd     : [kdR, kdG, kdB]', 3x3 vector with diffuse light factors: 0 < ka < 1
% ks     : [ksR, ksG, ksB]', 3x3 vector with diffuse light factors: 0 < ka < 1
% ncoeff : Phong coefficient
% Ia     : [IaR, IaG, IaB]', 3x1 vector with the intensity of diffuse light
%          radiation: 0 < Ia < 1
% I0     : 3xn matrix, each column is the light insensity (RGB) of the i-th 
%          light source with 1 <= i <= n and each value is between 0 and 1
% X      : MxNx3 matrix that is the image with preexisting triangles
% Y      : MxNx3 matrix that contains the color for each point of the
%          triangle and preexisting triangles

%% Color calculation
Color = zeros(3,3);
% For each vertex, calculate the ambient light
for i = 1 : 3
    Color(:,i) = Color(:,i) + ambientLight(ka(:, i)', Ia)';
end

% For each vertex calculate the diffuse light
for i = 1 : 3
    Color(:,i) = Color(:,i) + diffuseLight(Pc, Vn(:, i), kd(:,i), S, I0');
end

% For each vertex calculate the specular light
for i = 1 : 3
    Color(:,i) = Color(:,i) + specularLight(Pc, Vn(:, i), C,  ks(:,i), ncoeff, S, I0');
end

%% Apply color
Y = triPaintGouraud(X, p', Color);

end