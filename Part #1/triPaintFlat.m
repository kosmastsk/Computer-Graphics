% function Y = triPaintFlat(X, V, C)
%TRIPAINTFLAT Apply a color to each triangle
%   The color that each triangle with get painted with, is calculated
%   as the mean of the color of its' vertices
clear all
close all

%% VARIABLES
% X: Image with the some already existing triangles. MxNx3 matrix
% V: Integer array 3x2 that contains a column with coordinates for each
% vertex of the triangle
% C: 3x3 matrix that contains a column with RGB values for each vertex.
% Y: MxNx3 matrix that contains for every part of the triangle, the RGB
% values, as well as the pre-existing triangles of X
% Canva size: MxN

%% DUMMY DATA
I = ones(1150, 1300, 3);

V = [1083, 400;
    1080, 363;
    1077, 379];

C = [0.5686,0.4471,0.3333;
    0.6667,0.5412,0.3647;
    0.7098,0.5804,0.4745];

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

bucket = struct(field1, {}, field2, {}, field3, {}, field4, {}, field5, {}, field6, {}, field7, {});

% Create a struct for the Active List same as bucket. Empty in the beginning
activeList = struct(field1, {}, field2, {}, field3, {}, field4, {}, field5, {}, field6, {}, field7, {});

% When creating edges, the vertices of the edge need to be ordered from left to right
% Sorting based on the x-value
[~, idx] = sort(V(:,1));
V = V(idx, :);

% The last edge is the same as the first one, since it is a closed polygon
V(4,:) = V(1,:);

% Find the necessary data for the bucket struct
% Need to find: yMax, yMin, x, sign of slope, dX, dY, sum
for k=1:3
    % Setting yMax and yMin in the bucket by comparing the edges between
    % them
    ymax = max(V(k,2), V(k+1,2));
    bucket(k).yMax = ymax;
    
    ymin = min(V(k,2), V(k+1,2));
    bucket(k).yMin = ymin;
    
    % x initially starting at the same point as the yMin of the edge
    if (V(k,2) < V(k+1,2))
        bucket(k).x = V(k,1);
    else
        bucket(k).x = V(k+1,1);
    end
    
    % Set the dX and dY values, simply the difference of the coordinates
    bucket(k).dX = V(k,1) - V(k+1,1);
    bucket(k).dY = V(k,2) - V(k+1,2);
    
    % Set the slope. m = dY/dX
    % if m>0 slope is positive, else is negative
    m = bucket(k).dY / bucket(k).dX;
    bucket(k).sign = sign(m);
    
    % sum is initiated to zero
    bucket(k).sum = 0;
    
end

% The edges are maintained in increasing yMin order
[tmp ind] = sortrows([{bucket.yMin}']);
bucket = bucket(ind);

%% SCANLINE LIMITS
ymin = min([bucket.yMin]); 
ymax = max([bucket.yMax]); 

%% COLOR FLAT VALUE [RGB]
color = mean(C);

%% SCANNING
for y = ymin : 1 : ymax

%     while (~isempty(bucket))

        % Remove edges from the active list if y=ymax
        if (~isempty(activeList))
            for i = 1 : length(activeList) %iteration throught the edges in the active list
                % Special case that we need to avoid.
                % i = 1, 2 items in AL. Remove one.
                % I goes 2, 1 item in AL. out of bounds
                if (i > length(activeList))
                    continue;
                end
                if (activeList(i).yMax == y)
                    activeList(i) = [];
%                     bucket(activeList(i).edgeID) = {};
                end
            end
        end
        
        % if y=ymin, add edge to active list
        for i = 1 : length(bucket) % iterate through every edge
            if (bucket(i).yMin == y)
                % add bucket to active list
                activeList(length(activeList)+1) = bucket(i);
            end
        end
        
        % Sort active list by x position
        [tmp ind] = sortrows([{activeList.x}']);
        activeList = activeList(ind);
        
        % Coloring the pixel
        for x = activeList(1).x : 1 : activeList(length(activeList)).x
            I(x, y, :) = color;
        end
        
        % Increment x variable of buckets based on slope
        for j = 1 : length(activeList)
            if activeList(j).dX ~= 0
                activeList(j).sum = (activeList(j).sum + 1/activeList(j).dX);
                while (activeList(j).sum >= activeList(j).dY)
                    activeList(j).x = floor(activeList(j).x - (1/activeList(j).sum));
                    activeList(j).sum = activeList(j).sum - sign(activeList(j).dY)*(activeList(j).dY);
                end
            end
        end

end
% I(1083,400,:) = 0;
% I(1080, 363,:) = 0;
% I(1077, 379,:) = 0;

imshow(I)

%% TESTING
% tic
% for k = 1 : 3954
%     patch( V(F(k,:),1) , V(F(k,:),2), mean( C(F(k,:),:) ) )
% end
% toc
% Elapsed time is 1.626998 seconds.

% end