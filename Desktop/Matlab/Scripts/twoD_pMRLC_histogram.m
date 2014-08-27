function [return_value] = twoD_pMRLC_histogram (DMSO_view, num_DMSO, MLY_view, num_MLY, ML_view, num_ML, Y_view, num_Y, image_type)
%just specify which view this is for each drug - v1, v2, etc

%setup filenames

if strcmp(image_type, 'SUM')
    DMSO_MRLC = ['DMSO_SUM_bgc_' DMSO_view '_MRLC.tif'];
    DMSO_pMRLC = ['DMSO_SUM_bgc_' DMSO_view '_pMRLC.tif'];
    DMSO_mask = ['DMSO_mask_SUM_bgc_' DMSO_view '_MRLC.tif'];

    MLY_MRLC = ['ML7&Y_SUM_bgc_' MLY_view '_MRLC.tif'];
    MLY_pMRLC = ['ML7&Y_SUM_bgc_' MLY_view '_pMRLC.tif'];
    MLY_mask = ['ML7&Y_mask_SUM_bgc_' MLY_view '_MRLC.tif'];

    ML_MRLC = ['ML7_SUM_bgc_' ML_view '_MRLC.tif'];
    ML_pMRLC = ['ML7_SUM_bgc_' ML_view '_pMRLC.tif'];
    ML_mask = ['ML7_mask_SUM_bgc_' ML_view '_MRLC.tif'];

    Y_MRLC = ['Y_SUM_bgc_' Y_view '_MRLC.tif'];
    Y_pMRLC = ['Y_SUM_bgc_' Y_view '_pMRLC.tif'];
    Y_mask = ['Y_mask_SUM_bgc_' Y_view '_MRLC.tif'];
end

if strcmp(image_type, 'MAX')
    DMSO_MRLC = ['DMSO_MAX_bgc_' DMSO_view '_MRLC.tif'];
    DMSO_pMRLC = ['DMSO_MAX_bgc_' DMSO_view '_pMRLC.tif'];
    DMSO_mask = ['DMSO_mask_SUM_bgc_' DMSO_view '_MRLC.tif'];

    MLY_MRLC = ['ML7&Y_MAX_bgc_' MLY_view '_MRLC.tif'];
    MLY_pMRLC = ['ML7&Y_MAX_bgc_' MLY_view '_pMRLC.tif'];
    MLY_mask = ['ML7&Y_mask_SUM_bgc_' MLY_view '_MRLC.tif'];

    ML_MRLC = ['ML7_MAX_bgc_' ML_view '_MRLC.tif'];
    ML_pMRLC = ['ML7_MAX_bgc_' ML_view '_pMRLC.tif'];
    ML_mask = ['ML7_mask_SUM_bgc_' ML_view '_MRLC.tif'];

    Y_MRLC = ['Y_MAX_bgc_' Y_view '_MRLC.tif'];
    Y_pMRLC = ['Y_MAX_bgc_' Y_view '_pMRLC.tif'];
    Y_mask = ['Y_mask_SUM_bgc_' Y_view '_MRLC.tif'];
end

%get image infos
info_DMSO_mask = imfinfo(DMSO_mask);
info_DMSO_MRLC = imfinfo(DMSO_MRLC);
info_DMSO_pMRLC = imfinfo(DMSO_pMRLC);

info_MLY_mask = imfinfo(MLY_mask);
info_MLY_MRLC = imfinfo(MLY_MRLC);
info_MLY_pMRLC = imfinfo(MLY_pMRLC);

info_ML_mask = imfinfo(ML_mask);
info_ML_MRLC = imfinfo(ML_MRLC);
info_ML_pMRLC = imfinfo(ML_pMRLC);

info_Y_mask = imfinfo(Y_mask);
info_Y_MRLC = imfinfo(Y_MRLC);
info_Y_pMRLC = imfinfo(Y_pMRLC);

%read in the images
image_DMSO_mask = ~(imread(DMSO_mask, 'Info', info_DMSO_mask)/255);
image_DMSO_MRLC = imread(DMSO_MRLC, 'Info', info_DMSO_MRLC);
image_DMSO_pMRLC = imread(DMSO_pMRLC, 'Info', info_DMSO_pMRLC);

image_MLY_mask = ~(imread(MLY_mask, 'Info', info_MLY_mask)/255);
image_MLY_MRLC = imread(MLY_MRLC, 'Info', info_MLY_MRLC);
image_MLY_pMRLC = imread(MLY_pMRLC, 'Info', info_MLY_pMRLC);

image_ML_mask = ~(imread(ML_mask, 'Info', info_ML_mask)/255);
image_ML_MRLC = imread(ML_MRLC, 'Info', info_ML_MRLC);
image_ML_pMRLC = imread(ML_pMRLC, 'Info', info_ML_pMRLC);

image_Y_mask = ~(imread(Y_mask, 'Info', info_Y_mask)/255);
image_Y_MRLC = imread(Y_MRLC, 'Info', info_Y_MRLC);
image_Y_pMRLC = imread(Y_pMRLC, 'Info', info_Y_pMRLC);

x = info_DMSO_mask(1).Width;
y = info_DMSO_mask(1).Height;

label_DMSO = bwlabel(image_DMSO_mask, 8);
label_MLY = bwlabel(image_MLY_mask, 8);
label_ML = bwlabel(image_ML_mask, 8);
label_Y = bwlabel(image_Y_mask, 8);

DMSO_vector = zeros(num_DMSO, 2);
MLY_vector = zeros(num_MLY, 2);
ML_vector = zeros(num_ML, 2);
Y_vector = zeros(num_Y, 2);

%process DMSO
for c = 1 : num_DMSO
    [row, col] = find(label_DMSO == c);
    rc = [row col];
    size_rc = size(rc);
    total_pMRLC = 0;
    total_MRLC = 0;
    for p = 1 : size(row)% for each pixel within the cell
        total_MRLC = total_MRLC + image_DMSO_MRLC( rc(p, 1) , rc(p, 2) );
        total_pMRLC = total_pMRLC + image_DMSO_pMRLC( rc(p, 1) , rc(p, 2) );
    end
    DMSO_vector(c, 1) = total_MRLC/size_rc(1);
    DMSO_vector(c, 2) = total_pMRLC/size_rc(1);
end

%process MLY
for c = 1 : num_MLY
    [row, col] = find(label_MLY == c);
    rc = [row col];
    size_rc = size(rc);
    total_pMRLC = 0;
    total_MRLC = 0;
    for p = 1 : size(row)% for each pixel within the cell
        total_MRLC = total_MRLC + image_MLY_MRLC( rc(p, 1) , rc(p, 2) );
        total_pMRLC = total_pMRLC + image_MLY_pMRLC( rc(p, 1) , rc(p, 2) );
    end
    MLY_vector(c, 1) = total_MRLC/size_rc(1);
    MLY_vector(c, 2) = total_pMRLC/size_rc(1);
end

%process ML
for c = 1 : num_ML
    [row, col] = find(label_ML == c);
    rc = [row col];
    size_rc = size(rc);
    total_pMRLC = 0;
    total_MRLC = 0;
    for p = 1 : size(row)% for each pixel within the cell
        total_MRLC = total_MRLC + image_ML_MRLC( rc(p, 1) , rc(p, 2) );
        total_pMRLC = total_pMRLC + image_ML_pMRLC( rc(p, 1) , rc(p, 2) );
    end
    ML_vector(c, 1) = total_MRLC/size_rc(1);
    ML_vector(c, 2) = total_pMRLC/size_rc(1);
end

%process Y
for c = 1 : num_Y
    [row, col] = find(label_Y == c);
    rc = [row col];
    size_rc = size(rc);
    total_pMRLC = 0;
    total_MRLC = 0; 
    for p = 1 : size(row)% for each pixel within the cell
        total_MRLC = total_MRLC + image_Y_MRLC( rc(p, 1) , rc(p, 2) );
        total_pMRLC = total_pMRLC + image_Y_pMRLC( rc(p, 1) , rc(p, 2) );
    end
    Y_vector(c, 1) = total_MRLC/size_rc(1);
    Y_vector(c, 2) = total_pMRLC/size_rc(1);
end

%find maximum
max_DMSO = max(DMSO_vector);
max_MLY = max(MLY_vector);
max_ML = max(ML_vector);
max_Y = max(Y_vector);
max_vector = [max_DMSO max_MLY max_ML max_Y];
max_value = max(max_vector);

figure;
subplot(2, 2, 1);
bar(DMSO_vector, 'grouped');
title(['DMSO ' DMSO_view]);
ylim([0 max_value]);

subplot(2, 2, 2);
bar(MLY_vector, 'grouped');
title(['ML7&Y ' MLY_view]);
ylim([0 max_value]);

subplot(2, 2, 3);
bar(ML_vector, 'grouped');
title(['ML7 ' ML_view]);
ylim([0 max_value]);

subplot(2, 2, 4);
bar(Y_vector, 'grouped');
title(['Y ' Y_view]);
ylim([0 max_value]);


end