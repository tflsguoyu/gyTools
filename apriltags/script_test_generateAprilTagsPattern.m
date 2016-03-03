clear;
clc;

tagType1 = 36;
tagType2 = 10;
tagStartID = 0;
tagSize = 0.0037;
tagDistance = tagSize/2;
tagNumInWidth = 49;
tagNumInHeight = 37;
tagNumAll = tagNumInWidth*tagNumInHeight-1;
OUTPUT_PATH_NAME = fullfile('test.png');

generateAprilTagsPattern(...
    tagType1, tagType2, tagStartID, ...
    tagSize, tagDistance, ...
    tagNumInWidth, tagNumInHeight, tagNumAll, ...
    OUTPUT_PATH_NAME);

%%%%%%%%%%%%%%%%%%%%%%%

% for i = 0: 2319
%    
%     inputImgName = sprintf('tag36_10_%05d.png', i);
%     im = imread(fullfile('E:\home\GuoYu\MatlabLib\gyTools\apriltags\apriltagMarkers\tag36h10' ,inputImgName));
%     im2 = im(2:end-1, 2:end-1, :);
%     
%     outputImgName = sprintf('tag36_10_%05d.png', i);
%     imwrite(im2, fullfile('E:\home\GuoYu\MatlabLib\gyTools\apriltags\apriltagMarkers\tag36h10' ,outputImgName));
%     
% end



%%%%%%%%%%%%
% img = imread(fullfile('E:\home\GuoYu\MatlabLib\gyTools\apriltags\apriltagMarkers\tag36h10' ,sprintf('tag36_10_%05d.png', 0)));
% 
% dpm = round((300/2.54) * 100);% 300DPI = dpm Dots Per Meter
% imwrite(img, 'dpiTest.png', ...
%     'ResolutionUnit', 'meter', ...
%     'XResolution', dpm, ...
%     'YResolution', dpm);







%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% clear;
% close all;
% 
% a = [0 0 0];
% b = [0.01 0 0];
% c = [0.01 0.01 0];
% 
% 
% % load('E:\home\GuoYu\GlaRe\localData\DataCapturePipeline\realtimeCameraPoseEstimation\Calib_Results_pointGrey.mat');
% 
% nx = 1920;ny = 1080;
% fc = [1800, 1800];
% cc = [nx/2+0.5, ny/2+0.5];
% 
% intrinsicMatrix = getIntrinsicMatrix(fc, cc);
% 
% k = 0;
% for theta_rac = 0:90
%     k = k+1;
%     theta = theta_rac*pi/180;
% 
% R = [1         0            0;
%      0 cos(theta) -sin(theta);
%      0 sin(theta)  cos(theta)];
% T = [0;0;-0.3];
% 
% cameraMatrix = [R,T];
% 
% a1 = camera2image(world2camera(a', cameraMatrix),intrinsicMatrix);
% a1 = a1';
% 
% b1 = camera2image(world2camera(b', cameraMatrix),intrinsicMatrix);
% b1 = b1';
% 
% c1 = camera2image(world2camera(c', cameraMatrix),intrinsicMatrix);
% c1 = c1';
% 
% % figure;imshow(zeros(ny,nx,3));hold on;
% % plot([a1(1),b1(1)], [a1(2),b1(2)], 'r');
% % plot([a1(1),c1(1)], [a1(2),c1(2)], 'g');
% 
% a1(2) = -a1(2);
% b1(2) = -b1(2);
% c1(2) = -c1(2);
% 
% angle(k) = calcuAngle(a1,b1,a1,c1);
% 
% end
% 
% figure;
% plot(angle);