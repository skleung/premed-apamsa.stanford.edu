function [return_value] = generate_concentration_graph(protrusion_pMRLC_filename, protrusion_MRLC_filename, protrusion_ratio_filename, Z, pixel_size)

%set filenames
ratio_filename = protrusion_ratio_filename;
pMRLC_filename = protrusion_pMRLC_filename;
MRLC_filename = protrusion_MRLC_filename;
ratio_mask_filename = ['mask_' protrusion_ratio_filename];
pMRLC_mask_filename = ['mask_' protrusion_pMRLC_filename];
MRLC_mask_filename = ['mask_' protrusion_MRLC_filename];

%read values
info_MRLC = imfinfo(MRLC_filename);
info_pMRLC = imfinfo(pMRLC_filename);
info_ratio = imfinfo(ratio_filename);
x = info_MRLC(1).Width;
y = info_MRLC(1).Height;
num_z = Z;

%generate 3D matrices
MRLC_3d = zeros(y, x, num_z);
pMRLC_3d = zeros(y, x, num_z);
ratio_3d = zeros(y, x, num_z);
mask_MRLC_3d = zeros(y, x, num_z);
mask_pMRLC_3d = zeros(y, x, num_z);
mask_ratio_3d = zeros(y, x, num_z);

for k = 1 : num_z
    %original images
    MRLC_3d(:,:,k) = double( imread(MRLC_filename, k) );
    pMRLC_3d(:,:,k) = double( imread(pMRLC_filename, k) );
    ratio_3d(:,:,k) = double( imread(ratio_filename, k) );
    %masks
    mask_MRLC_3d(:,:,k) = double( imread(MRLC_mask_filename, k) );
    mask_pMRLC_3d(:,:,k) = double( imread(pMRLC_mask_filename, k) );
    mask_ratio_3d(:,:,k) = double( imread(ratio_mask_filename, k) );
end

%make sum intensity projections
SUM_MRLC_3d = zeros(y, x);
SUM_pMRLC_3d = zeros(y, x);
SUM_ratio_3d = zeros(y, x);
SUM_mask_MRLC_3d = zeros(y, x);
SUM_mask_pMRLC_3d = zeros(y, x);
SUM_mask_ratio_3d = zeros(y, x);
for i = 1 : y
    for j = 1 : x
        %sum all the z elements 
        for k = 1 : num_z
            SUM_pMRLC_3d(i,j) = SUM_pMRLC_3d(i,j) + pMRLC_3d(i,j,k);
            SUM_MRLC_3d(i,j) = SUM_MRLC_3d(i,j) + MRLC_3d(i,j,k);
            SUM_ratio_3d(i,j) = SUM_ratio_3d(i,j) + ratio_3d(i,j,k);
            
            SUM_mask_pMRLC_3d(i,j) = SUM_mask_pMRLC_3d(i,j) + (mask_pMRLC_3d(i,j,k)/255);
            SUM_mask_MRLC_3d(i,j) = SUM_mask_MRLC_3d(i,j) + (mask_MRLC_3d(i,j,k)/255);
            SUM_mask_ratio_3d(i,j) = SUM_mask_ratio_3d(i,j) + (mask_ratio_3d(i,j,k)/255);     
        end        
    end
end

%calculate raw sums
x_vector = zeros(x, 1);
raw_y_vector_ratio = zeros(x, 1);
raw_y_vector_MRLC = zeros(x, 1);
raw_y_vector_pMRLC = zeros(x, 1);
raw_y_vector_ratio_mask = zeros(x, 1);
raw_y_vector_MRLC_mask = zeros(x, 1);
raw_y_vector_pMRLC_mask = zeros(x, 1);


for i = 1 : x
    ratio_value = 0;
    MRLC_value = 0;
    pMRLC_value = 0;
    mask_ratio_value = 0;
    mask_MRLC_value = 0;
    mask_pMRLC_value = 0;
    
    for j = 1 : y
        ratio_value = ratio_value + SUM_ratio_3d(j, i);
        MRLC_value = MRLC_value + SUM_MRLC_3d(j, i);
        pMRLC_value = pMRLC_value + SUM_pMRLC_3d(j,i);
        
        mask_ratio_value = mask_ratio_value + SUM_mask_ratio_3d(j,i);
        mask_MRLC_value = mask_MRLC_value + SUM_mask_MRLC_3d(j,i);
        mask_pMRLC_value = mask_pMRLC_value + SUM_mask_pMRLC_3d(j,i);
    end
    
    raw_y_vector_ratio(i) = ratio_value;
    raw_y_vector_MRLC(i) = MRLC_value;
    raw_y_vector_pMRLC(i) = pMRLC_value;
    
    raw_y_vector_ratio_mask(i) = mask_ratio_value;
    raw_y_vector_MRLC_mask(i) = mask_MRLC_value;
    raw_y_vector_pMRLC_mask(i) = mask_pMRLC_value;
end

final_y_vector_ratio = zeros(x, 1);
final_y_vector_MRLC = zeros(x, 1);
final_y_vector_pMRLC = zeros(x, 1);

for i = 1 : x
    if raw_y_vector_ratio_mask(i) ~= 0
        final_y_vector_ratio(i) = raw_y_vector_ratio(i)/raw_y_vector_ratio_mask(i);
    else
        final_y_vector_ratio(i)= 0;
    end
    
    if raw_y_vector_ratio_mask(i) ~= 0
        final_y_vector_MRLC(i) = raw_y_vector_MRLC(i)/raw_y_vector_MRLC_mask(i);
    else
        final_y_vector_MRLC(i)= 0;
    end
    
    if raw_y_vector_ratio_mask(i) ~= 0
        final_y_vector_pMRLC(i) = raw_y_vector_pMRLC(i)/raw_y_vector_pMRLC_mask(i);   
    else
        final_y_vector_pMRLC(i)= 0;
    end
     
end

%normalize the vectors
normalized_y_vector_ratio = zeros(x, 1);
normalized_y_vector_MRLC = zeros(x, 1);
normalized_y_vector_pMRLC = zeros(x, 1);

max_pMRLC = max(final_y_vector_pMRLC);
max_MRLC = max(final_y_vector_MRLC);
max_ratio = max(final_y_vector_ratio);
min_pMRLC = min(final_y_vector_pMRLC);
min_MRLC = min(final_y_vector_MRLC);
min_ratio = min(final_y_vector_ratio);
range_pMRLC = max_pMRLC - min_pMRLC;
range_MRLC = max_MRLC - min_MRLC;
range_ratio = max_ratio - min_ratio;

for i = 1 : x
    normalized_y_vector_ratio(i) = (final_y_vector_ratio(i) - min_ratio)/range_ratio * 100;
    normalized_y_vector_MRLC(i) = (final_y_vector_MRLC(i) - min_MRLC)/range_MRLC * 100;
    normalized_y_vector_pMRLC(i) = (final_y_vector_pMRLC(i) - min_pMRLC)/range_pMRLC * 100;
end

%set up x vector
for i = 1 : x
   x_vector(i) = i * pixel_size;
end

scatter(x_vector, normalized_y_vector_ratio, 3);
hold on;
scatter(x_vector, normalized_y_vector_MRLC, 3);
hold on; 
scatter(x_vector, normalized_y_vector_pMRLC, 3);
xlabel('Distance from cell body (um)');
ylabel('Relative concentration of protein');


































