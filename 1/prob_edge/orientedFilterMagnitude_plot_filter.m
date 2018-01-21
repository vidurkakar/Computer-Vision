
im= imread('data/images/3096.jpg');
im=im2double(im);

sigma=2;

%The number of filters in the filterset
N=15;
K=sigma*4;

% Create Gaussian kernel
xFilterSet = {};
yFilterSet = {};

l=1
[x, y] = meshgrid(-K:0.5:K, -K:0.5:K);

elongated_G  = exp(-(100*x.^2 + y.^2) / (2*sigma*sigma));  
elongated_G  = elongated_G /sum(elongated_G (:));  

%X and Y Gradients 
d=[1 0 -1];
dx_elongated_G=imfilter(elongated_G, d);
dy_elongated_G=imfilter(elongated_G, d');

%Now carrying out filtering with skewed filter and also calculating the L2
%norm for RGB compoenenta

for i = 0 : pi/N : pi - pi/N
    
    %rotating the filter
    filterSet{l} = imrotate(dy_elongated_G, (180/pi) * i);
    %smoothening the image with each of the orinented filters
    mag_filter_temp = imfilter(im, filterSet{l});
    
    temp_mag(:, :, l) = max(abs(mag_filter_temp ), [], 3);
    
    l = l + 1;
    
end

Array_theta = atan2(sin(0 : pi/N : pi - pi/N), cos(0 : pi/N : pi - pi/N));

[mag, idx] = max(temp_mag, [], 3);

theta = Array_theta (idx);

for t=1:15
subplot (3,5,t);
imagesc(mat2gray(filterSet{t}));
end

colormap gray;

