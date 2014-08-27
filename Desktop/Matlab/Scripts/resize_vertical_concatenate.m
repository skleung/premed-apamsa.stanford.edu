function [return_value] = resize_vertical_concatenate(top_image, middle_image, bottom_image, T)
% function resizes the given images so that the widthes are equal, and
% concatenates them vertically. 

%get infos
info_top = imfinfo(top_image);
info_middle = imfinfo(middle_image);
x_t = info_top(1).Width;
y_t = info_top(1).Height;
x_m = info_middle(1).Width;
y_m = info_middle(1).Height;
scale_factor_middle = x_t / x_m;
if bottom_image ~= ''
    info_bottom = imfinfo(bottom_image);
    x_b = info_bottom(1).Width;
    y_b = info_bottom(1).Height;
    scale_factor_bottom = x_t / x_b;
end

save_fname = ['concatenated_image' top_image];
for t = 1 : T
    image_top = imread(top_image, t, 'Info', info_top);
    image_middle = imread(middle_image, t, 'Info', info_middle);    
    resized_middle = imresize(image_middle, scale_factor_middle);
    new_image = [image_top;resized_middle];
    
    if bottom_image ~= ''
        image_bottom = imread(bottom_image, t, 'Info', info_bottom);
        resized_bottom = imresize(image_bottom, scale_factor_bottom);
        new_image = [new_image;resized_bottom];
    end
    
    if t == 1
        imwrite(new_image, save_fname, 'writemode', 'overwrite', 'Compression', 'none');
    else
        imwrite(new_image, save_fname, 'writemode', 'append', 'Compression', 'none');
    end
    
end

end