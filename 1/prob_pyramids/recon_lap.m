clc;
clear all;
close all;

im = rgb2gray(imread('data/cheetah.jpg'));
im = im2single(im);
N = 5;

[G, L] = pyramidsGL(im, N);

g{N} = L{N};


for i = N-1:-1:1
  g{i} = L{i} + imfilter(imresize(g{i+1},2),fspecial('gaussian',[4 4], 2));
 
end



subplot(1, 2, 1);
imshow(mat2gray(g{1}));

subplot(1, 2, 2);
imshow(mat2gray(im));