clear all;
load 'sift_desc.mat';
load 'gs.mat';

img_sift_total=[];
for i=1:1888
    idx_sift = randsample(size(train_D{i}, 2), 10); 
    img_sift=train_D{i}(:, idx_sift);
    img_sift_total=[img_sift_total; img_sift'];
end

img_sift_total=double(img_sift_total);
C=kmeans_cluster(img_sift_total,400);

train_matrix=[];
for i=1:1888
    sift_dist = pdist2(C,double(train_D{i})','euclidean'); 
    [d, ind]=sort(sift_dist,1);
    train_matrix=[train_matrix; hist(ind(1, :),1:400)];
end


test_matrix=[];
for i=1:800
    sift_dist = pdist2(C,double(test_D{i})','euclidean'); 
    [d, ind]=sort(sift_dist,1);
    test_matrix=[test_matrix; hist(ind(1, :),1:400)];
end

% output = knn(test_matrix, train_matrix, train_gs);
train_time=0;
test_time=0;
output=[];
for i=1:8
label_idx=find(train_gs==i);
label1=zeros(1,size(train_gs,2));
label1(label_idx)=1;
tic;
svm=fitcsvm(train_matrix,label1);
runtime=toc;
train_time=train_time+runtime;
tic;
[label,score]=predict(svm,test_matrix);
runtime=toc;
test_time=test_time+runtime;
output=[output score(:,2)];
end

[~,prediction] = max(output,[],2);

c=confusionmat(test_gs,prediction)


c = confusionmat(test_gs, output)

acc = 100 * sum(diag(c)) / 800

% c =
% 
%     48     2    13     1    11    12     3    10
%      0    63     1     8    10     9     3     6
%     16     1    37     5    17    12     6     6
%      0     4     3    44     3     6    12    28
%     12    10     2     1    53     8     6     8
%     14     8     7     1    14    46     2     8
%      4     6     3    13     6     9    46    13
%      4     6     3     9    10     3    12    53
% 
% acc =
% 
%    48.7500
%
%
% train_time= 58.5675
%
% test_time= 0.2948
%
% 
%
%

