function img_raw = readDNG(dngFilenamePATH)

    fullFunctionName = which('readDNG');
    fullFolderName = fullFunctionName(1:end-length('readDNG')-3);

    command = [fullFolderName '\dcraw -4 -T -o 1 ' dngFilenamePATH];
    status = system(command);
    tiffFilenamePATH = [dngFilenamePATH(1:end-4) '.tiff'];
    img_raw = im2double(imread(tiffFilenamePATH));

    delete(tiffFilenamePATH);
end