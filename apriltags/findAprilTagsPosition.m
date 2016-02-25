function aprilTags = findAprilTagsPosition(img, aprilTagType, threshold)

fullFunctionName_aprilTags = which('findAprilTagsPosition');
fullFolderName_aprilTags = fullFunctionName_aprilTags(1:end-length('findAprilTagsPosition')-3);

% img = imread(fullfile(fullFolderName_aprilTags, 'input.jpg')); % for testing

imwrite(img, fullfile(fullFolderName_aprilTags, 'tmp.pnm'));

    command = [fullfile(fullFolderName_aprilTags, 'patternDetection_april.bat') ' '...
        fullfile(fullFolderName_aprilTags) ' '...
        '-f' ' '...
        aprilTagType ' '...
        'tmp.pnm' ' '...
        'output.txt'];
    
    [status,cmdout] = system(command);
    
    cmdout = textread(fullfile(fullFolderName_aprilTags, 'output.txt'));
    
%%
numOfTags = size(cmdout,1)./5;

aprilTags = NaN(numOfTags,9);

removeFlag = [];
for i = 1: numOfTags
  
  aprilTags(i,1) = cmdout((i-1)*5+1,1);
  aprilTags(i,2:3) = cmdout((i-1)*5+2,1:2);
  aprilTags(i,4:5) = cmdout((i-1)*5+3,1:2);
  aprilTags(i,6:7) = cmdout((i-1)*5+4,1:2);
  aprilTags(i,8:9) = cmdout((i-1)*5+5,1:2);
  
  dist(1) = sqrt( (aprilTags(i,2) - aprilTags(i,4)).^2 + (aprilTags(i,3) - aprilTags(i,5)).^2 );
  dist(2) = sqrt( (aprilTags(i,4) - aprilTags(i,6)).^2 + (aprilTags(i,5) - aprilTags(i,7)).^2 );
  dist(3) = sqrt( (aprilTags(i,6) - aprilTags(i,8)).^2 + (aprilTags(i,7) - aprilTags(i,9)).^2 );
  dist(4) = sqrt( (aprilTags(i,8) - aprilTags(i,2)).^2 + (aprilTags(i,9) - aprilTags(i,3)).^2 );

  distMean = mean(dist);
  if distMean < threshold
    removeFlag = [removeFlag, i];
  end
  
  
end

% remove bad detection
aprilTags(removeFlag, :) = [];

%
delete(fullfile(fullFolderName_aprilTags, 'tmp.pnm'), fullfile(fullFolderName_aprilTags, 'output.txt'));

end
