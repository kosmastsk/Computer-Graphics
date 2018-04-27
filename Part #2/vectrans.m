function d = vectrans(c, R)
%VECTRANS Transform a vector c by using a transform matrix R
%   Transform the coordinates c of a vector u by applying a vector 
%   transformation L with transform matrix R, size 3x3
%  
%   VARIABLES
%   c: 3x1 column with the coordinates of a vector u
%   R: 3x3 transformation matrix
%   d: transformed coordinates of the vector u

%% Apply the transformation

d = R * c;

end
