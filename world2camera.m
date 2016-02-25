function mesh_camera_3V = ...
    world2camera(mesh_world_3V, ...
    extrinsicMatrix_34) 
  
  numMesh = size(mesh_world_3V, 2);
  
  R = extrinsicMatrix_34(:,1:3);
  T = extrinsicMatrix_34(:,4); 
  
  mesh_camera_3V = R * mesh_world_3V + repmat(T, [1,numMesh]);
  
end