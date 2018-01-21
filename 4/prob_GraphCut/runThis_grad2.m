% Add path

clear all;
close all;

addpath(genpath('GCmex1.5'));
im = im2double( imread('cat.jpg') );

org_im = im;

H = size(im, 1); W = size(im, 2); K = 3;

cform  = makecform('srgb2lab');
imgLab = applycform(im, cform);

%Separating RGB Components
img_r=imgLab(:,:,1);
img_g=imgLab(:,:,2);
img_b=imgLab(:,:,3);

img_rgb=[img_r(:) img_g(:) img_b(:)];


% Load the mask
load cat_poly
inbox = poly2mask(poly(:,1), poly(:,2), size(im, 1), size(im,2));
inbox_mask= reshape(inbox,W*H, 1);

foregnd_dx = inbox_mask' == 1;
backgnd_dx = inbox_mask' == 0;

foregnd_rgb = img_rgb(foregnd_dx,:);
backgnd_rgb = img_rgb(backgnd_dx,:);

fitgmdist_options=statset('Display','final');

prob_foregnd = zeros(size(img_rgb,1),3);
prob_backgnd = zeros(size(img_rgb,1),3);

% 1) Fit Gaussian mixture model for foreground regions
    
%for i=1:K
    foregnd= fitgmdist(foregnd_rgb, K, 'Options',fitgmdist_options);
    prob_foregnd(:,1)= pdf(foregnd,img_rgb);
    prob_foregnd=prob_foregnd(:,1);
%end


% 2) Fit Gaussian mixture model for background regions

%for i=1:K
    backgnd= fitgmdist(backgnd_rgb, K, 'Options',fitgmdist_options);
    prob_backgnd(:,1)= pdf(backgnd,img_rgb);
    prob_backgnd=prob_backgnd(:,1);
%end

% 3) Prepare the data cost
% - data [Height x Width x 2] 
% - data(:,:,1) the cost of assigning pixels to label 1
% - data(:,:,2) the cost of assigning pixels to label 2

prob_foregnd=reshape(prob_foregnd,size(im, 1),size(im, 2));
prob_backgnd=reshape(prob_backgnd,size(im, 1),size(im, 2));

data_cost(:,:,1) =  -log(prob_foregnd./prob_backgnd);
data_cost(:,:,2) =  -log(prob_backgnd./prob_foregnd);



% 4) Prepare smoothness cost
% - smoothcost [2 x 2]
% - smoothcost(1, 2) = smoothcost(2,1) => the cost if neighboring pixels do not have the same label
smoothcost = [0, 2; 10, 0];

sigma=5;
% 5) Prepare contrast sensitive cost
% - vC: [Height x Width]: vC = 2-exp(-gy/(2*sigma)); 
% - hC: [Height x Width]: hC = 2-exp(-gx/(2*sigma));
[gx, gy] = gradient(rgb2gray(im));

vC = 2-exp(-gy/(2*sigma)); 
hC = 2-exp(-gx/(2*sigma));

% 6) Solve the labeling using graph cut
% - Check the function GraphCut

[gch] = GraphCut('open',data_cost,smoothcost,vC,hC);
[gch labels] = GraphCut('expand', gch);
labels = ~labels;
% 7) Visualize the results

%For pasting the cat image on a new image

back_image = im2double( imread('park.jpg') );
back_image=imresize(back_image,[size(im, 1) size(im, 2)]);

new_image= back_image - back_image.* labels;
new_image= new_image + org_im.* labels;


imagesc(new_image);