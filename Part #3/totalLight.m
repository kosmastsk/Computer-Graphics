function totalLight = totalLight(ka, Ia, Pc, Vn, kd, S, I0, C, ks, ncoeff)
%TOTALLIGHT Calculates the total light for a point
%   Using the functions ambientLight, diffuseLight, specularLight it
%   calculates the total light of a point P 
% > VARIABLES
% ka         : [kaR, kaG, kaB]', 3x1 vector with diffuse light factors: 0 < ka < 1
% Ia         : [IaR, IaG, IaB]', 3x1 vector with the intensity of diffuse light
%              radiation: 0 < Ia < 1
% Pc         : 3x1 vector with the coordinates of P
% N          : 3x1 vector with the coordinates of a unit vector which is vertical to
%              the surface on P. Direction to the viewer
% kd         : [kdR, kdG, kdB]', 3x1 vector with diffuse light factors: 0 < ka < 1
% S          : 3xn matrix, each column is the coordinates of the i-th light source
%              with 1 <= i <= n
% I0         : 3xn matrix, each column is the light insensity (RGB) of the i-th 
%              light source with 1 <= i <= n and each value is between 0 and 1
% C          : 3x1 column with the coordinates of the viewer
% ks         : [ksR, ksG, ksB]', 3x1 vector with diffuse light factors: 0 < ka < 1
% ncoeff     : Phong coefficient
% totalLight : insensity of 3-color total light

totalLight = zeros(3,1);

% calculate the ambient light
totalLight = totalLight + ambientLight(ka, Ia)';

% calculate the diffuse light
totalLight = totalLight + diffuseLight(Pc, Vn', kd', S, I0');

% calculate the specular light
totalLight = totalLight + specularLight(Pc, Vn', C,  ks', ncoeff, S, I0');

end

