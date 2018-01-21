function T = align_shape(im1, im2)

im2=flipdim(im2,2)

%im1=imread('./data/cattle_1.png');
%im2=imread('./data/cattle_2.png');

% im1: input edge image 1
% im2: input edge image 2

% Output: transformation T [3] x [3]

% YOUR CODE　HERE

%[Y1,X1]=find(im1>0);
%[Y2,X2]=find(im2>0);

[Y1,X1]=find(im1>0);
[Y2,X2]=find(im2>0);

im1_points=[X1,Y1];
im2_points=[X2,Y2];
X1_mean = mean(X1); 
X2_mean = mean(X2);
Y1_mean = mean(Y1);
Y2_mean = mean(Y2);

A=[1 0 X2_mean;
   0 1 Y2_mean;
   0 0 1];

%sigma_1=var(im1_points);
%sigma_2=var(im2_points);

sigma_1=sqrt(var(X1)^2+var(Y1)^2);
sigma_2=sqrt(var(X2)^2+var(Y2)^2);

sigma_21=sigma_2/sigma_1;
%sigma_12=sigma_1/sigma_2;

B=[sigma_21 0 0;
    0 sigma_21 0;
    0 0 1];

C=[1 0 -X1_mean;
    0 1 -Y1_mean;
    0 0 1];

T_initial= A * B * C;

    
%vector_img1=pca(im1_points);
%vector_img2=pca(im2_points);

im1_points_cov = cov (im1_points);
im2_points_cov = cov (im2_points);

[E1,S1]= eig (im1_points_cov);
[E2,S2]= eig (im2_points_cov);

S1_max_val=max(S1);
S2_max_val= max(S2);

S1_max_ind=find(S1_max_val);
S2_max_ind= find(S2_max_val);


vector_img1= E1(:,S1_max_ind );
vector_img2= E2 (:,S2_max_ind);

%vector_img1=vector_img1'
%vector_img2=vector_img2'

dotUV = dot(vector_img1, vector_img2);
normU = norm(vector_img1);
normV = norm(vector_img2);

t = acos(dotUV/(normU * normV));
t1= t(1,1) + ((3*pi)/2);
t_degree = radtodeg(acos(dotUV/(normU * normV)));

if abs(t_degree(1,1)) > 150 || abs(t_degree(1,1)) < -150
       imrotate(im1,180);
end
%if round(t_degree(1)) == 90 || round(t_degree(1)) == -90
% rot_matix=[cos(t1) -sin(t1) 0;
%            sin(t1) cos(t1) 0;
%            0 0 1];

rot_matix=[cos(t1) -sin(t1) 0;
           sin(t1) cos(t1) 0;
           0 0 1];
       
im1_points_size=size(im1_points);
NewCol = ones(im1_points_size(1),1);
%Add new column
im1_points_padded = [im1_points NewCol];

T=T_initial*rot_matix;
%T=T_initial;

%end

for K=1:30
    
%im1_points_padded=padarray(im1_points,1);
%im1_points_padded=im1_points_padded';

Transform_T1=T * im1_points_padded';
Transform_T1=Transform_T1';

p_dist= pdist2(Transform_T1(:,1:2),im2_points);

[min_dist p_dist_index]=min(p_dist,[], 2);

% Affine Transformation
A_mat=[];
B_mat=[];
Transform_T1_size=size(Transform_T1);
Transform_T1_size=size(p_dist_index);

for i=1:Transform_T1_size(1)
A_mat=[A_mat; Transform_T1(i,2) Transform_T1(i,1) 0 0 1 0; 0 0 Transform_T1(i,2) Transform_T1(i,1) 0 1];
end

p_dist_index_size=size(p_dist_index);

for j=1:p_dist_index_size(1)
B_mat=[B_mat; im2_points( p_dist_index(j,1), 1); im2_points( p_dist_index(j,1), 2)];
end

new_T= A_mat \ B_mat;


new_T=[new_T(1,1) new_T(2,1) new_T(5,1) ;new_T(3,1) new_T(4,1) new_T(6,1); 0 0 1];
T= new_T;
end
end



