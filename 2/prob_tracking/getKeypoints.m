function [keyXs, keyYs] = getKeypoints(im, tau)
% Detecting keypoints using Harris corner criterion  

% im: input image
%im=imread('images/hotel.seq50.png');
%im_temp=im;
% tau: threshold;
%threshold=5;

% keyXs, keyYs: detected keypoints, with dimension [Number of keypoints] x [2]

%dervitaved in x and y direction (Gradients)
%[dx,dy]=meshgrid(-1:1 , -1:1);

%Ix=conv2(double(im),dx,'same');
%Iy=conv2(double(im),dy,'same');

%im = double(im(:,:,1));

%[dx,dy]=meshgrid(-1:1 , -1:1);
%[Ix,Iy] = gradient(im);
Ix=imfilter(im,[1 0 -1]);
Iy=imfilter(im,[1 0 -1]');

sigma=1;

K=sigma;
radius=2;
order = (2*radius +1);
[x, y] = meshgrid(-K:K, -K:K);

%Create Gausian Filter Kernel
G = exp(-(x.^2 - y.^2)/(2*sigma^2));     
[a,b] =size (G);
sum=0;

for i=1:a
    for j=1:b
        sum=sum+G(i,j);
    end
end

g= G ./sum;

%Compute Ix*Ix, Iy*Iy, Ix*Iy

Ix2 = conv2 (double(Ix.^2), g, 'same');
Iy2 = conv2 (double(Iy.^2), g, 'same');
Ixy = conv2 (double(Ix.*Iy), g, 'same');

%Compute Harris corner score. Normalize the max to 1
HR = (Ix2.*Iy2 - Ixy.^2) - 0.04 * (Ix2+Iy2).^2;
HR= HR / max(HR(:));

%Non Maxima Supression
%max= double(ordfilt2(HR,order^2,ones(order)));

%max = mat2gray(max);

%hr_points = ( HR == max) & (HR > tau);
hr_points = HR.*double(HR == ordfilt2(HR , order^2, true(order))) > tau;
[keyYs, keyXs] = find (hr_points);

figure,imshow(im) ,hold on,
plot(keyXs, keyYs,'g.','linewidth',3),title('Harris');
end