function F = HW3_FundamentalMatrix
close all;

im1 = im2double(imread('chapel00.png'));
im2 = im2double(imread('chapel01.png'));
load 'matches.mat';

[F, inliers] = ransacF(c1(matches(:, 1)), r1(matches(:, 1)), c2(matches(:, 2)), r2(matches(:, 2)), im1, im2);

total=[];
for d=1:length(inliers)
    if(inliers(1,d)==1)
        X1=[r1(d) c1(d) 1];
        X2=[r2(d) c2(d) 1];
        temp=(X1*F*X2').^2;
        total=[total temp];      
    end
end

Error = sum(total)/sum(inliers);

matches = matches( logical(inliers),:);

N = size(matches, 1);
X1 = [c1(matches(:, 1)), r1(matches(:, 1)), ones(N, 1)];
X2 = [c2(matches(:, 2)), r2(matches(:, 2)), ones(N, 1)];

l1 = (F'*X2')';
l2 = (F*X1')';

% This can tell you the average distance from each point to their corresponding epipolar line
dist1 = mean(abs(sum(X1.*l1, 2) ./ sqrt(l1(:,1).^2+l1(:,2).^2)));
dist2 = mean(abs(sum(X2.*l2, 2) ./ sqrt(l2(:,1).^2+l2(:,2).^2)));

x1l = X1(:, 1) - 400;
x2l = X2(:, 1) - 400;
x1r = X1(:, 1) + 400;
x2r = X2(:, 1) + 400;

y1l = (-l1(:, 3) - l1(:, 1) .* x1l) ./ l1(:, 2);
y2l = (-l2(:, 3) - l2(:, 1) .* x2l) ./ l2(:, 2);
y1r = (-l1(:, 3) - l1(:, 1) .* x1r) ./ l1(:, 2);
y2r = (-l2(:, 3) - l2(:, 1) .* x2r) ./ l2(:, 2);

subplot(1, 2, 1);
imshow(im1);
hold on

randplot = randsample (length(x1l),7);

for i = 1:length(x1l)
  
    if ((ismember(i,randplot))== 1)
     plot(X1(i, 1), X1(i, 2), 'r+');
     plot([x1l(i), x1r(i)], [y1l(i), y1r(i)], 'g');
    end
end

subplot(1, 2, 2);
imshow(im2);
hold on
for i = 1:length(x2l)
    if ((ismember(i,randplot))== 1)
     plot(X2(i, 1), X2(i, 2), 'r+');
     plot([x2l(i), x2r(i)], [y2l(i), y2r(i)], 'g');
   end
end


% display F

% plot outliers

% display epipolar lines


function [bestF, best] = ransacF(x1, y1, x2, y2, im1, im2)

%T1 = normalize(x1, y1);
%T2 = normalize(x2, y2);

pt1= [x1, y1, ones(length(x1),1)]';
pt2= [x2, y2, ones(length(x2),1)]';

inlier_max = 0;

for j=1:8000
    
rand_index = randsample (size(x1,1), 8);
% Find normalization matrix
%T1 = normalize(x1(rand_index), y1(rand_index));
%T2 = normalize(x2(rand_index), y2(rand_index));


%rand_index_match_1 = [x1 (rand_index(:,1)),y1 (rand_index(:,2))];


%im1_1 = T1 * [x1(rand_index) y1(rand_index) ones(8,1)]';
%im2_2 = T2 * [x2(rand_index) y2(rand_index) ones(8,1)]';

im1_1 =  [x1(rand_index) y1(rand_index) ones(8,1)]';
im2_2 =  [x2(rand_index) y2(rand_index) ones(8,1)]';

F=computeF(im1_1(1,:),im1_1(2,:),im2_2(1,:),im2_2(2,:));

%Denormalize
%F = T2' * F * T1;
F = F * sqrt (1/sum(sum(F.^2)));

thresh = 0.05;
inliers =  getInliers(pt1, pt2, F, thresh);
inlier_count=sum(inliers);

%Find case with max inliers
if inlier_count > inlier_max
    bestF = F ;
    inlier_max = inlier_count;
    best = inliers;
end


end


% Transform point set 1 and 2

% RANSAC based 8-point algorithm


function inliers = getInliers(pt1, pt2, F, thresh)

len = F * pt1;

for i=1:length(pt1)
    
    distance(i) = abs((sum(pt2(:,i).*len(:,i)))./(sqrt(len(1,i).*len(1,i)+len(2,i).*len(2,i)))); 
    
    if(distance(i)< thresh)
        inliers(i)=1;  
    else
         inliers(i)=0;
    end
              
end


% Function: implement the criteria checking inliers. 


function T = normalize(x, y)
% Function: find the transformation to make it zero mean and the variance as sqrt(2)

cent_x = mean (x);
cent_y = mean (y);

m = mean (sqrt (std (x) + std (y)));
var = sqrt(2) / m;

T = [var 0  -var * cent_x;
     0 var -var * cent_y;
     0 0 1];

 
  
function F = computeF(x1, y1, x2, y2)
% Function: compute fundamental matrix from corresponding points

for i=1:8
Af(i,:) = [(x1(i)*x2(i)) (x1(i)*y2(i)) x1(i) (y1(i)*x2(i)) (y1(i)*y2(i)) y1(i) x2(i) y2(i) 1] ;
end

[U,S,V] = svd (Af);
f= V (:,end);

F=reshape (f, [3,3]);

[U, S, V] = svd(F);
S(3,3) = 0;
F = U*S*V';


