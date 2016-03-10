function mesh_image_2V = ...
    camera2image(mesh_camera_3V, ...
    transformMatrix, nx, ny)    

    if nargin == 4 && size(transformMatrix,1) == 4
        projectionMatrix_44 = transformMatrix;
        mesh_camera_4V = [mesh_camera_3V; ones(1,size(mesh_camera_3V,2))];
        mesh_image_4V = projectionMatrix_44 * mesh_camera_4V;
        mesh_image_2V = bsxfun(@rdivide, mesh_image_4V(1:2,:), mesh_image_4V(4,:));
        mesh_image_2V(1,:) = nx * (mesh_image_2V(1,:)+1)/2;
        mesh_image_2V(2,:) = ny * (1-mesh_image_2V(2,:))/2;
        
    elseif nargin == 2 && size(transformMatrix,1) == 3
        intrinsicMatrix_33 = transformMatrix;
        mesh_image_3V = intrinsicMatrix_33 * mesh_camera_3V;
        mesh_image_2V = bsxfun(@rdivide, mesh_image_3V(1:2,:), mesh_image_3V(3,:));

    end
    
end