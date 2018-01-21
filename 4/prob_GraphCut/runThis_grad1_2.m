% Add path
clear all;
close all;
addpath(genpath('GCmex1.5'));
im = im2double( imread('sign_board.jpg') );

org_im = im;

H = size(im, 1); W = size(im, 2); K = 3;

cform  = makecform('srgb2lab');
imgLab = applycform(im, cform);

%Separating RGB Components
img_r=imgLab(:,:,1);
img_g=imgLab(:,:,2);
img_b=imgLab(:,:,3);

img_rgb=[img_r(:) img_g(:) img_b(:)];


%Define The Poly Mask for the image
%poly=[58,234; 792,241; 867,276; 905,372; 926,435; 920,508; 60,502; 60,346];

%poly=[ 189,650;395,641;654,609;767,565;883,495;1137,501;1313,519;1433,565;1657,599;1677,793;1637,891;1545,905;1435,945;1279,911;635,921;497,951;377,919;217,909;205,749];
%245,701;
%poly=[399,12;797,13;797,768;405,568];

%poly=[145,227;185,200;197,143;177,98;127,73;65,86;39,149;72,213];

poly=[305,117;449,120;453,63;678,66;677,395;301,399];

%poly=[65,77;283,88;284,34;353,34;361,92;554,98;562,179;416,198;419,474;451,506;457,560;199,564;202,488;226,192;100,150];

%poly=[196,300;159,74;174,21;270,29;272,300];

inbox = poly2mask(poly(:,1), poly(:,2), size(im, 1), size(im,2));
inbox_mask= reshape(inbox,W*H, 1);

%Bounding Box Code
% e=edge(inbox,'canny');
% red_image=zeros(size(im, 1),size(im, 2),3);
% red_image(1:size(im, 1),1:size(im, 2),1)=1;
% new_image=zeros(size(im, 1),size(im, 2),3);
% new_image(:,:,1)=red_image(:,:,1).*double(e);
% new_image = org_im.*(~e) + new_image .*e;
% imagesc(new_image);


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
smoothcost = [0, 1; 1000, 0];

sigma=10;
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


%for i=1:3
 %   new_image(:,:,i)=org_im(:,:,i).*double(labels);
%end


% For blue background
blue_image=zeros(size(im, 1),size(im, 2),3);
blue_image(1:size(im, 1),1:size(im, 2),3)=1;

new_image(:,:,3)=blue_image(:,:,3).*double(~labels);
new_image = new_image + org_im .* labels;

imagesc(new_image);