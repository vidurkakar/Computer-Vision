
function bmap = edgeGradient(im);

%im= imread('data/images/3096.jpg');
im=im2single(im);
sigma=2;

%soft boundary
[mag, theta] = gradientMagnitude(im, sigma);

%nonmax
bmap= nonmax (mag,theta);

bmap= bmap .^ 0.7;
colormap gray;
imagesc (bmap); 

end