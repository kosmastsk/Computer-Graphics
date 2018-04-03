function Y = triPaintFlat(X, V, C)
%TRIPAINTFLAT Apply a color to each triangle
%   The color that each triangle with get painted with, is calculated
%   as the mean of the color of its' vertices

%% VARIABLES
% X: Image with the some already existing triangles. MxNx3 matrix
% V: Integer array 3x2 that contains a column with coordinates for each
% vertex of the triangle
% C: 3x3 matrix that contains a column with RGB values for each vertex.
% Y: MxNx3 matrix that contains for every part of the triangle, the RGB
% values, as well as the pre-existing triangles of X
% Canva size: MxN

%% SAMPLE DATA for testing
% Y = ones(1150, 1300, 3);
%
% V = [1083, 336;
%     1061, 359;
%     1082, 336];
%
% C = [0.5686,0.4471,0.3333;
%     0.6667,0.5412,0.3647;
%     0.7098,0.5804,0.4745];

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

% Copy to the output image, what has already been done
Y = X;

bucket = struct(field1, {}, field2, {}, field3, {}, field4, {}, field5, {}, field6, {}, field7, {});

% Create a struct for the Active List same as bucket. Empty in the beginning
activeList = struct(field1, {}, field2, {}, field3, {}, field4, {}, field5, {}, field6, {}, field7, {});

% The last vertex is the same as the first one, since it is a closed polygon
V(4, :) = V(1, :);

% Find the necessary data for the bucket struct
% Need to find: yMax, yMin, x, sign of slope, dX, dY, sum
for k = 1 : 3
    % Setting yMax and yMin in the bucket by comparing the edges between
    % them
    ymax = max(V(k, 2), V(k + 1, 2));
    bucket(k).yMax = ymax;
 
    ymin = min(V(k, 2), V(k + 1, 2));
    bucket(k).yMin = ymin;
 
    % x initially starting at the same point where the yMin of the edge is
    if (V(k, 2) < V(k + 1, 2))
        bucket(k).x = V(k, 1);
    else
        bucket(k).x = V(k + 1, 1);
    end
 
    % Set the dX and dY values, just the difference of the coordinates
    bucket(k).dX = V(k, 1) - V(k + 1, 1);
    bucket(k).dY = V(k, 2) - V(k + 1, 2);
 
    % Set the slope. m = dY/dX
    % if m>0 slope is positive, else is negative
    m = bucket(k).dY / bucket(k).dX;
    bucket(k).sign = sign(m);
 
    bucket(k).dX = abs(bucket(k).dX);
    bucket(k).dY = abs(bucket(k).dY);
 
    % sum is initiated to zero
    bucket(k).sum = 0;
end

% The edges are maintained in ascending yMin order
[tmp ind] = sortrows([{bucket.yMin}']);
bucket = bucket(ind);

%% SCANLINE LIMITS
ymin = min([bucket.yMin]);
ymax = max([bucket.yMax]);

%% COLOR FLAT VALUE [RGB]
color = mean(C);

%% SCANNING
for y = ymin : 1 : ymax
 
    % Remove edges from the active list if ymax <= current scanline
    if (~ isempty(activeList))
        for i = 1 : length(activeList) %check every edge in the active list
         
            % Special case that we need to avoid.
            % i = 1, 2 items in AL. Remove one.
            % i goes 2, 1 item in AL. out of bounds
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
 
    % Coloring the pixel
    for x = activeList(1).x : 1 : activeList(2).x
        % Here I use y,x, because imshow is kind of rotated comparing
        % to the coordinate system that this function is using
        Y(y, x, :) = color;
    end
 
    % Increment x variable of buckets based on slope
    for j = 1 : length(activeList)
        % If edge's slope is vertical, next iteration
        if (activeList(j).dY == 0)
            continue;
        end
        if activeList(j).dX ~= 0
            activeList(j).sum = activeList(j).sum + activeList(j).dX;
            while (activeList(j).sum >= activeList(j).dY)
                if activeList(j).dY ~= 0
                    activeList(j).x = activeList(j).x + activeList(j).sign; % Increase or decrease x, depending on slope
                    activeList(j).sum = activeList(j).sum - activeList(j).dY;
                end
            end
        end
    end
end
%% END OF FUNCTION
end