function image_undistort = undistortImages(image, fc, cc, kc, nx, ny)
    
    intrinsicMatrix = getIntrinsicMatrix(fc, cc);
    distCoeffs = kc';
    newIntrinsicMatrix = intrinsicMatrix;
    siz = [nx ny];
    [map1, map2] = cv.initUndistortRectifyMap(intrinsicMatrix, distCoeffs, newIntrinsicMatrix, siz);
    image_undistort = cv.remap(image, map1, map2);
    
    
end