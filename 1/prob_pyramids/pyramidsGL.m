
function [G, L] = pyramidsGL(im, N)
L={};
G{1}=im;
for i=1:N
   
  G{i+1}=imresize(imfilter(G{i},fspecial('gaussian',[4 4], 2)),0.5);

  L{i} = G{i}-imfilter(imresize(G{i+1},2),fspecial('gaussian',[4 4], 2));
end
end