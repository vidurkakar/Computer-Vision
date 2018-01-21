clear all;
load 'sift_desc.mat';
load 'gs.mat';

K=400;

img_sift_total=[];
for i=1:1888
    idx_sift = randsample(size(train_D{i}, 2), 10); 
    img_sift=train_D{i}(:, idx_sift);
    img_sift_total=[img_sift_total; img_sift'];
end

img_sift_total=double(img_sift_total);
C=kmeans_cluster(img_sift_total,K);

train_matrix=[];
for i=1:1888
    sift_dist = pdist2(C,double(train_D{i})','euclidean'); 
    [d, ind]=sort(sift_dist,1);
    train_matrix=[train_matrix; hist(ind(1, :),1:K)];
end


test_matrix=[];
for i=1:800
    sift_dist = pdist2(C,double(test_D{i})','euclidean'); 
    [d, ind]=sort(sift_dist,1);
    test_matrix=[test_matrix; hist(ind(1, :),1:K)];
end

output = knn(test_matrix, train_matrix, train_gs);
c = confusionmat(test_gs, output)

acc = 100 * sum(diag(c)) / 800

% c =
% 
%     72     2    18     0     1     5     0     2
%      2    94     1     0     1     0     1     1
%     46     3    41     0     1     5     0     4
%     11    11     3    47     0     3     4    21
%     25    12     7     0    29    18     0     9
%     46     8     6     0     8    25     0     7
%     12    14     7     3     3    17    16    28
%     18     4     8     9     1     4     1    55
% 
% 
% acc =
% 
%    47.3750
