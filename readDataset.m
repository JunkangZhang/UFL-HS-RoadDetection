%% dataset
if strcmp(dataset, 'after-rain')==true
    rawFileType = 'tif'; 
    labelFileTpype = 'png'; 
    datasetRoute = [route, 'After-Rain/'];
elseif strcmp(dataset, 'sunny-shadows')==true
    rawFileType = 'tif'; 
    labelFileTpype = 'png'; 
    datasetRoute = [route, 'Sunny-Shadows/'];
elseif strcmp(dataset, 'kitti_layout')==true
    rawFileType = 'png'; 
    labelFileTpype = 'tif'; 
    datasetRoute = [route, 'KITTI_Layout/'];
end

%% read images and labels
files = dir( [datasetRoute, '*.', labelFileTpype] );
fileNum = length(files);
imCell = cell(fileNum,1);
labCell = cell(fileNum,1);
for i = 1:fileNum
    name = files(i).name;
    lab = imread([datasetRoute, name]);
    if strcmp(dataset,'sunny-shadows')==true
        name = name(1:end-1);
        name(end-2:end) = rawFileType;
    else
        name(end-2:end) = rawFileType;
    end
    im = imread([datasetRoute, name]);
    
    dim = size(im);
    
    if strcmp(dataset,'groundtruth')==true
        labCell{i} = logical(1-imresize(rgb2gray(lab), ns));
%         imCell{i} = imresize(im2double(im), ns);
        imCell{i} = imresize(im, ns);
        
    elseif (strcmp(dataset,'kitti_semantic')==true || ...
           strcmp(dataset,'kitti_layout')==true) && ...
           ns(2)==160
        labCell{i} = logical(tailorWide2Normal(lab,ns));
        imCell{i} = tailorWide2Normal(im2double(im),ns);
        
    else
        labCell{i} = logical(imresize(lab, ns));
%         imCell{i} = imresize(im2double(im), ns);
        imCell{i} = imresize(im, ns);
    end
    
end
