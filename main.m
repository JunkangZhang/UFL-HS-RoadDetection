%% 
clear
addpath Segmentation
addpath UFLkmeans

%% dataset
route = '/home/zhangjunkang/Dataset/road/';

dataset = 'after-rain';
ns = [120, 160];

% dataset = 'sunny-shadows';
% ns = [120, 160];

% dataset = 'kitti_layout'; 
% ns = [120, 397];

%% read data
readDataset;

%% parameters
% input image size
param.inputSize = ns;
param.rfWid = 6;
param.rfHei = 6;

% blurring
param.LPFwindow = 7;
param.LPFsigma = 1.5;

% brightness equalization
param.lumiHei = 5;
param.lumiWid = 5;
param.lumiSigma = 0.5;

% dictionary learning
param.numCentroids = 200;
param.numPatches = 0; 
param.kmeansIterations = 10;

% feature selection
param.fsPriorRatio = [40.0/200, 0.0]; % top & last
param.filter = [];

% segmentation -> tree construction
param.numSamples = 16;
param.minPts = 50;

% segmentation -> optimizaiton
param.paramE = 2;
param.thIteration = 2;
param.thFilter = getFilterTh([ns(1)-param.rfHei+1, ns(2)-param.rfWid+1], 3);

%% run
predCell = cell(fileNum,1);
predIterCell = cell(fileNum,1);
setLabel = zeros(fileNum,1);

tic
parfor i = 1:fileNum
    [predCell{i}, ~, predIterCell{i}] = ...
            RoadDetection(imCell{i}, param);
end
toc

%% result
% [tot, sep] = evaluationPRF(predCell, labCell);
% fprintf('F: %f  -- F-sep: %f\n', tot.F, mean(sep.F(:)));
% figure(41); cla; hold on;
% plot(1:fileNum, sep.P, 'b-'); hold on
% plot(1:fileNum, sep.R, 'g-'); hold on
% plot(1:fileNum, sep.F, 'r-'); hold on
% axis([0,fileNum, 0,1])

