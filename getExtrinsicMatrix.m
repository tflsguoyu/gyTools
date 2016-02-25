function extrinsicMatrix = getExtrinsicMatrix(...
          objectPoints_N3, ...
          imagePoints_N2, ...
          intrinsicMatrix, RTvec)
          
    Rvec = RTvec(:,1); 
    Tvec = RTvec(:,2);

    if size(imagePoints_N2,1) ~= 0
        [rvec, tvec] = cv.solvePnP(objectPoints_N3, imagePoints_N2, intrinsicMatrix,...
            'Rvec', Rvec, 'Tvec', Tvec, 'UseExtrinsicGuess', true);
    end
    
    rmat = double(cv.Rodrigues(rvec));
    left = rmat;
    right = tvec;
    extrinsicMatrix = [left, right];      
      
end