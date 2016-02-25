
% Arguments:
%   vertex_V3   3D coordinates XYZ of each vertex (V vertices in mesh)
%   face_F3     indices of the 3 vertices for each face (F faces in mesh)
%
function normal_3F = getFaceNormal(vertex_3V,face_3F)
    
  F = size(face_3F,2);  % nb faces

  % vertexCoordinatesPerFace_33F contains the 3D coordinates (first dim)
  % of the three vertices (second dim) of the F faces (third dim)
  vertexCoordinatesPerFace_33F = ...
    reshape( vertex_3V( 1:3, face_3F(:) ), [3 3 F]);
  
  
  % Get the face normal by cross-product of the triangle edges
  v3_minus_v2_31F = ...
    vertexCoordinatesPerFace_33F(:,3,:)-vertexCoordinatesPerFace_33F(:,2,:);
  v2_minus_v1_31F = ...
    vertexCoordinatesPerFace_33F(:,2,:)-vertexCoordinatesPerFace_33F(:,1,:);
  normal_3F = reshape( cross(v2_minus_v1_31F, v3_minus_v2_31F, 1), [3 F]);
  
  % Normalize each normal
  norm_1F = sqrt(sum(normal_3F .^ 2,1));
  normal_3F = bsxfun(@rdivide, normal_3F, norm_1F);
  
  
%   % Initialize result  
%   normal_3F = NaN(3,F);
% 
%   % Iterate through the faces
%   for f = 1:F 
% 
%     v3_minus_v2_THISFACE_311 = ...
%       vertexCoordinatesPerFace_33F(:,3,f)-vertexCoordinatesPerFace_33F(:,2,f);
%     v2_minus_v1_THISFACE_311 = ...
%       vertexCoordinatesPerFace_33F(:,2,f)-vertexCoordinatesPerFace_33F(:,1,f);
% 
%     normal_THISFACE_311 = cross(v3_minus_v2_THISFACE_311, v2_minus_v1_THISFACE_311, 1);
%   
%     normal_3F(:,f) = normal_THISFACE_311;
%     
%   end
% 
%   % Normalize each normal
%   norm_1F = sqrt(sum(normal_3F .^ 2,1));
%   normal_3F = bsxfun(@rdivide, normal_3F, norm_1F);

    
end




% function normal_3F = getFaceNormal(vertex_3V,face_3F)
%     
%     normal_3F = NaN(3, size(face_3F,2));
%     for i = 1: size(face_3F,2)    
%       normal_3F(:,i) = calculateNormal(vertex_3V(:,face_3F(1,i)), ...
%         vertex_3V(:,face_3F(2,i)), vertex_3V(:,face_3F(3,i)))';
%     end
%     
% end
% 
% 
% function normal = calculateNormal(v1, v2, v3)
%   
% 	% cross %
% 	%     i            j            k
% 	% v2(1) - v1(1)  v2(2) - v1(2)  v2(3) - v1(3)
% 	% v3(1) - v2(1)  v3(2) - v2(2)  v3(3) - v2(3)
% 	normal(1) = (v2(2) - v1(2)).*(v3(3) - v2(3)) - (v3(2) - v2(2)).*(v2(3) - v1(3));
% 	normal(2) = (v3(1) - v2(1)).*(v2(3) - v1(3)) - (v2(1) - v1(1)).*(v3(3) - v2(3));
% 	normal(3) = (v2(1) - v1(1)).*(v3(2) - v2(2)) - (v3(1) - v2(1)).*(v2(2) - v1(2));
% 	l = sqrt(normal(1).*normal(1) + normal(2).*normal(2) + normal(3).*normal(3));
% 	normal(1) = normal(1) ./ l;
% 	normal(2) = normal(2) ./ l;
%   normal(3) = normal(3) ./ l;
%   
% end