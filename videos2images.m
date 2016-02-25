function videos2images(folderPath, inputVideoFormat, outputImageName, outputImageFormat, flag)

    listVideos = dir(fullfile(folderPath,['*.' inputVideoFormat]));
    videonameAll = {listVideos.name};
    
    numOfVideos = length(videonameAll);
    
    for videoID = 1 : numOfVideos

        disp(['Processing ' num2str(videoID) ' of ' num2str(numOfVideos) ' ...']);
        
        inputVideoName = videonameAll{videoID};
        
        obj = VideoReader(fullfile(folderPath, inputVideoName));
        numOfFrames = obj.NumberOfFrames;

        if flag == 0
        
            img_std = [];
            for i = 1:numOfFrames

              disp([num2str(i) ' of ' num2str(numOfFrames)]);	
              img = im2double(read(obj, i));
              img_gray = rgb2gray(img);
              img_fft = cv.Laplacian(img_gray);
              img_std(i) = std(img_fft(:));
              
            end
              id_img_std = [];
              [~, id_img_std] = sort(img_std);
              img = im2double(read(obj, id_img_std(end)));
              imwrite(img, fullfile(folderPath, sprintf([outputImageName '_%05d.' outputImageFormat], videoID)));

        else
            
            if flag <= numOfFrames
                img = read(obj, flag);
            else 
                img = read(obj, numOfFrames);
            end
            
            imwrite(img, fullfile(folderPath, sprintf([outputImageName '_%05d.' outputImageFormat], videoID)));
            
        end
        
    end
    
end