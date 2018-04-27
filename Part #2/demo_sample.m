clc;
clear;

% Step 0
load('cat3d.mat');
% TODO Call plotObj to plot initial cat


%% Step 1 - Translate with t1
t1 = [-1, -1, 3]';

% TODO Perform transformation

% TODO Call plotObj to view result

%% Step 2 - Rotate
theta = pi/4;
g = [0, 1, 0]'; % Parallel vector for rot axis
K = [0, 0, 0]'; % Passing point for rot axis

% TODO Perform transformation

% TODO Call plotObj to view result

%% Step 3 - Translate back
t2 = [1, 1, -3]';

% TODO Perform transformation

% TODO Call plotObj to view result


%% Step 4 - Project to camera
cv = [9.8031, 9.8568, 0.9894]';
cx = [0.7965, -0.6046, 0]';
cy = [-0.0464, -0.0611, 0.9971]';
w = 1;

% TODO Perform projection

% TODO Call ObjectPainter to produce I 

% TODO Plot I


%% Step 5 - Project to camera using camera vectors
cv = [5.6737, -2.6957, 11.0840]';
ck = [2.6696, 0.4589, 0.0815]';
cu = [0, 0, 1]';
w = 1;

% TODO Perform projection

% TODO Call ObjectPainter to produce I

% TODO Plot I