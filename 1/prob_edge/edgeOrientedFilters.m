function bmap = edgeOrientedFilters(im);

%im= imread('data/images/3096.jpg');
im=im2single(im);


%soft boundary
[mag, theta] = orientedFilterMagnitude(im);

%nonmax
bmap= nonmax (mag,theta);

bmap= bmap .^ 0.7;
colormap gray;
imagesc (bmap); 

end