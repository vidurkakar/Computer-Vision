function featureMatching
% Matching SIFT Features

im1 = imread('stop1.jpg');
im2 = imread('stop2.jpg');

load('SIFT_features.mat'); % Load pre-computed SIFT features
% Descriptor1, Descriptor2: SIFT features from image 1 and image 2
% Frame1, Frame2: position, scale, rotation of keypoints

% YOUR CODE HERE
Descriptor2=double(Descriptor2);
Descriptor1=double(Descriptor1);
kdtree = vl_kdtreebuild(Descriptor2) ; 
threshold=0.26;
tic;

matches=[];
for i=1:size(Descriptor1,2) 
    [index, distance] = vl_kdtreequery(kdtree, Descriptor2, Descriptor1(:, i), 'NumNeighbors', 2) ;
    ratio=   distance(1)/distance(2);
    if (ratio< threshold)
        matches=[matches;i index(1)];
    end  
end

toc

matches=matches';

% matches: a 2 x N array of indices that indicates which keypoints from image
% 1 match which points in image 2

% Display the matched keypoints
figure(1), hold off, clf
plotmatches(im2double(im1),im2double(im2),Frame1,Frame2,matches);