function I = specularLight(P, N, C, ks, ncoeff, S, I0)
%SPECULARLIGHT Calculate the specular light
%   Calculates the the lights caused by specular reflection of a point P
% > VARIABLES
% P      : 3x1 vector with the coordinates of P
% N      : 3x1 vector with the coordinates of a unit vector which is vertical to
%          the surface on P. Direction to the viewer
% C      : 3x1 column with the coordinates of the viewer
% ks     : [ksR, ksG, ksB]', 3x1 vector with diffuse light factors: 0 < ka < 1
% ncoeff : Phong coefficient
% S      : 3xn matrix, each column is the coordinates of the i-th light source
%          with 1 <= i <= n
% I0     : 3xn matrix, each column is the light insensity (RGB) of the i-th 
%          light source with 1 <= i <= n and each value is between 0 and 1
% I      : [IR, IG, IB]', insensity of 3-color light that reflects from P 

n = size(S,2); % number of light sources
I = zeros(3,1);

V = C - P; % Calculate the vector between point P and viewer C
V = V / norm(V);

for i = 1 : n
    L = S(:,i) - P; % Calculate the vector between point P and the i-th source S
    L = L / norm(L); % make it unit vector

    RV = dot(2*N*dot(N,L) - L, V); % Calculate the R*V product

    Il = I0(:,i) .* ks .* RV^ncoeff;

    I = I + Il; % add to the total
end

end