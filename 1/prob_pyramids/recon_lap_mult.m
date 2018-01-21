clc;
clear all;
close all;

im = rgb2gray(imread('data/cheetah.jpg'));
im = im2single(im);
N = 5;

[G, L] = pyramidsGL(im, N);

g{N} = L{N};
gg{N} = L{N};


for i = N-1:-1:1
   g{i} = L{i} + imfilter(imresize(g{i+1},2),fspecial('gaussian',[4 4], 2));
 
end

 gg{4} = L{4} + imfilter(imresize(gg{5},2),fspecial('gaussian',[4 4], 2));
 gg{3} = (2*L{3}) + imfilter(imresize(gg{4},2),fspecial('gaussian',[4 4], 2));
 gg{2} = L{2} + imfilter(imresize(gg{3},2),fspecial('gaussian',[4 4], 2));
 gg{1} = L{1} + imfilter(imresize(gg{2},2),fspecial('gaussian',[4 4], 2));



subplot(1, 2, 1);
imshow(mat2gray(gg{1}));

subplot(1, 2, 2);
imshow(mat2gray(g{1}));