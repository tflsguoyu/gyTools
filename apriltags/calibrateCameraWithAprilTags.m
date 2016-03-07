function [fc,cc,kc,nx,ny,reprojErr] = ...
    calibrateCameraWithAprilTags(imageFolder, imgFormat, aprilTagsPattern_N13)

    listImages = dir(fullfile(imageFolder,['*.' imgFormat]));
    imageNameAll = {listImages.name};
    
    img_sample = imread(fullfile(imageFolder, imageNameAll{1}));
    [imgH, imgW, ~] = size(img_sample);
    
    numOfImages = length(imageNameAll);

    k = 0;
    for imageID = 1: numOfImages
       
        disp(['Marker detecting: ' num2str(imageID) ' of ' num2str(numOfImages)]);
        
        inputImageName = imageNameAll{imageID};        
        img = imread(fullfile(imageFolder, inputImageName));
        
        markersDetected_N9 = [];
        markersDetected_N9 = findAprilTagsPosition(img, 'tag36h10', 5);
        
        if size(markersDetected_N9,1) < 4
           continue; 
        end
        
        markersDetected_N13 = [];
        markersDetected_N13 = mapAppearedMarkers(markersDetected_N9, aprilTagsPattern_N13);    
       
        objectPoints_4N3 = [];
        objectPoints_4N3 = marker2point(markersDetected_N13);
        imagePoints_4N2 = [];
        imagePoints_4N2 = marker2point(markersDetected_N9);
        
        objectPoints_this = [];
        for i = 1: size(objectPoints_4N3,1)
            objectPoints_this{i} = objectPoints_4N3(i,:);
        end
        
        imagePts_this = [];
        for j = 1: size(imagePoints_4N2,1)
            imagePts_this{j} = imagePoints_4N2(j,:);
        end        
        
        k = k+1;
        objectPoints{k} = objectPoints_this;
        imagePts{k} = imagePts_this;
        
    end
    
    %%
    
    [cameraMatrix, distCoeffs, reprojErr] = ...
        cv.calibrateCamera(objectPoints, imagePts, [imgW, imgH]);
    
    disp('Calibration is DONE!');
    disp(['Reprojection Error is ' num2str(reprojErr)]);
    
    fx = cameraMatrix(1,1);
    fy = cameraMatrix(2,2);
    fc = [fx, fy];
    
    cx = cameraMatrix(1,3);
    cy = cameraMatrix(2,3);
    cc = [cx, cy];
    
    kc = distCoeffs;
    
    nx = imgW;
    ny = imgH;
    
end