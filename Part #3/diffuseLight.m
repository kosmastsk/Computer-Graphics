function I = diffuseLight(P, N, kd, S, I0)
%DIFFUSELIGHT Calculates the diffuse light
%   Calculates the light caused by diffused reflection of a point P
% > VARIABLES
% P  : 3x1 vector with the coordinates of P
% N  : 3x1 vector with the coordinates of a unit vector which is vertical to
%      the surface on P. Direction to the viewer
% kd : [kdR, kdG, kdB]', 3x1 vector with diffuse light factors: 0 < ka < 1
% S  : 3xn matrix, each column is the coordinates of the i-th light source
%      with 1 <= i <= n
% I0 : 3xn matrix, each column is the light insensity (RGB) of the i-th 
%      light source with 1 <= i <= n and each value is between 0 and 1
% I  : [IR, IG, IB]', insensity of 3-color light that reflects from P 

n = size(S,2); % number of light sources
I = zeros(3,1);
% For each light source, calculate the I and add it to the total one
for i = 1 : n

    % Calculate the distance between point P and the i-th light source S
    d = sqrt( sum( (S(:,i) - P).^2 ) );

    fatt = 1 / (d^2); % attenuation factor

    L = S(:,i) - P; % Calculate the vector between point P and the i-th source S
    L = L / norm(L);
    
    Il = I0(i,:) .*  fatt .* kd .* dot(N, L); % Light for i-th source

    I = I + Il; % add to the total
end

end

