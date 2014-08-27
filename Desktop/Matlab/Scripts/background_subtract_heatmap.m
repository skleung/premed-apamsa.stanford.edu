function [ output_args ] = background_subtract_heatmap(bg_sum_MRLC_fname,  sum_MRLC_fname)

%set info
info_MRLC = imfinfo(sum_MRLC_fname);
x = info_MRLC(1).Width;
y = info_MRLC(1).Height;

info_bg_MRLC = imfinfo(bg_sum_MRLC_fname);
x = info_MRLC(1).Width;
y = info_MRLC(1).Height;









end

