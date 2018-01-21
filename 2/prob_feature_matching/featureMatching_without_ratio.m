function featureMatching
% Matching SIFT Features

im1 = imread('stop1.jpg');
im2 = imread('stop2.jpg');

load('SIFT_features.mat'); % Load pre-computed SIFT features
% Descriptor1, Descriptor2: SIFT features from image 1 and image 2
% Frame1, Frame2: position, scale, rotation of keypoints

% YOUR CODE HERE


threshold=0.8;
matches=[];
for i=1:size(Descriptor1,2)
D=[];    
    for j=1:size(Descriptor2,2)
        Dij = sqrt(sum((Descriptor1(:, i) - Descriptor2(:,j)).^2, 1));
        D=[D;j Dij];
    end
    P=sortrows(D,2);
    matches=[matches;i P(1,1)];

end

matches=matches';


% matches: a 2 x N array of indices that indicates which keypoints from image
% 1 match which points in image 2

% Display the matched keypoints
figure(1), hold off, clf
plotmatches(im2double(im1),im2double(im2),Frame1,Frame2,matches);
