function img_sRGB = raw2sRGB(img_raw, par_flag)

    load('LUT_raw2sRGB.mat');

    img_raw_reshape = reshape(img_raw, [size(img_raw,1)*size(img_raw,2) 3]);
    

    if nargin > 1

        parfor i = 1:3
            switch i
                case 1
                    img_sRGB_reshape(:,i) = r_LUT_raw2sRGB(img_raw_reshape);
                case 2
                    img_sRGB_reshape(:,i) = g_LUT_raw2sRGB(img_raw_reshape);
                case 3
                    img_sRGB_reshape(:,i) = b_LUT_raw2sRGB(img_raw_reshape);
            end
        end

    else

        for i = 1:3
            switch i
                case 1
                    img_sRGB_reshape(:,i) = r_LUT_raw2sRGB(img_raw_reshape);
                case 2
                    img_sRGB_reshape(:,i) = g_LUT_raw2sRGB(img_raw_reshape);
                case 3
                    img_sRGB_reshape(:,i) = b_LUT_raw2sRGB(img_raw_reshape);
            end
        end

    end

    img_sRGB = reshape(img_sRGB_reshape, [size(img_raw,1) size(img_raw,2) 3]);
    
end