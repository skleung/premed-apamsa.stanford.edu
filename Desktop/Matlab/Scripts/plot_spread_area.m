function [return_value] = plot_spread_area(mask_filename, num_cells)

%setup filename/infos
info_mask = imfinfo(mask_filename);
x = info_mask(1).Width;
y = info_mask(1).Height;
dim = size(info_mask);
num_time = dim(1);

%construct 3D matrix
mask_3d = zeros(x,y,num_time);
for t = 1 : num_time
    image = imread(mask_filename, t, 'Info', info_mask);
    no_border_image = imclearborder(image, 8);
    mask_3d(:,:,t) = double( no_border_image );
end
[L, NUM] = bwlabeln(mask_3d, 26);
cell_sizes_list = zeros(NUM, 1);

for i = 1 : NUM
    [r, c, h] = find(L == i);
    coordinates = [r c h];
    size_matrix = size(coordinates);
    cell_size = size_matrix(1);
    cell_sizes_list(i) = cell_size;    
end

cell_sizes_list_temp = sort(cell_sizes_list, 'descend');
disp(cell_sizes_list_temp);
cell_label = zeros(num_cells, 1);

for i = 1 : num_cells
    cell_label(i) = find(cell_sizes_list == cell_sizes_list_temp(i) );
end

display_matrix = zeros(num_cells, num_time);
for i = 1 : num_cells
    for t = 1 : num_time
    cell_number = cell_label(i);
    [r, c] = find(L(:,:,t) == cell_number);
    coordinates = [r c];
    size_matrix = size(coordinates);
    display_matrix(i, t) = size_matrix(1);
    end    
end

time_vector = 1:num_time;
for i = 1 : num_cells
    scatter(time_vector, display_matrix(i,:) );
    if i ~= num_cells
        hold on;
    end
end


%{
for t = 1 : num_time
    imagesc(L(:,:,t), [0, NUM]);
    I = getframe(gcf);%get handle for current figure frame
    colorbar;
    imwrite(I.cdata,[int2str(t) '_test.png']); %save as in image, will be all in a folder, can read in from ImageJ laterz
end
%}


end

