function [return_value] = draw_countour_plot(FILE_NAME)

file_2d = double( imread(FILE_NAME, 1) );
contour(file_2d);