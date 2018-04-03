%% demoGouraud.m
% This script demonstrates the triangle filling algorithm by using the
% Gouraud method
% Estimated running time: 90-100 seconds

%% CLEAR
clear all;
close all;

%% BEGIN
tic
fprintf('\n *** begin %s ***\n\n',mfilename);

%% READ DATA
fprintf('Reading data\n')

try 
    load('cat.mat');
    fprintf('Reading data completed\n\n');
catch 
    fprintf('Error loading cat.mat file\n\n');
end
% C, D, F, V variables now exist in the workspace

%% FILLING
fprintf('*objectPainter is now running.......*\n\n');
image = objectPainter(V, C, F, D, 'Gouraud');

%% RESULT
imshow(image);

%% END
toc
fprintf('\n *** end %s ***\n\n',mfilename);

%% ------------------------------------------------------------
%
% AUTHOR
% 
%   Kosmas Tsiakas          kosmastsk@gmail.com
% 
%   March 2018