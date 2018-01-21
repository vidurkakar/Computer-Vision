function [track_x, track_y] = trackPoints(pt_x, pt_y, im, ws)
% Tracking initial points (pt_x, pt_y) across the image sequence
% track_x: [Number of keypoints] x [2]
% track_y: [Number of keypoints] x [2]

% Initialization
N = numel(pt_x);
nim = numel(im);
track_x = zeros(N, nim);
track_y = zeros(N, nim);
track_x(:, 1) = pt_x(:);
track_y(:, 1) = pt_y(:);

for t = 1:nim-1
    [track_x(:, t+1), track_y(:, t+1)] = ...
            getNextPoints(track_x(:, t), track_y(:, t), im{t}, im{t+1}, ws);
end


function [x2, y2] = getNextPoints(x, y, im1, im2, ws)
% Iterative Lucas-Kanade feature tracking
% x,  y : initialized keypoint position in im2
% x2, y2: tracked keypoint positions in im2
% ws: patch window size

% YOUR CODE HERE
x_2=[];y_2=[];
%[Ix, Iy] = gradient(double(im1));
Ix=imfilter(im1,[1 0 -1]);
Iy=imfilter(im1,[1 0 -1]');
hw = floor(ws/2);
[X, Y] =(meshgrid(-hw:hw,-hw:hw));

for i=1:length(x)
    [X, Y] =(meshgrid(x(i)-hw:hw+x(i),y(i)-hw:hw+y(i)));
    
    patchIx=interp2(Ix,X,Y,'bilinear');
    patchIy=interp2(Iy,X,Y,'bilinear');
    patchim1 =interp2(im1,X,Y,'bilinear');
    x_1=x(i); y_1=y(i);
    for j=1:5
        sumIx = sum(sum(patchIx.*patchIx));
        sumIy =sum(sum(patchIy.*patchIy));
        sumIxIy=sum(sum(patchIx.*patchIy));
        A=[sumIx,sumIxIy;
            sumIxIy,sumIy];
        patchim2 = interp2(im2,X,Y,'bilinear');
        
        It=patchim2-patchim1;
        
        patchIxIt=sum(sum(patchIx.*It));
        patchIyIt=sum(sum(patchIy.*It));
        b=[patchIxIt;
            patchIyIt;]
        
       uv=A\b;
       u=uv(1);
       v=uv(2);
       X=X+u;
       Y=Y+v;
       x_1=x_1+u;
       y_1=y_1+v;
    end
    x_2(i)=x_1;
    y_2(i)=y_1;
end
x2=x_2;
y2=y_2;