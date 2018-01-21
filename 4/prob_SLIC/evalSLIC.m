% Evaluate SLIC implementation

% 
% ECE 5554/4554 Computer Vision, Fall 2017
% Virgimnia Tech

addpath(genpath('BSR'));
addpath(genpath('superpixel_benchmark'));

% Run the complet benchmark
main_benchmark('evalSlicSetting.txt');

% % Report the case with K = 256
% load('result\slic\slic_256\benchmarkResult.mat');
% 
% avgRecall   =  mean(imRecall(:));
% avgUnderseg =  mean(imUnderseg(:));
% fprintf('Average boundary recall = %f for K = 256 \n' , avgRecall);
% fprintf('Average underseg error  = %f for K = 256 \n' , avgUnderseg);
% fprintf('Mean Runtime  = %f for K = 256 \n' , mean(imRuntime));

% Report the case with K = 64
load('result\slic\slic_64\benchmarkResult.mat');

avgRecall   =  mean(imRecall(:));
avgUnderseg =  mean(imUnderseg(:));
fprintf('Average boundary recall = %f for K = 64 \n' , avgRecall);
fprintf('Average underseg error  = %f for K = 64 \n' , avgUnderseg);
fprintf('Mean Runtime  = %f for K = 64 \n' , mean(imRuntime));

% Report the case with K = 1024
% load('result\slic\slic_1024\benchmarkResult.mat');
% avgRecall   =  mean(imRecall(:));
% avgUnderseg =  mean(imUnderseg(:));
% fprintf('Average boundary recall = %f for K = 1024\n' , avgRecall);
% fprintf('Average underseg error  = %f for K = 1024 \n' , avgUnderseg);
% fprintf('Mean Runtime  = %f for K = 1024 \n' , mean(imRuntime));

% % Report the case with K = 256
% load('result\slic\slic_256_lab\benchmarkResult.mat');
% 
% avgRecall   =  mean(imRecall(:));
% avgUnderseg =  mean(imUnderseg(:));
% fprintf('Average boundary recall = %f for K = 256 (LAB) \n' , avgRecall);
% fprintf('Average underseg error  = %f for K = 256 (LAB) \n' , avgUnderseg);
% fprintf('Mean Runtime  = %f for K = 256 (LAB) \n' , mean(imRuntime));


