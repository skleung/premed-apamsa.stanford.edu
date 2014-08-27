function [return_value] = arrow_pointing(kymo_filename, num_time_points)

save_fname = ['save_' kymo_filename];
kymo_2d = imread(kymo_filename);

%determine starting location, increments
starting_x = 405;
starting_y = 32;
ending_y = 384;
increment = (ending_y - starting_y)/num_time_points;

%determine shape of arrow
head_length = 10;
tail_length = 20;
head_width = 10;
tail_width = 5;



%{
point 1: (starting_x, starting_y)
point 2: (starting_x + head_length, starting_y - head_width)
point 3: (starting_x + head_length, starting_y - (0.5*tail_width) )
point 4: (starting_x + head_length + tail_length, starting_y - (0.5*tail_width)   )
point 5: (starting_x + head_length + tail_length, starting_y +(0.5*tail_width) )
point 6: (starting_x + head_length, starting_y + (0.5*tail_width) )
point 7: (starting_x + head_length, starting_y - head_width)
%}
position = [starting_x starting_y starting_x+head_length starting_y-head_width starting_x+head_length starting_y-(0.5*tail_width) starting_x+head_length+tail_length starting_y-(0.5*tail_width) starting_x+head_length+tail_length starting_y+(0.5*tail_width) starting_x+head_length starting_y+(0.5*tail_width) starting_x+head_length starting_y+head_width];
for t = 1 : num_time_points
    save_fname = [int2str(t) '_save_' kymo_filename];
    offset_amount = (t - 1)*increment;
    offset_matrix = [0 offset_amount 0 offset_amount 0 offset_amount 0 offset_amount 0 offset_amount 0 offset_amount 0 offset_amount];
    result = insertShape(kymo_2d, 'FilledPolygon', position+offset_matrix, 'Color', 'black', 'Opacity', 1);
    imwrite(result, save_fname);
end

