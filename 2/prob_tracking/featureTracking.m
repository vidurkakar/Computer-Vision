
function featureTracking
% Main function for feature tracking
folder = '.\images';
im = readImages(folder, 0:50);
keypoint_out=[];

tau = 0.03;                                % Threshold for harris corner detection
%tau = 2;                                  % Threshold for harris corner detection
[pt_x, pt_y] = getKeypoints(im{1}, tau);    % Prob 1.1: keypoint detection

ws = 15;                                     % Tracking ws x ws patches
[track_x, track_y,keypoint_out] = ...                    % Keypoint tracking
    trackPoints(pt_x, pt_y, im, ws,keypoint_out);

keypoint_out_x=pt_x(keypoint_out);
keypoint_out_y=pt_y(keypoint_out);



% Visualizing the feature tracks on the first and the last frame
figure(2), imagesc(im{1}), hold off, axis image, colormap gray
hold on, plot(track_x', track_y', 'r');
hold on, plot(keypoint_out_x', keypoint_out_y', 'g.');

figure(3), imagesc(im{end}), hold off, axis image, colormap gray
hold on, plot(track_x', track_y', 'r');

figure (4),imshow(im{1}) ,hold on, axis image, colormap gray
plot(pt_x, pt_y,'g.','linewidth',3),title('Harris');
hold on, plot(keypoint_out_x', keypoint_out_y', 'y.');



%print out_temp1;


function [track_x, track_y,keypoint_out] = trackPoints(pt_x, pt_y, im, ws,keypoint_out)
%global out_temp1;
%out_temp1=[];

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
    [track_x(:, t+1), track_y(:, t+1),keypoint_out] = ...
        getNextPoints(track_x(:, t), track_y(:, t), im{t}, im{t+1}, ws,keypoint_out);
       % out_temp1=[out_temp1;[out_temp]]
end


function [x2, y2,keypoint_out] = getNextPoints(x, y, im1, im2, ws,keypoint_out)
% Iterative Lucas-Kanade feature tracking
% x,  y : initialized keypoint position in im2
% x2, y2: tracked keypoint positions in im2
% ws: patch window size

% YOUR CODE HERE
x_2=x;y_2=y;
%[Ix, Iy] = gradient(double(im1));
Ix=imfilter(im1,[1 0 -1]);
Iy=imfilter(im1,[1 0 -1]');
hw = floor(ws/2);
[X, Y] =(meshgrid(-hw:hw,-hw:hw));
[im_size_y,im_size_x]=size(im1);



for i=1:length(x)
    %if((x_2(i)> hw) && (x_2(i)< im_size_x - hw) && (y_2(i)> hw) && (y_2(i)< im_size_y - hw) )
    
    if((x_2(i)> hw) && (x_2(i)< im_size_x - hw) && (y_2(i)> hw) && (y_2(i)< im_size_y - hw) )

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
                patchIyIt;];

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
    else
    keypoint_out=[keypoint_out;i];   
    end
    
end
x2=x_2;
y2=y_2;
%size_im1=size(im1);
%p=[];

%out_x2=x2>size_im1(1);
%out_y2=y2>size_im1(2);
%out_temp=[[x2(out_x2),y2(out_y2)]];  

function im = readImages(folder, nums)
im = cell(numel(nums),1);
t = 0;
for k = nums,
    t = t+1;
    im{t} = imread(fullfile(folder, ['hotel.seq' num2str(k) '.png']));
    im{t} = im2single(im{t});
end