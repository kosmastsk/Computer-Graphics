%% demo3Gouraud.m
% This script demonstrates the creation of sample photos of the cat and
% show them
% Estimated running time: around 110 seconds

%% CLEAR
clear all;
close all;
clc;
tic
fprintf('\n *** begin %s ***\n\n', mfilename);

%% Load data
load('hw3.mat');

%% Draw the image
Im = Photo(1, f, C, K, u, bC, M, N, H, W, R, F, S, ka, kd, ks, ncoeff, Ia, I0);

imshow(Im);

toc