function Y = PhongShading(p, Vn, Pc, C, S, ka, kd, ks, ncoeff, Ia, I0, X)
%PHONGSHADING Calculate the color of the triangles with interpolation
%   Calculates the color in every point of the triangle by using
%   interpolation to the normal vectors and to the reflect factors of the
%   vertices
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

%% Calculate L and Vn
%TRIPAINTGOURAUD Apply a color to each triangle
%   The color that each triangle with get painted with, is calculated
%   as the linear interpolation of the color of its' vertices
% > VARIABLES
% X : Image with the some already existing triangles. MxNx3 matrix
% V : Integer array 3x2 that contains a column with coordinates for each
%     vertex of the triangle
% C : 3x3 matrix that contains a column with RGB values for each vertex.
% Y : MxNx3 matrix that contains for every part of the triangle, the RGB
%     values, as well as the pre-existing triangles of X
% Canva size: MxN

%% INITIALIZATION
% Create a bucket struct, where to save the information about each edge of
% the triangle
field1 = 'yMax';
field2 = 'yMin';
field3 = 'x';
field4 = 'sign';
field5 = 'dX';
field6 = 'dY';
field7 = 'sum';
field8 = 'normNV';
field9 = 'totLength';
field10 = 'startingNV';
field11 = 'xOfymin';
field12 = 'startingKa';
field13 = 'normKa';
field14 = 'startingKd';
field15 = 'normKd';
field16 = 'startingKs';
field17 = 'normKs';

% Copy to the output image, what has already been done
Y = X;

bucket = struct(field1, {}, field2, {}, field3, {}, field4, {}, field5, {}, field6, {}, field7, {}, field8, {}, field9, {}, field10, {}, field11, {}, field12, {}, field13, {}, field14, {}, field15, {}, field16, {}, field17, {});

% Create a struct for the Active List same as bucket. Empty in the beginning
activeList = struct(field1, {}, field2, {}, field3, {}, field4, {}, field5, {}, field6, {}, field7, {}, field8, {}, field9, {}, field10, {}, field11, {}, field12, {}, field13, {}, field14, {}, field15, {}, field16, {}, field17, {});

% The last edge is the same as the first one, since it is a closed polygon
p = p';
p(4, :) = p(1, :);
Vn(4, :) = Vn(1, :);
ka(4, :) = ka(1, :);
kd(4, :) = kd(1, :);
ks(4, :) = ks(1, :);

% Find the necessary data for the bucket struct
for k = 1 : 3
    % Seting yMax and yMin in the bucket by comparing the edges between
    % them
    ymax = max(p(k, 2), p(k + 1, 2));
    bucket(k).yMax = ymax;
 
    [ymin, yminIndex] = min([p(k, 2), p(k + 1, 2)]);
    bucket(k).yMin = ymin;
 
    % Set the dX and dY values, simply the difference of the coordinates
    bucket(k).dX = p(k, 1) - p(k + 1, 1);
    bucket(k).dY = p(k, 2) - p(k + 1, 2);
 
    % Set the slope. m = dY/dX
    % if m>0 slope is positive, else is negative
    m = bucket(k).dY / bucket(k).dX;
    if (bucket(k).dY == 0 || bucket(k).dX == 0)
        bucket(k).sign = 0;
    else
        bucket(k).sign = sign(m);
    end
 
    bucket(k).dX = abs(bucket(k).dX);
    bucket(k).dY = abs(bucket(k).dY);
 
    % Euklidean distance between the two vertices
    bucket(k).totLength = sqrt((bucket(k).dX) ^ 2 + (bucket(k).dY) ^ 2);

    % sum is initiated to zero
    bucket(k).sum = 0;
 
    % Normal vector of the vertex with the lowest y
    % x-axis of the vertex with the lowest y
    % Calculate the normalized NV that is the value that needs to be
    % added for every increment on the edge's side. Keep the sign of it
    % Initially, x and xOfymin is the same
    if yminIndex == 1
        bucket(k).x = p(k, 1);
        bucket(k).xOfymin = p(k, 1);
        bucket(k).startingNV = Vn(k, :);
        bucket(k).normNV = (Vn(k + 1, :) - Vn(k, :)) ./ bucket(k).totLength;
        bucket(k).startingKa = ka(k, :);
        bucket(k).normKa = (ka(k + 1, :) - ka(k, :)) ./ bucket(k).totLength;
        bucket(k).startingKd = kd(k, :);
        bucket(k).normKd = (kd(k + 1, :) - kd(k, :)) ./ bucket(k).totLength;
        bucket(k).startingKs = ks(k, :);
        bucket(k).normKs = (ks(k + 1, :) - ks(k, :)) ./ bucket(k).totLength;
    else
        bucket(k).x = p(k + 1, 1);
        bucket(k).xOfymin = p(k + 1, 1);
        bucket(k).startingNV = Vn(k + 1, :);
        bucket(k).normNV = (Vn(k, :) - Vn(k + 1, :)) ./ bucket(k).totLength;
        bucket(k).startingKa = ka(k + 1, :);
        bucket(k).normKa = (ka(k, :) - ka(k + 1, :)) ./ bucket(k).totLength;
        bucket(k).startingKd = kd(k + 1, :);
        bucket(k).normKd = (kd(k, :) - kd(k + 1, :)) ./ bucket(k).totLength;
        bucket(k).startingKs = ks(k + 1, :);
        bucket(k).normKs = (ks(k, :) - ks(k + 1, :)) ./ bucket(k).totLength;
    end
 
end

% The edges are maintained in ascending yMin order
[tmp ind] = sortrows([{bucket.yMin}']);
bucket = bucket(ind);

%% SCANLINE LIMITS
ymin = min([bucket.yMin]);
ymax = max([bucket.yMax]);

%% SCANNING
for y = ymin : 1 : ymax
 
    % Remove edges from the active list if ymax <= current scanline
    if (~ isempty(activeList))
        for i = 1 : length(activeList) %check every edge in the active list
         
            % Special case that we need to avoid.
            % i = 1, 2 items in AL. Remove one.
            % i goes 2, 1 item i    n AL. out of bounds
            if (i > length(activeList))
                continue;
            end
         
            if (activeList(i).yMax <= y)
                activeList(i) = []; % Remove the edge from the AL
            end
        end
    end
 
    % if y=ymin, add edge to active list
    for i = 1 : length(bucket)
        if (bucket(i).yMin == y)
            % add bucket to the end of the active list
            activeList(length(activeList) + 1) = bucket(i);
        end
    end
 
    % Sort the edges with ascending order of slope and x-axis position
    [tmp ind] = sortrows([{activeList.sign}']);
    activeList = activeList(ind);
 
    [tmp ind] = sortrows([{activeList.x}']);
    activeList = activeList(ind);
 
    % Special cases that I must not draw, but continue to the next
    % iteration
    if (isempty(activeList))
        continue;
    end
 
    if length(activeList) < 2
        continue;
    end
 
    % Case of a horizontal line and need to change the bucket's data
    if (size(activeList) == 3)
        activeList(2).x = activeList(3).x;
    end
 
    % Linear interpolation to find the color in the active limits
    % Prepare the findColor function inputs
    a = activeList(1).x;
    b = activeList(2).x;
    currentDistance1 = pdist([activeList(1).xOfymin, activeList(1).yMin; a, y], 'euclidean');
    currentDistance2 = pdist([activeList(2).xOfymin, activeList(2).yMin; b, y], 'euclidean');
    NVA = activeList(1).startingNV + (currentDistance1 * activeList(1).normNV);
    NVB = activeList(2).startingNV + (currentDistance2 * activeList(2).normNV);
    kaA = activeList(1).startingKa + (currentDistance1 * activeList(1).normKa);
    kaB = activeList(2).startingKa + (currentDistance2 * activeList(2).normKa);
    
    kdA = activeList(1).startingKd + (currentDistance1 * activeList(1).normKd);
    kdB = activeList(2).startingKd + (currentDistance2 * activeList(2).normKd);
    
    ksA = activeList(1).startingKs + (currentDistance1 * activeList(1).normKs);
    ksB = activeList(2).startingKs + (currentDistance2 * activeList(2).normKs);
    
    % Coloring the pixels
    for x = a : 1 : b
        % interpolate normal vector
        nvInt = interpolate(x, a, b, NVA, NVB);
        
        % interpolate ks kd ka
        kaInt = interpolate(x, a, b, kaA, kaB);
        
        kdInt = interpolate(x, a, b, kdA, kdB);
        
        ksInt = interpolate(x, a, b, ksA, ksB);

        % find light with three functions
        Y(y, x, :) = totalLight(kaInt, Ia, Pc, nvInt, kdInt, S, I0, C, ksInt, ncoeff);
    end
 
    % Increment x variable of buckets based on slope
    for j = 1 : length(activeList)
        % If edge's slope is vertical, next iteration
        if activeList(j).sign == 0
            continue;
        end
     
        if activeList(j).dX ~= 0
            activeList(j).sum = activeList(j).sum + activeList(j).dX;
            while (activeList(j).sum >= activeList(j).dY)
                activeList(j).x = activeList(j).x + activeList(j).sign; % Increase or decrease x, depending on slope
                activeList(j).sum = activeList(j).sum - activeList(j).dY;
            end
        end
    end
end

end