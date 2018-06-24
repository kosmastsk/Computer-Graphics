function Normals = VertNormals(R, F)
%VERTNORMALS Calculate the normal vectors' coordinates
%   For each vertex of the 3D object, it calculates the coordinates of the
%   normal vectors
% > VARIABLES
% R       : 3xr matrix with the coordinates of r vertices of the object
% F       : 3xT matrix that describes the triangles. The k-th column of F
%           contains the index numbers of the vertices of the k-th triangle, 1<=k<=T
% Normals : Coordinates of the normal vectors

r = size(R, 2); % number of vertices of the object
T = size(F, 1); % number of triangles that consist the object

% Create an array to save the normal vector of each triangle
trNV = zeros(3,T);
for i = 1 : T 
    % The three vertices of the triangle
    vert1 = R(:, F(i,1));
    vert2 = R(:, F(i,2));
    vert3 = R(:, F(i,3));
    V = vert1 - vert2;
    W = vert1 - vert3;
        
    N = cross(V, W); % Calculate the cross product which is the vector with the right direction
    trNV(:,i) = N ./ norm(N); 
end

%Create an array to save the normal vector of each vertex
Normals = zeros(3, r);
for i = 1 : T % for each triangle
    for j = 1 : 3 % for each vertex of the triangle
        Normals(:, F(i, j)) = Normals(:, F(i, j)) + trNV(:, i);
    end
end

Normals = Normals ./ norm(Normals);