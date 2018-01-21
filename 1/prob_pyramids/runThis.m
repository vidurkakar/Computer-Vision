clear all;
close all;
clc;
%function [G, L] = pyramidsGL(im, N)


% [G, L] = pyramidsGL(im, N)
% Creates Gaussian (G) and Laplacian (L) pyramids of level N from image im.
% G and L are cell where G{i}, L{i} stores the i-th level of Gaussian and Laplacian pyramid, respectively. 
im = rgb2gray(im2single(imread('data/cheetah.jpg')));
N=5;

[G, L] = pyramidsGL(im, N);


%function displayPyramids(G, L)
% Displays intensity and fft images of pyramids
displayPyramids(G,L);


%end

%display_FFT_Pyramids(G,L);

