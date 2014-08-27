function [return_value] = plot_spread_area_by_view(mask_filename)

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
    mask_3d(:,:,t) = double( no_border_image )/255;
end

time_vector = 1:num_time;
spread_area = zeros(num_time, 1);
for t = 1 : num_time
    spread_area(t) = sum(sum(mask_3d(:,:,t)));
end
scatter(time_vector, spread_area);


%{
for t = 1 : num_time
    imagesc(L(:,:,t), [0, NUM]);
    I = getframe(gcf);%get handle for current figure frame
    colorbar;
    imwrite(I.cdata,[int2str(t) '_test.png']); %save as in image, will be all in a folder, can read in from ImageJ laterz
end
%}


end

