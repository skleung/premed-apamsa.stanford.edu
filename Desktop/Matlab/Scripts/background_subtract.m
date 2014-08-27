function [ output_args ] = background_subtract(bg_sum_fname,  sum_fname)

%set info
info_image = imfinfo(sum_fname);
x = info_MRLC(1).Width;
y = info_MRLC(1).Height;

info_bg = imfinfo(bg_sum_fname);
x_bg = info_MRLC(1).Width;
y_bg = info_MRLC(1).Height;









end

