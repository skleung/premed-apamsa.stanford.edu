function [return_value] = generate_whole_cell_normalized_heatmap(original_stack, mask_stack, protrusion_stack, T)
%Function takes in a SIP of the orginial whole cell file, a SIP of the mask
%of the whole cell file, and SIP protrusion original stack ALL AFTER BACKGROUND
%SUBTRACTION


%get info
info_MRLC = imfinfo(mask_stack);
info_stack = imfinfo(original_stack);
x = info_MRLC(1).Width;
y = info_MRLC(1).Height;

info_prot = imfinfo(protrusion_stack);
x_p = info_prot(1).Width;
y_p = info_prot(1).Height;

%calculate the total protein sum in cell
%basically just add up the SIP value where there is a value in the mask
cell_sum = 0;
prot_max = 0;

mask_image = imread(mask_stack, 1, 'Info', info_MRLC);
stack_image = imread(original_stack, 1, 'Info', info_stack);

for i = 1 : x
    for j = 1 : y
        if mask_image(i,j) ~= 0
            cell_sum = cell_sum + stack_image(i,j);
        end
    end
end

for t = 1 : T
    %mask_image = imread(mask_stack, t);
    %stack_image = imread(original_stack, t);
    prot_image = imread(protrusion_stack, t, 'Info', info_prot);
    for i = 1 : y_p
        for j = 1 : x_p
      
                if prot_max < prot_image(i,j);
                    prot_max = prot_image(i,j);
                end             
            
        end
    end
end

%this is the highest percent of the total protein concentration in protrusion in
%any given pixel (voxel?)

max_fraction = double(prot_max)/double(cell_sum);
disp(max_fraction);
%generate 3d matrix for protrusion only
protrusion_3d = zeros(y_p, x_p, T);

for t = 1 : T
    protrusion_3d(:,:,t) = imread(protrusion_stack, t, 'Info', info_prot) ;
end

protrusion_3d_normalized =  ( protrusion_3d / double(cell_sum) )*100;

for t = 1 : T
    %set colormap, there are other options - discuss with Leanna
    colormap('Jet');
    
    %imagesc with the display range - the hottest red will always be set to
    %the highest amount of protein found
    imagesc( protrusion_3d_normalized(:,:,t), [0, max_fraction * 100]); %[0, max_fraction * 100]
    colorbar;
    c = colorbar('peer',gca); %get handle for colorbar
    set(get(c,'ylabel'),'String', 'Percent of Total MRLC in Cell', 'fontsize', 9); %set the colorbar label
    ylabel = get(c, 'ylabel');
    set(ylabel, 'Position', get(ylabel, 'Position') + [1 0 0] ); %position the colorbar right
    set(gca,'XTick',[]);
    set(gca,'YTick',[]);
    set(gca,'dataAspectRatio',[1 1 1]);
    I = getframe(gcf);%get handle for current figure frame
    imwrite(I.cdata,[int2str(t) '_heatmap.png']); %save as in image, will be all in a folder, can read in from ImageJ laterz
end

    

    
    
    
    