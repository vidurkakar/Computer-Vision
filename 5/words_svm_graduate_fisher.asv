clear all;
load 'sift_desc.mat';
load 'gs.mat';
K=25;

img_sift_total=[];
for i=1:1888
    idx_sift = randsample(size(train_D{i}, 2), 10); 
    img_sift=train_D{i}(:, idx_sift);
    img_sift_total=[img_sift_total; img_sift'];
end

img_sift_total=double(img_sift_total);
[means, covariances, priors] = vl_gmm(img_sift_total', K);


train_matrix=[];
for i=1:1888
    encoding_train = vl_fisher(double(train_D{i}), means, covariances, priors);
    train_matrix=[train_matrix; encoding_train'];
end


test_matrix=[];
for i=1:800
    encoding_test = vl_fisher(double(test_D{i}), means, covariances, priors);
    test_matrix=[test_matrix; encoding_test'];
end


output=[];
for i=1:8
label_idx=find(train_gs==i);
label1=zeros(1,size(train_gs,2));
label1(label_idx)=1;
svm=fitcsvm(train_matrix,label1);
[label,score]=predict(svm,test_matrix);
output=[output score(:,2)];
end

[~,prediction] = max(output,[],2);

c=confusionmat(test_gs,prediction)


c = confusionmat(test_gs, output)

acc = 100 * sum(diag(c)) / 800


% c =
% 
%     63     1     8     1     8    17     1     1
%      1    90     0     0     3     4     0     2
%     22     0    41     1     8    15    12     1
%      0     2     1    69     3     2    11    12
%      4     8     2     0    63    15     4     4
%     16     5     4     1    16    54     2     2
%      0     2     6    12     9     2    58    11
%      1     2     4    11     5     5     4    68
% 
%     acc =
% 
%  63.2500
