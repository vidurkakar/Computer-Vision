function G= getGausPyramid(im,N)
G = im;

size_of_im=size(im);

for frame_index = 1:size_of_im(1)
    
    for i=1:N-1   
        G{frame_index,i+1}=imresize(imfilter(im2single(G{frame_index,i}),fspecial('gaussian',[4 4], 2)),0.5);  
    end
end
end