function img_sRGB = raw2sRGB(img_raw, par_flag)

    img_raw_reshape = reshape(img_raw, [size(img_raw,1)*size(img_raw,2) 3]);
    

    if nargin > 1

        parfor i = 1:3
            img_sRGB_reshape(:,i) = LUT_raw2sRGB(img_raw_reshape,i);
        end

    else

        for i = 1:3
            img_sRGB_reshape(:,i) = LUT_raw2sRGB(img_raw_reshape,i);
        end

    end

    img_sRGB = reshape(img_sRGB_reshape, [size(img_raw,1) size(img_raw,2) 3]);
    
end

function img_out = LUT_raw2sRGB(img_in,flag)
    
    load('LUT_raw2sRGB.mat');
    switch flag
        case 1
            img_out = r_LUT_raw2sRGB(img_in);
        case 2
            img_out = g_LUT_raw2sRGB(img_in);
        case 3
            img_out = b_LUT_raw2sRGB(img_in);
    end

end