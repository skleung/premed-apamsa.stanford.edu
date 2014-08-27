function [ output_args ] = background_subtract_timelapse(bg_sum_fname, SIP_fname, T)

%set info
info_image = imfinfo(SIP_fname);
x = info_image(1).Width;
y = info_image(1).Height;
save_fname = ['bgc_' SIP_fname];

%set bg info
info_bg = imfinfo(bg_sum_fname);
x_bg = info_bg(1).Width;
y_bg = info_bg(1).Height;

for t = 1 : T
    disp(t);
    %calculate the average of all pixels in background pixels
    bg_image =  uint32( imread(bg_sum_fname, t, 'Info', info_bg) );
    sum_bg = 0;
    for i = 1 : x_bg
        for j = 1 : y_bg
            sum_bg = sum_bg + bg_image(j, i);
        end
    end
    avg_bg = sum_bg / (x_bg * y_bg); %average intensity per pixel

    %build SIP for that timepoint
    bgc_image_2d =  uint32(imread(SIP_fname, t, 'Info', info_image)) - avg_bg;
    
    
    %writing to a new file-----------

    if t == 1
        image = Tiff(save_fname, 'w');
    else
        image = Tiff(save_fname, 'a');
    end
    image.setTag('Photometric',Tiff.Photometric.MinIsBlack);
    image.setTag('Compression',Tiff.Compression.None);
    image.setTag('BitsPerSample',32);
    image.setTag('SampleFormat',Tiff.SampleFormat.UInt);
    image.setTag('ImageLength',y);
    image.setTag('ImageWidth',x);
    image.setTag('PlanarConfiguration',Tiff.PlanarConfiguration.Chunky);
    image.write(bgc_image_2d);    
    image.close();
end


end

