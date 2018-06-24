function I = ambientLight(ka, Ia)
%AMBIENTLIGHT Calculates the ambient light
%   Calculates the light because of the diffused light of the environment
%   of a point P with diffuse light factor ka
% > VARIABLES
% ka : [kaR, kaG, kaB]', 3x1 vector with diffuse light factors: 0 < ka < 1
% Ia : [IaR, IaG, IaB]', 3x1 vector with the intensity of diffuse light
%      radiation: 0 < Ia < 1
% I  : [IR, IG, IB]', insensity of 3-color light that reflects from P

I = Ia .* ka;

end