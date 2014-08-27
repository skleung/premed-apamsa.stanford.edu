function [ output_args ] = background_subtract_fix_and_stain(bg_sum_fname, fname, Z)

%set info
info_image = imfinfo(fname);
x = info_image(1).Width;
y = info_image(1).Height;
save_fname = ['bgc_' fname];

info_bg = imfinfo(bg_sum_fname);
x_bg = info_bg(1).Width;
y_bg = info_bg(1).Height;

%calculate the average of all pixels in background pixels
bg_image = imread(bg_sum_fname, 'Info', info_bg);
sum_bg = 0;
for i = 1 : x_bg
    for j = 1 : y_bg
        sum_bg = sum_bg + bg_image(j, i);
    end
end
avg_bg = sum_bg / (x_bg * y_bg) / Z;

%build 3d matrices and subtract background
image_3d = zeros(x, y, Z);
for k = 1 : Z
    image_3d(:,:,k) = double( imread(fname, k) ) - avg_bg;
end

%writing to a new file-----------
for k = 1 : Z
    if k == 1
        imwrite( uint16( image_3d(:, :, k) ) , save_fname );
    else
        imwrite( uint16( image_3d(:, :, k) ) , save_fname , 'writemode', 'append');
    end
end


end

