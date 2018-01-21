function F = HW3_SfM
close all;

folder = 'images/';
im = readImages(folder, 0:50);

load './tracks.mat';


% figure(2), imagesc(im{1}), hold off, axis image, colormap gray
% hold on, plot(track_x', track_y', 'r')
% figure(3), imagesc(im{end}), hold off, axis image, colormap gray
% hold on, plot(track_x', track_y', 'r')
%pause;

valid = ~any(isnan(track_x), 2) & ~any(isnan(track_y), 2); 

[R, S] = affineSFM(track_x(valid, :), track_y(valid, :));

%plotSfM(R, S);

P=[];
R_out=[];
X=[];
for i=1:length(track_x)
    %count=0;
    if(sum(isnan(track_x(i,:)))>0)
        P =[];  
        R_out=[];
        for k=1:51-sum(isnan(track_x(i,:)))
            P=[P;track_x(i,k);track_y(i,k)];
            R_out=[R_out;R(k,:);R(51+k,:);];
        end
        X = [X, R_out\P];
    end
end
track_x_new=[];
track_y_new=[];
for t=1:length(X)
   trackpt=R*X(:,t);
   track_x_new=[track_x_new;trackpt(1:51)'];
   track_y_new=[track_y_new;trackpt(52:102)'];
end

figure(2), imagesc(im{1}), hold off, axis image, colormap gray
hold on, plot(track_x_new', track_y_new', 'g')
figure(3), imagesc(im{end}), hold off, axis image, colormap gray
hold on, plot(track_x_new', track_y_new', 'g')
pause;


function [R, S] = affineSFM(x, y)
% Function: Affine structure from motion algorithm

% Normalize x, y to zero mean

xn=x-mean(x);
yn=y-mean(y);

% Create measurement matrix
D = [xn' ; yn'];

[U W V] = svd(D);

% Decompose and enforce rank 3
U3= [U(:,1) U(:,2) U(:,3)];
V3= [V(:,1) V(:,2) V(:,3)];
W3= W(1:3, 1:3);
% Apply orthographic constraints

 A=U3*sqrt(W3);
 S=sqrt(W3)*V3';
 
 Ai=[];
 b=[];
 
 for i=1:51
     Atemp_1=[A(i,:)'*A(i,:)];
     Atemp_1=reshape(Atemp_1,[1,9]);
     
     Atemp_2=[ A(51+i,:)'*A(51+i,:)];
     Atemp_2=reshape(Atemp_2,[1,9]);
     
     Atemp_3=[A(i,:)'*A(51+i,:)];
     Atemp_3=reshape(Atemp_3,[1,9]);
     
     Ai=[Ai;Atemp_1;Atemp_2;Atemp_3];
     b=[b;1;1;0];
 end
 
 L=Ai\b;
 L=reshape(L,[3 3]);
 C=chol(L,'lower');
 R=A*C;
 S=(C^-1)*S;

 
function im = readImages(folder, nums)
im = cell(numel(nums),1);
t = 0;
for k = nums,
    t = t+1;
    im{t} = imread(fullfile(folder, ['hotel.seq' num2str(k) '.png']));
    im{t} = im2single(im{t});
end
