function vertexNormal_3V = getVertexNormal(vertex_3V,face_3F,faceNormal_3F)

  V = size(vertex_3V,2);
  F = size(face_3F,2);
  assert(size(faceNormal_3F,2) == F);

%   sumFaceNormalsPerVertex_3V = zeros(3,V);
%   for v = 1:V
%     [~,indicesFacesThisVertex] = find(face_3F == v);
%     sumFaceNormalsPerVertex_3V(:,v) = ...
%       sum(faceNormal_3F(:,indicesFacesThisVertex), 2);
%   end

  % Replace above code with an accum array
  face_F3 = face_3F';
  faceNormal_F13 = reshape(faceNormal_3F', [F 1 3]);
  faceNormalPerVertex_F33 = repmat(faceNormal_F13, [1 3 1]);
  sumFaceNormalsPerVertexX_V1 =  ...
    accumarray( face_F3(:), reshape(faceNormalPerVertex_F33(:,:,1), [3*F,1]), ...
    [V 1], @sum, NaN );  
  sumFaceNormalsPerVertexY_V1 =  ...
    accumarray( face_F3(:), reshape(faceNormalPerVertex_F33(:,:,2), [3*F,1]), ...
    [V 1], @sum, NaN );  
  sumFaceNormalsPerVertexZ_V1 =  ...
    accumarray( face_F3(:), reshape(faceNormalPerVertex_F33(:,:,3), [3*F,1]), ...
    [V 1], @sum, NaN );  
  sumFaceNormalsPerVertex_3V = vertcat(sumFaceNormalsPerVertexX_V1', ...
    sumFaceNormalsPerVertexY_V1', sumFaceNormalsPerVertexZ_V1');

  % Now compute the average normal per vertex, and normalize
  norm_1V = sqrt(sum(sumFaceNormalsPerVertex_3V.^2,1));
  vertexNormal_3V = bsxfun(@rdivide, ...
    sumFaceNormalsPerVertex_3V, norm_1V);
  
end

% function normal_3V = getVertexNormal(vertex_3V,face_3F,face_normal_3F)
% 
%   % TODO: use accumarray here instead of for loop with find
% 
%   normal_3V = NaN(3,size(vertex_3V,2));
%   for i = 1: size(vertex_3V,2)
%     [~,index] = find(face_3F==i);
%     vertex_normal_31 = sum(face_normal_3F(:,index),2);
%     normal_3V(:,i) = vertex_normal_31/norm(vertex_normal_31);
%   end
% 
% end