function img_raw_crop = readDNG_BMCC(dngFilenamePATH)

    fullFunctionName = which('readDNG');
    fullFolderName = fullFunctionName(1:end-length('readDNG')-3);

    command = [fullFolderName '\dcraw -4 -T -o 1 ' dngFilenamePATH];
    status = system(command);
    
    tiffFilenamePATH = [dngFilenamePATH(1:end-4) '.tiff'];
    img_raw = im2double(imread(tiffFilenamePATH));
    
    img_raw_crop = alignRAWtosRGB(img_raw);
    
    img_raw_crop(img_raw_crop<0) = 0;
    
    delete(tiffFilenamePATH);
    
end

function img_output = alignRAWtosRGB(img_input)

    img_scale = imresize(img_input, 0.7999);
    img_translate = imtranslate(img_scale, [-12.5958 0.2208]);
    img_output = img_translate(1:1080, 1:1920, :);

end