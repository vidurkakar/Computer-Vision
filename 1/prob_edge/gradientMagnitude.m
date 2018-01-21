function [mag, theta] = gradientMagnitude(im, sigma);

%sigma=2;
K=sigma;
[x, y] = meshgrid(-K:K, -K:K);

%Create Gausian Filter Kernel
G = exp((x.^2 - y.^2)/(2*sigma*sigma));     
G = G/sum(G(:));  

%Apply Gaussian Filter
im=imfilter(im,G);
%imagesc(im);

%X and Y Gradients 
d=[1 0 -1];
dx_gkernel=imfilter(im, d);
dy_gkernel=imfilter(im, d');

mag_gkernel= sqrt ( dx_gkernel.^2 + dy_gkernel.^2);

%computing L2 norm
mag_X=sqrt (sum(dx_gkernel.^2,3));
mag_Y=sqrt (sum(dy_gkernel.^2,3));
mag= sqrt(mag_X.^2 + mag_Y.^2);


%choose orientation along max

[~, idx] = max (mag_gkernel, [], 3);
theta_tmp = atan2 (-dy_gkernel,dx_gkernel);

for i = 1:size (im,1)
    for j= 1:size (im,2)
        theta(i,j) = theta_tmp (i, j, idx (i,j));
    end
end

end