hist_matrix_train=[];
for i=1:1888
    im = imread(sprintf('train/%d.jpg',i)); 
    img_hist=(imhist(im(:,:,1),9))';
    img_hist=[img_hist, (imhist(im(:,:,2),9))'];
    img_hist=[img_hist, (imhist(im(:,:,3),9))'];
    hist_matrix_train=[hist_matrix_train; img_hist];
end

hist_matrix_test=[];
for i=1:800
    im = imread(sprintf('test/%d.jpg',i)); 
    img_hist_1=(imhist(im(:,:,1),9))';
    img_hist_1=[img_hist_1, (imhist(im(:,:,2),9))'];
    img_hist_1=[img_hist_1, (imhist(im(:,:,3),9))'];
    hist_matrix_test=[hist_matrix_test; img_hist_1];
end

% load 'hist_matrix_train.mat';
% load 'hist_matrix_test.mat';
load 'gs.mat';

output = knn(hist_matrix_test, hist_matrix_train, train_gs);
c = confusionmat(test_gs, output)

acc = 100 * sum(diag(c)) / 800


% c =
% 
%     32    15     3    15    10     6     9    10
%      2    85     0     8     0     0     0     5
%      4     5    59     9     8     6     6     3
%      2    25     0    41     6     2    14    10
%     10    16     1     9    28     8     5    23
%      9    24     4    14     3    32     5     9
%      3     6     1    18     4     4    62     2
%     12    10     1    15    18     8     8    28
% 
% 
% acc =
% 
%    45.8750