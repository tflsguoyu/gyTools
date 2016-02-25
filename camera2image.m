function mesh_image_2V = ...
    camera2image(mesh_camera_3V, ...
    intrinsicMatrix_33)    

    mesh_image_3V = intrinsicMatrix_33 * mesh_camera_3V;
    mesh_image_2V = bsxfun(@rdivide, mesh_image_3V(1:2,:), mesh_image_3V(3,:));
    
end