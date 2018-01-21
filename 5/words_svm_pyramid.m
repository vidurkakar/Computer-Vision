clear all;
load 'sift_desc.mat';
load 'gs.mat';

K=200;

img_sift_total=[];
for i=1:1888
    idx_sift = randsample(size(train_D{i}, 2), 10); 
    img_sift=train_D{i}(:, idx_sift);
    img_sift_total=[img_sift_total; img_sift'];
end

img_sift_total=double(img_sift_total);
C=kmeans_cluster(img_sift_total,K);

train_matrix_0=[];
for i=1:1888
    sift_dist = pdist2(C,double(train_D{i})','euclidean'); 
    [d, ind]=sort(sift_dist,1);
    train_matrix_0=[train_matrix_0; hist(ind(1, :),1:K)];
end

train_matrix_1=[];
for i=1:1888
point=train_F{i};
point=point(1:2,:);
quad=getquad(point);

 sift_dist = pdist2(C,double(train_D{i})','euclidean'); 
 [d, ind]=sort(sift_dist,1);
    train_matrix_1=[train_matrix_1; hist(ind(find(quad==1)),1:K), hist(ind(find(quad==2)),1:K), hist(ind(find(quad==3)),1:K), hist(ind(find(quad==4)),1:K)];
end

train_matrix_2=[];

for i=1:1888
  point=train_F{i};
point=point(1:2,:);
quad1=getquad_2(point);

 sift_dist = pdist2(C,double(train_D{i})','euclidean'); 
 [d, ind]=sort(sift_dist,1);
    train_matrix_2=[train_matrix_2;hist(ind(find(quad==1)),1:K), hist(ind(find(quad==2)),1:K), hist(ind(find(quad==3)),1:K), hist(ind(find(quad==4)),1:K),hist(ind(find(quad==5)),1:K), hist(ind(find(quad==6)),1:K), hist(ind(find(quad==7)),1:K), hist(ind(find(quad==8)),1:K),hist(ind(find(quad==9)),1:K), hist(ind(find(quad==10)),1:K), hist(ind(find(quad==11)),1:K), hist(ind(find(quad==12)),1:K),hist(ind(find(quad==13)),1:K), hist(ind(find(quad==14)),1:K), hist(ind(find(quad==15)),1:K), hist(ind(find(quad==16)),1:K) ];
  
end  
train_matrix=[0.25*train_matrix_0,0.25*train_matrix_1,0.5*train_matrix_2 ];    

train_matrix =train_matrix ./ sum(train_matrix,2);


test_matrix_0=[];
for i=1:800
    sift_dist = pdist2(C,double(test_D{i})','euclidean'); 
    [d, ind]=sort(sift_dist,1);
    test_matrix_0=[test_matrix_0; hist(ind(1, :),1:K)];
end

test_matrix_1=[];
for i=1:800
point=train_F{i};
point=point(1:2,:);
quad=getquad(point);

 sift_dist = pdist2(C,double(test_D{i})','euclidean'); 
 [d, ind]=sort(sift_dist,1);
    test_matrix_1=[test_matrix_1; hist(ind(find(quad==1)),1:K), hist(ind(find(quad==2)),1:K), hist(ind(find(quad==3)),1:K), hist(ind(find(quad==4)),1:K)];
end

test_matrix_2=[];

for i=1:800
  point=train_F{i};
point=point(1:2,:);
quad1=getquad_2(point);

 sift_dist = pdist2(C,double(train_D{i})','euclidean'); 
 [d, ind]=sort(sift_dist,1);
   test_matrix_2=[test_matrix_2;hist(ind(find(quad==1)),1:K), hist(ind(find(quad==2)),1:K), hist(ind(find(quad==3)),1:K), hist(ind(find(quad==4)),1:K),hist(ind(find(quad==5)),1:K), hist(ind(find(quad==6)),1:K), hist(ind(find(quad==7)),1:K), hist(ind(find(quad==8)),1:K),hist(ind(find(quad==9)),1:K), hist(ind(find(quad==10)),1:K), hist(ind(find(quad==11)),1:K), hist(ind(find(quad==12)),1:K),hist(ind(find(quad==13)),1:K), hist(ind(find(quad==14)),1:K), hist(ind(find(quad==15)),1:K), hist(ind(find(quad==16)),1:K) ];
  
end  
test_matrix=[0.25*test_matrix_0,0.25*test_matrix_1,0.5*test_matrix_2 ];    

test_matrix =test_matrix ./ sum(test_matrix,2);


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

acc = 100 * sum(diag(c)) / 800

% c =
% 
%     65     2     7     0    15     6     3     2
%      0    92     0     0     4     2     1     1
%     39     2    27     5    12     6     2     7
%      2    10     1    69     3     3     3     9
%      3    15     4     1    63     6     3     5
%     29    10     3     2    17    31     3     5
%      1    16     2    14    15     2    29    21
%      2     6     9    16     6     4     5    52% 
% acc =
% 
%    53.5000