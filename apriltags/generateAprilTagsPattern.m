function generateAprilTagsPattern(...
    tagType1, tagType2, tagStartID, ...
    tagSize, tagDistance, ...
    tagNumInWidth, tagNumInHeight, tagNumAll, ...
    OUTPUT_PATH_NAME)

    

    functionPATH = which('generateAprilTagsPattern');
    functionPATH(end-length('generateAprilTagsPattern')-2: end) = [];
    tagFolderName = ['tag' num2str(tagType1) 'h' num2str(tagType2)];    
    
    dpi = 1200;
    tagSizeInMeter = tagSize;
    tagSizeInPixel = tagSizeInMeter * dpi / 0.0254;
    
    tagDistanceInMeter = tagDistance;
    tagDistanceInPixel = tagDistanceInMeter * dpi / 0.0254;
    
    tagAllInPixel = tagSizeInPixel+tagDistanceInPixel;    
    tagAllInPixel = round(tagAllInPixel);
    
    aprilTagsPattern = uint8(255*zeros(1,1,3));
% tic
%     aprilTagsPattern = uint8(255*zeros(tagAllInPixel*tagNumInHeight,tagAllInPixel*tagNumInWidth,3));
% toc 
    k = 0;
    aprilTagsPattern_N13 = [];
    for h = 1: tagAllInPixel : tagAllInPixel*tagNumInHeight
        
        if k > tagNumAll
            break;
        end
        
        for w = 1: tagAllInPixel : tagAllInPixel*tagNumInWidth
            
            k = k + 1;
            
            if k > tagNumAll
                break;
            end
         
%             disp([num2str(k) ' of ' num2str(tagNumAll)]);
            
            i = tagStartID + k - 1;

            tagName = sprintf(['tag' num2str(tagType1) '_' num2str(tagType2) '_%05d.png'], i);        
            tagO = imread(fullfile(functionPATH, 'apriltagMarkers', tagFolderName, tagName));
            tagO = imcomplement(tagO);
            
            tagOSizeInPixel = size(tagO,1);
            tagSizeScale = tagSizeInPixel / tagOSizeInPixel;

            tag = imresize(tagO, tagSizeScale, 'nearest');

    %         figure; imshow(tag);
    %         guoyu = 1;

            tic;
            aprilTagsPattern = drawImgOnImg(aprilTagsPattern, [h,w], tag);
            timeElaps(k) = toc;
            
            aprilTagsPattern_N13 = [aprilTagsPattern_N13; 
                [i, ...
                w, h, 0, ...
                w+tagSizeInPixel, h, 0, ...
                w+tagSizeInPixel, h+tagSizeInPixel, 0, ...
                w, h+tagSizeInPixel, 0]];
            
        end
    end
    
    aprilTagsPattern = imcomplement(aprilTagsPattern);
    
    dpm = round(dpi/0.0254);
    imwrite(aprilTagsPattern, OUTPUT_PATH_NAME, ...
        'ResolutionUnit', 'meter', ...
        'XResolution', dpm, ...
        'YResolution', dpm);

    figure;plot(timeElaps);
    sum(timeElaps)

    [H,W,~] = size(aprilTagsPattern);
    aprilTagsPattern_N13(:,[2,5,8,11]) = (aprilTagsPattern_N13(:,[2,5,8,11]) - W/2) * 0.0254/dpi;
    aprilTagsPattern_N13(:,[3,6,9,12]) = (H/2 - aprilTagsPattern_N13(:,[3,6,9,12])) * 0.0254/dpi;
    
    save([OUTPUT_PATH_NAME(1:end-4) '.mat'], 'aprilTagsPattern_N13');
    
end

function outputImg = drawImgOnImg(inputImg, topLeftCorner_hw, addonImg)

    outputImg = inputImg;
    [addonSize_h, addonSize_w, ~] = size(addonImg);
    outputImg(topLeftCorner_hw(1):topLeftCorner_hw(1)+addonSize_h-1, ...
        topLeftCorner_hw(2):topLeftCorner_hw(2)+addonSize_w-1, :) = addonImg;
    
end

