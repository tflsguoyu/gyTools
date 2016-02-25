classdef PYTools
    
    properties
    end
    
    methods(Static)
       
        % Function to convert column vector to string separated with white spaces
        function str = ColumnVectorToString(vec)

            str = '';
            for i=1:size(vec,1)
               str = [str sprintf('%f',vec(i, 1)) ' '];
            end

        end    
        
        % Use Irfanview to change the format of an image file
        function ConvertImage(folder, sourceFilename, targetFilename)

            batchPath = [ 'D:\home\pylaffon\Relighting\Matlab_Projects\PYClasses\' ...
                'irfanview_convert.cmd' ];            
            commandLine = ['start /B /wait ' batchPath ' ' fullfile(folder, ' ') ' ' ...
                sourceFilename ' ' targetFilename] ;
            system(commandLine);
            
        end
        
        % Convert all the exr images from one folder, into another image format
        function ConvertExrFolder(folder, targetFormat, gamma)
          
            if (nargin < 3)
              gamma = 1;
            end

            if (folder(end:end) ~= '/' && folder(end:end) ~= '\')
                folder = [folder '/'];
            end
            
            list_files = dir([folder '*.exr']);
%             list_files = list_files(3:end);     % remove '.' and '..'

            for i=1:length(list_files)
                
                filename = list_files(i).name;
                basename = filename(1:end-4);
                extension = filename(end-3:end);
                
                % Only consider files with '.exr' extension
                if (strcmp(extension, '.exr'))
                    img = exrread([folder filename]);
                    imwrite(img .^ gamma, [folder basename '.' targetFormat], targetFormat);
                end
                
            end
            
        end        
        
        % Vectorize matrix
        function vec = VectorizeMatrix(mat, rows, cols)
           vec = reshape(mat, rows*cols, size(mat,3));
           %vec = mat(:);
        end
        
        % Unvectorize matrix
        function mat = UnvectorizeMatrix(vec, rows, cols)
            mat = reshape(vec, rows, cols, size(vec,2));
        end
        
        % Function to transform a matrix into a column vector
        function vec = ToColumnVector(mat)
          vec = mat(:);
        end
        
        % Display 3D matrix as 2D surface
        function s = Display3DMatrixAsSurface(mat)
            % Display intensity surface
            intensity = zeros(size(mat, 1), size(mat, 2));
            for i=1:size(mat, 3)
                intensity(:,:) = intensity(:,:) + mat(:,:,i).^2;
            end
            intensity = sqrt(intensity);
            s = surf(intensity); rotate3d;
        end
        
        % Fast replacement of SUB2IND (Linear index from multiple subscripts)
        % in dimension 2; no check is performed.
        function ind = Sub2ind_fast2(siz, i, j)
            ind = i + (j-1)*siz(1);
        end        
        
        % Fast replacement of SUB2IND (Linear index from multiple subscripts)
        % in dimension 3; no check is performed.
        function ind = Sub2ind_fast3(siz, i, j, k)
            ind = i + (j-1)*siz(1) + (k-1)*siz(1)*siz(2);
        end
        
        % Normalize all matrix rows
        function [mat_out, rowNorm] = NormalizeRows(mat_in)
            rowNorm = sqrt(sum(mat_in .^2, 2));
            nonZeroRows = find(rowNorm > 0);
            
            % Rows with 0 norm are replaced by NaN rows
            mat_out = NaN(size(mat_in));
            mat_out(nonZeroRows,:) = mat_in(nonZeroRows,:) ...
                ./ repmat(rowNorm(nonZeroRows), 1, size(mat_in,2));
        end        
        
        function [mat_out, colNorm] = NormalizeColumns(mat_in)
          
            inputSize = size(mat_in);
            D = inputSize(1);
            mat_in_DC = reshape(mat_in, D, []);
            
            colNorm_1C = sqrt(sum(mat_in_DC .^2, 1));
            nonZeroCols = find(colNorm_1C > 0);
            
            % Cols with 0 norm are replaced by NaN cols
            mat_out_DC = NaN(size(mat_in_DC));
            mat_out_DC(:,nonZeroCols) = bsxfun(@rdivide, ...
              mat_in_DC(:,nonZeroCols), colNorm_1C(1,nonZeroCols) );
            
            % Output is the same size as the input
            mat_out = reshape(mat_out_DC, inputSize);
            colNormSize = inputSize;
            colNormSize(1) = 1;
            colNorm = reshape(colNorm_1C, colNormSize);
            
        end        
        
        
        % Construct an image composed of NxM colored squares
        % - colorScale is a NxM matrix containing the squares colors
        % - squareSize is the width and height of each square
        function img = buildColorScaleImage(colorScale, squareSize)

          nbRows = size(colorScale,1);
          nbCols = size(colorScale,2);
          nbChannels = size(colorScale,3);

          img = zeros(nbRows*squareSize,nbCols*squareSize,nbChannels);

          for i=1:nbRows
              for j=1:nbCols

                  colorToSet = colorScale(i,j,:);
                  for k=1:nbChannels
                      img(1+(i-1)*squareSize:i*squareSize, ...
                          1+(j-1)*squareSize:j*squareSize, k) ...
                          = colorToSet(k);
                  end

              end
          end

        end        
        

        function DisplayColorScale(minValue, maxValue, width, height, nbLabels, isLogScale)

          % Create image showing the colormap
          cmap = colormap;
          imgColormap = imresize(reshape(cmap(end:-1:1,:),[size(cmap,1) 1 size(cmap,2)]), [height width]);
%           imshow(imgColormap,'Border','Tight');
          imshow(imgColormap);
          
          if (maxValue > minValue)
            ticksValues = linspace(minValue, maxValue, nbLabels);
            ticksCmapIndices = 1 + (ticksValues - minValue) * (length(cmap)-1) / (maxValue - minValue);
          elseif (maxValue == minValue)
            ticksValues = [minValue maxValue];
            ticksCmapIndices = [1 length(cmap)];
          else
            assert(0);
          end
          
          if ~isLogScale
            ticksLabels = ticksValues;
          else
            ticksLabels = exp(ticksValues);
          end
          colorbar('YTick',ticksCmapIndices,'YTickLabel',ticksLabels)
          
        end                
        
        function gammaColor = ApplyGamma(linearColor) 

          % linearize
          gammaColor = real(linearColor .^ (1/2.2));

          % enforce the [0 1] range
          gammaColor = min(gammaColor, 1);
          gammaColor = max(gammaColor, 0);

          % convert to uint8 between 0 and 255
          gammaColor = uint8(round(255 * gammaColor));
          
        end        
        
        function SaveLinearImageWithNaNs(imgLinear, outputFilename, colorNaN)
          
          if (nargin < 3)
            colorNaN = [0 0 0];
          end
          
          if (size(imgLinear,3) == 1)
            imgLinear = repmat(imgLinear, [1 1 3]);
          end
          
          % Locate pixels with NaN values in at least one channel
          nanPixels = find(sum(isnan(imgLinear), 3) > 0);
          
          % Apply gamma to the linear image
          imgGamma = PYTools.ApplyGamma(imgLinear);
          
          % Replace pixels containing NaN values
          for k=1:size(imgGamma,3)
            imgGamma_channelK = imgGamma(:,:,k);
            imgGamma_channelK(nanPixels) = colorNaN(k);
            imgGamma(:,:,k) = imgGamma_channelK;
          end
          
          % Save image to disk, depends on the image type
          dotPosition = strfind(outputFilename,'.');
          if isempty(dotPosition)
            error('No format specified for output image.');
          end
          imageFormat = outputFilename(dotPosition(end)+1:end);
          switch lower(imageFormat)
            case 'png'
              imwrite(imgGamma, outputFilename);
            case 'jpg'
              imwrite(imgGamma, outputFilename, 'Mode', 'lossy', 'Quality', 100);
            otherwise
              error('Format not supported for output image.');
          end
          
          
        end
        
        
        % Take a NxC matrix as input, average it over the C channels,
        % then output a Nx1 vector with values between 0 and 1,
        % corresponding in the original matrix to a bracket around the
        % mean and with length equal to sigmaRange times the standard deviation
        function normalizedValues = NormalizeAndBoundAroundMean(values, sigmaRange)
          
          % Average the values on all color channels
          averageOverChannels = mean(values, 2);
          
          % Center values on the mean
          centerValueOriginal = mean(averageOverChannels);
          
%           % Center value on the median
%           centerValueOriginal = median(averageOverChannels);
          
          % Clompute variance around the center value
          varOriginal = mean((averageOverChannels - centerValueOriginal).^2);
          
          % Deduce standard deviation
          stdDevOriginal = sqrt(varOriginal);
          
          normalizedValues = ...
            (averageOverChannels - (centerValueOriginal - sigmaRange*stdDevOriginal) ) ...
            / (2*sigmaRange*stdDevOriginal);
          
          % Clamp normalized values between 0 and 1
          normalizedValues = max(0, normalizedValues);
          normalizedValues = min(1, normalizedValues);
          
        end
        
        
        % Converts a N vector to RGB colors, using the current colormap;
        % returns a Nx3 matrix
        function color = ValueToCmapColor(value, minBound, maxBound)
          if nargin == 1
            minBound = 0;
            maxBound = 1;
          end
          
          cmap = colormap('jet');
          valueNormalized01 = (value - minBound) ./ (maxBound - minBound);
          valueNormalized01 = max(0, min(1, valueNormalized01));
          color = cmap(1+round(valueNormalized01*(size(cmap,1)-1)),:);
          
          % NaN values in the input lead to NaN in the output
          color(find(isnan(value)),:) = NaN;
        end
        
        function imgColorMapped = ImageToColorMappedImage(imgInput, setZeroPixelsToBlack)
          
          assert(size(imgInput,3) == 1);
          
          imgInput_vec = PYTools.VectorizeMatrix(imgInput, ...
            size(imgInput,1), size(imgInput,2));
          
          imgColorMapped_vec = PYTools.ValueToCmapColor(imgInput_vec, 0, max(imgInput_vec));
          
          % Pixels that were 0, inf or NaN in the input, 
          % should be black in the output
          imgColorMapped_vec(isinf(imgInput_vec) | isnan(imgInput_vec)) = 0;
          if setZeroPixelsToBlack
            imgColorMapped_vec(imgInput_vec == 0) = 0;
          end
          
          imgColorMapped = PYTools.UnvectorizeMatrix(imgColorMapped_vec, ...
            size(imgInput,1), size(imgInput,2));
          
        end
        
        
        function ImWriteTransparency(img, outputFilename, transparentColor)
          if (nargin < 3 || (size(transparentColor,2) ~= size(img,3)))
            imwrite(img,outputFilename);
          else
            % If a transparency color has been defined, 
            % detect pixels with this color on the captured frame
            % and make them transparent in the output image
            img_vec = PYTools.VectorizeMatrix(img, size(img,1), size(img,2));
            transp_vec = ismember(img_vec, transparentColor, 'rows');
            transp_mat = 1 - double(PYTools.UnvectorizeMatrix(...
              transp_vec, size(img,1), size(img,2)));
            imwrite(img,outputFilename,'Alpha',transp_mat);
          end
        end
        
        function imgOverlay = AddSparseImageOnBackground(imgSparse, imgBackground, emptyValues)
          
          assert(size(imgSparse,3) == 3);
          assert(size(imgBackground,3) == 3);
          assert(length(emptyValues) == 3);
          
          height = size(imgSparse,1);
          width = size(imgSparse,2);
          assert(height == size(imgBackground,1));
          assert(width == size(imgBackground,2));
          
          imgSparse_vec = PYTools.VectorizeMatrix(imgSparse,height,width);
          imgBackground_vec = PYTools.VectorizeMatrix(imgBackground,height,width);
          
          % Set pixels that have a sparse value, to 0 in the background image
          hasPixelSparseValue_vec = repmat(~ismember(imgSparse_vec,emptyValues(:)','rows'), [1 3]);
          
          imgOverlay = PYTools.UnvectorizeMatrix(...
            hasPixelSparseValue_vec .* imgSparse_vec + ...
            ~hasPixelSparseValue_vec .* imgBackground_vec, ...
            height, width);
          
          
        end
        
        
        function [ imgError ] = DisplayErrorImg( img1, img2, scaleFactor )
          
          if (nargin < 3)
            scaleFactor = 1;
          end

          imgError = abs(img1 - img2);
%           figure; imshow(scaleFactor * imgError)

        end
        
        
        function CaptureFrame(hFig, outputFilename, width, height, relocateLegend, transparentColor)
          
%           % Resize frame
%           border = 50;
%           screenSize = get(0,'ScreenSize');
%           rect = [1 1 width, height];
%           set(hFig,'Position',rect);
%           rect = get(hFig,'OuterPosition');
%           rect(1) = 1;
%           rect(2) = 1;
%           set(hFig,'OuterPosition',rect);          
%           
%           % Use export_fig to save the figure at native resolution
%           % (parameters width and height are then ignored)
%           figure(hFig);
%           set(gca,'color','none');  % use transparent background
%           export_fig(outputFilename, '-m1', '-a1');
          
          % Below is the version based on capturing the screen
          %%{
          % Resize frame
          if (~isempty(width) && ~isempty(height))
            border = 50;
            screenSize = get(0,'ScreenSize');
            rect = [1 1 width, height];
            set(hFig,'Position',rect);
            rect = get(hFig,'OuterPosition');
            rect(1) = 1;
            rect(2) = 1;
            set(hFig,'OuterPosition',rect);
          end
          
          % Re-locate the legend box
          if (nargin > 4 && relocateLegend)
            legend('Location', 'Best');
          end
          

          % Capture the frame and save it to disk
          [cdata, ~] = getframe(hFig);
          
%           if (nargin < 6 || (size(transparentColor,2) ~= size(cdata,3)))
%             imwrite(cdata,outputFilename);
%           else
%             % If a transparency color has been defined, 
%             % detect pixels with this color on the captured frame
%             % and make them transparent in the output image
%             cdata_vec = PYTools.VectorizeMatrix(cdata, size(cdata,1), size(cdata,2));
%             transp_vec = ismember(cdata_vec, transparentColor, 'rows');
%             transp_mat = 1 - double(PYTools.UnvectorizeMatrix(transp_vec, size(cdata,1), size(cdata,2)));
%             imwrite(cdata,outputFilename,'Alpha',transp_mat);
%           end
          if (nargin < 6)
            imwrite(cdata,outputFilename);
          else
            PYTools.ImWriteTransparency(cdata, outputFilename, transparentColor);
          end
          
          %%}
        end
        
%         % UNSUCCESSFUL TRIALS:
%         function CaptureFrame(hFig, outputFilename, width, height, relocateLegend)
% 
%           
%           
%           hAxes = get(hFig, 'CurrentAxes');
% %           set(hAxes,'Position',[0 0 1 1]);          
% 
%           % Replace and resize frame
%           border = 50;
%           screenSize = get(0,'ScreenSize');
%           rect = [1 1 width, height];
%           set(hFig,'Position',rect);
% %           rect = get(hFig,'OuterPosition');
% %           rect(1) = 1;
% %           rect(2) = 1;
% %           set(hFig,'OuterPosition',rect);
% 
%           hFigWidth = ( 1 + (0.0500+ 0.0188) ) * width;
%           hFigHeight = ( 1 ) * height;
%           set(hFig,'Position',[1 1 hFigWidth hFigHeight]);
% 
%           
%           % Re-locate the legend box
%           if (nargin > 4 && relocateLegend)
%             legend('Location', 'Best');
%           end
%           
%           % Capture the frame and save it to disk
%           [cdata, ~] = getframe(hAxes,[1 1 width height]);
%           imwrite(cdata,outputFilename);
% %           [cdata, ~] = getframe(hAxes);
%         end
        

        % use HARDCOPY (undocumented feature of Matlab) to capture the
        % figure as displayed, without changing its size
        function img = CaptureFigureAtScreenSize(hFig, setWhiteBackground)
          
          if setWhiteBackground
            set(hFig,'Color',[1 1 1]);
          end
          
          orig_mode = get(hFig, 'PaperPositionMode');
          set(hFig, 'PaperPositionMode', 'auto');
          img = hardcopy(hFig, '-Dzbuffer', '-r0'); %hardcopy is an undocumented feature of Matlab, see: http://www.mathworks.com/support/solutions/en/data/1-3NMHJ5/?solution=1-3NMHJ5
          set(hFig, 'PaperPositionMode', orig_mode);
          
        end

        
        % Compute the origin and directions of rays cast from the camera
        % center, towards the samples whose pixel coordinates are given
        %
        % - samplesPositionXY is a 2xK matrix contains the pixel coordinates 
        %     of the samples, where K is the number of samples; 
        %     first row is X in [1:width] , second is Y in [1:height]
        % 
        % Returns:
        % - rayDirectionWorldSpace is a 3xK matrix containing the unit
        %     direction of the rays towards the K samples
        % - rayOriginWorldSpace is a 3x1 vector that represents 
        %     the origin of all rays
        %
        function [rayDirectionWorldSpace, rayOriginWorldSpace] = ...
            GenerateRays(samplesPositionXY, imageWidth, imageHeight, intrinsicMatrix, extrinsicMatrix)
        
          K = size(samplesPositionXY,2);
          
          % Compute the coordinates of the samples in normalized screen space
          pmvsNormalizedScreenPosition = zeros(2, K);
          pmvsNormalizedScreenPosition(2,:) ...
            = (samplesPositionXY(2,:)'-1) / (imageHeight-1);  % between 0 and 1 (inclusive)
          pmvsNormalizedScreenPosition(1,:) ...
            = (samplesPositionXY(1,:)'-1) / (imageWidth-1);  % between 0 and 1 (inclusive)
          pmvsNormalizedScreenPosition = 2 * pmvsNormalizedScreenPosition - 1;   % between -1 and 1
          pmvsNormalizedScreenPosition(2,:) = pmvsNormalizedScreenPosition(2,:) * -1;   % swap Y axis
          pmvsNormalizedScreenPosition = max(-1, min(1, pmvsNormalizedScreenPosition ) ); % clamp values to [-1 1]

          % Get camera coordinates of a point along the ray, that lies on the near plane
          pmvsPointOnNearPlaneScreenSpace = zeros(4, K);
          pmvsPointOnNearPlaneScreenSpace(1:2, :) = pmvsNormalizedScreenPosition;
          pmvsPointOnNearPlaneScreenSpace(3, :) = -1; % it's on the near plane
          pmvsPointOnNearPlaneScreenSpace(4, :) = 1;  % it's a point, not vector
          pmvsPointOnNearPlaneCameraSpace = intrinsicMatrix \ pmvsPointOnNearPlaneScreenSpace;
%           pmvsPointOnNearPlaneCameraSpace = inv(intrinsicMatrix) * pmvsPointOnNearPlaneScreenSpace;

          % Deduce the direction of the rays in camera and world space
          rayDirectionCameraSpace = pmvsPointOnNearPlaneCameraSpace;
          rayDirectionCameraSpace(4, :) = 0; % it's a vector, whose origin is [0 0 0 1]
          rayDirectionWorldSpace = extrinsicMatrix \ rayDirectionCameraSpace;
%           rayDirectionWorldSpace = inv(extrinsicMatrix) * rayDirectionCameraSpace;

          % Finally return a 3D direction with unit length
          vectorNorm = sqrt(sum(rayDirectionWorldSpace.^2,1));
          rayDirectionWorldSpace = bsxfun(@rdivide, ...
            rayDirectionWorldSpace(1:3, :), vectorNorm);
          
          % Also return the origin of the rays in world space
          rayOriginWorldSpace = extrinsicMatrix \ [0 0 0 1]';
%           rayOriginWorldSpace = inv(extrinsicMatrix) * [0 0 0 1]';
          rayOriginWorldSpace = rayOriginWorldSpace(1:3) / rayOriginWorldSpace(4);
          
        end
        

        % Project 3d points onto the image plane (given camera matrices)
        % and return their pixel location
        %
        % - pointsInWorld is a 3xP or 4xP (if specified in homogeneous coordinates)
        %     matrix contains the coordinates of P points in world frame; 
        % 
        % Returns:
        % - pixelsInImage is a 2xP matrix containing the pixel coordinates
        %     of the points in the image
        %     (first row is X in [1:width], second is Y in [1:height]),
        % - pointsOutOfBounds is a P-array of boolean, where true
        %     means that the 3D point projects out of the image boundaries
        %
        function [pixelsInImage, pointsOutOfBounds] = ...
          ProjectWorldPointsToImage(pointsInWorld, imageWidth, imageHeight, intrinsicMatrix, extrinsicMatrix)

          P = size(pointsInWorld,2);
          if (P == 0)
            pixelsInImage = [];
            return;
          end

          % Convert point world coordinates to homogeneous with 4th coord = 1
          if (size(pointsInWorld,1) == 4)
            pointsInWorldHomogeneous = bsxfun(@rdivide, pointsInWorld, pointsInWorld(4,:));
          else
            pointsInWorldHomogeneous = vertcat(pointsInWorld, ones(1,P));
          end

          % Compute 3d position of points in camera space
          if size(extrinsicMatrix,1) == 3
            extrinsicMatrix = vertcat(extrinsicMatrix,[0 0 0 1]);
          end
          pointsInCamera = extrinsicMatrix * pointsInWorldHomogeneous;
          pointsInCamera = bsxfun(@rdivide, pointsInCamera, pointsInCamera(4,:));

          % Compute the projection of points on the normalized device coordinates
          % (screen)
          pointsInNDC = intrinsicMatrix * pointsInCamera;
          pointsInNDC = bsxfun(@rdivide, pointsInNDC, pointsInNDC(4,:));

          % Set a warning flag for 3D points that project out of the image
          % boundaries
          pointsOutOfBounds = sum(abs(pointsInNDC) > 1, 1) > 0 ;
          
          % Convert normalized screen space to Matlab image coordinates
          pointsInNDC_temp = max(-1, min(1, pointsInNDC ) );
%           pointsInNDC_temp = pointsInNDC;
          pointsInNDC_temp(2,:) = pointsInNDC_temp(2,:) * -1;   % swap Y axis
          pointsInNDC_temp = (1 + pointsInNDC_temp) / 2.0;   % between 0 and 1
          pixelsInImage = zeros(2,P);
%           pixelsInImage(1,:) = 1 + (imageWidth-1) * pointsInNDC_temp(1,:);  % between 1 and height
%           pixelsInImage(2,:) = 1 + (imageHeight-1) * pointsInNDC_temp(2,:);  % between 1 and width
epsilon = 1e-4; % this epsilon is used so that, once rounded to nearest integer, the 2d position falls between 1 and width or height
          pixelsInImage(1,:) = 0.5 + epsilon + (imageWidth - 2*epsilon) * pointsInNDC_temp(1,:);  % between 0.5 and width+0.5
          pixelsInImage(2,:) = 0.5 + epsilon + (imageHeight - 2*epsilon) * pointsInNDC_temp(2,:);  % between 0.5 and height+0.5

        end


        function PlayGong()
          gong(1,1000,0.5);gong(1,1000,0.5);gong(1,2500,3);
%           beepDuration = 1.0/nbBeepsPerSecond;
%           for k=1:nbSeconds*nbBeepsPerSecond,
%             beep;
%             pause(beepDuration);
%           end
        end

        function fileList = DirSortByName(dirArgument)
          
          dirResult = dir(dirArgument);
          fileList = {dirResult.name}; % cell array of file names
          
          [~,sortingOrder] = sort(lower(fileList));
          fileList = fileList(sortingOrder);
          
        end
        
        
    end
    
end
