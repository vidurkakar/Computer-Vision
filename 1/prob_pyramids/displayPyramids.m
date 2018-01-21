

function displayPyramids(G, L)
% Displays intensity and fft images of pyramids
GL = [G L];
%N = length(GL) * 0.5;
N=length (GL);
%GL{ceil(N)} = [];  %removing the extra item of Gaussian pyramid
%GL = GL(~cellfun('isempty',GL));

ha = tight_subplot(2, 6, [0.02 0.01], [0.1 0.1], [0.1 0.1]);

for i = 1:N
    axes(ha(i));
    GL{i} = mat2gray(GL{i});
    imshow(GL{i});
    axis off;
end
    axes(ha(N+1));
    imshow();
    axis off;

end
