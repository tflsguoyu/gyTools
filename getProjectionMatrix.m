function projectionMatrix_44 = getProjectionMatrix(fc, cc, nx, ny)

    screenWidth = nx;
    screenHeight = ny;
    znear = 0.1;
    zfar = 2000.0;
    xleft = -((cc(1) * znear) / fc(1));
    xright = (znear * (screenWidth - cc(1))) / fc(1);
    ybottom = -((cc(2) * znear) / fc(2));
    ytop = (znear * (screenHeight - cc(2))) / fc(2);

    projectionMatrix_44 = [...
        2*znear/(xright-xleft),                    0.0,  (xright+xleft)/(xright-xleft),                          0.0;
                           0.0, 2*znear/(ytop-ybottom), -(ytop+ybottom)/(ytop-ybottom),                          0.0;
                           0.0,                    0.0,     -(zfar+znear)/(zfar-znear), -(2*znear*zfar)/(zfar-znear);
                           0.0,                    0.0,                           -1.0,                          0.0];
                     
end