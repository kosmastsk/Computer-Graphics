%% demo2.m
% This script demonstrates the transformation and projection method
% Estimated running time: around 180 seconds

%% CLEAR
clear all;
close all;
clc;
tic
fprintf('\n *** begin %s ***\n\n', mfilename);

%% Step 0
fprintf('\n *** Step 0 ***\n\n');
load('cat3d.mat');

% Call plotObj to plot initial cat
figure;
plotObj(V', C, F);
title('Step 0 - Initial cat');

%% Step 1 - Translate with t1
fprintf('\n *** Step 1 - Translate with t1 ***\n\n');
t1 = [-1, -1, 3]';

% Perform transformation
V = V + repmat(t1', size(V,1), 1);

% Call plotObj to view result
figure;
plotObj(V', C, F);
title('Step 1 - Translate with t1');

%% Step 2 - Rotate
fprintf('\n *** Step 2 - Rotate ***\n\n');
theta = pi/4;
g = [0, 1, 0]'; % Parallel vector for rot axis
K = [0, 0, 0]'; % Passing point for rot axis

% Perform transformation
% Rotation matrix
R = rotmat(theta, g);
V = vectrans(V', R);
    
% Call plotObj to view result
figure;
plotObj(V, C, F);
title('Step 2 - Rotate');

%% Step 3 - Translate back
fprintf('\n *** Step 3 - Translate back ***\n\n');

t2 = [1, 1, -3]';

% Perform transformation
V = V' + repmat(t2', size(V,2), 1);

% Call plotObj to view result
figure;
plotObj(V', C, F);
title('Step 3 - Translate back');

%% Step 4 - Project to camera
fprintf('\n *** Step 4 - Project to camera ***\n\n');

cv = [9.8031, 9.8568, 0.9894]';
cx = [0.7965, -0.6046, 0]';
cy = [-0.0464, -0.0611, 0.9971]';
w = 1;

% Perform projection
[P, D] = projectCamera(w, cv, cx, cy, V);
P = P'; % transpose to be compatible with the function
D = D';

% Call ObjectPainter to produce I 
I = objectPainter(P, C, F, D, 'Gouraud');

% Plot I
figure;
imshow(I);
title('Step 4 - Project to camera');

%% Step 5 - Project to camera using camera vectors
fprintf('\n *** Step 5 - Project to camera using camera vectors ***\n\n');

cv = [5.6737, -2.6957, 11.0840]';
ck = [2.6696, 0.4589, 0.0815]';
cu = [0, 0, 1]';
w = 1;

% Perform projection
[P, D] = projectKu(w, cv, ck, cu, V);
P = P';
D = D';

% Call ObjectPainter to produce I
I = objectPainter(P, C, F, D, 'Gouraud');

% Plot I
figure;
imshow(I);
title('Step 5 - Project to camera using camera vectors');

toc