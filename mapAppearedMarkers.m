function calibMarkers_3D_this = mapAppearedMarkers(calibMarkers_2D_this, calibMarkers_3D)
    
    % input:
    % calibMarkers_2D_this: Nx9
    % calibMarkers_3D: Mx13
    % N <= M
    % output:
    % calibMarkers_3D_this: Nx13
    
    N = size(calibMarkers_2D_this,1);
    M = size(calibMarkers_3D,2);
    
    calibMarkers_3D_this = NaN(N,M);
    for i = 1: N
        idx = find(calibMarkers_3D(:,1)==calibMarkers_2D_this(i,1));
        calibMarkers_3D_this(i,:) = calibMarkers_3D(idx, :);
    end

end