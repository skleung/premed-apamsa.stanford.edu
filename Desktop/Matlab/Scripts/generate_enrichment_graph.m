function [return_value] = generate_enrichment_graph(summed_ratio_image, ori_pMRLC_image, ori_MRLC_image)

ratio_filename = summed_ratio_image;
pMRLC_filename = ori_pMRLC_image;
MRLC_filename = ori_MRLC_image;
info_ratio = imfinfo(ratio_filename);
x = info_ratio(1).Width;
y = info_ratio(1).Height;

x_vector = zeros(x, 1);
raw_y_vector_ratio = zeros(x, 1);
raw_y_vector_MRLC = zeros(x, 1);
raw_y_vector_pMRLC = zeros(x, 1);

%set up x vector
for i = 1 : x
   x_vector(i) = i; 
end

%build 2d matrices
ratio_2d = zeros(x, y);
MRLC_2d = zeros(x,y);
pMRLC_2d = zeros(x,y);
ratio_2d = double( imread(ratio_filename, 1 , 'Info', info_ratio ) );
MRLC_2d = double( imread(MRLC_filename, 1 , 'Info', info_ratio ) );
pMRLC_2d = double( imread(pMRLC_filename, 1 , 'Info', info_ratio ) );

%calculate raw sums
for i = 1 : x
    ratio_value = 0;
    MRLC_value = 0;
    pMRLC_value = 0;
    for j = 1 : y
        ratio_value = ratio_value + ratio_2d(j, i);
        MRLC_value = MRLC_value + MRLC_2d(j, i);
        pMRLC_value = pMRLC_value + pMRLC_2d(j,i);
    end
    raw_y_vector_ratio(i) = ratio_value;
    raw_y_vector_MRLC(i) = MRLC_value;
    raw_y_vector_pMRLC(i) = pMRLC_value;
end

%normalize the vectors
normalized_y_vector_ratio = zeros(x, 1);
normalized_y_vector_MRLC = zeros(x, 1);
normalized_y_vector_pMRLC = zeros(x, 1);

max_pMRLC = max(raw_y_vector_pMRLC);
max_MRLC = max(raw_y_vector_MRLC);
max_ratio = max(raw_y_vector_ratio);
min_pMRLC = min(raw_y_vector_pMRLC);
min_MRLC = min(raw_y_vector_MRLC);
min_ratio = min(raw_y_vector_ratio);
range_pMRLC = max_pMRLC - min_pMRLC;
range_MRLC = max_MRLC - min_MRLC;
range_ratio = max_ratio - min_ratio;

%pMRLC
for i = 1 : x
    normalized_y_vector_ratio(i) = (raw_y_vector_ratio(i) - min_ratio)./range_ratio * 100;
    normalized_y_vector_MRLC(i) = (raw_y_vector_MRLC(i) - min_MRLC)./range_MRLC * 100;
    normalized_y_vector_pMRLC(i) = (raw_y_vector_pMRLC(i) - min_pMRLC)./range_pMRLC * 100;
end

scatter(x_vector, normalized_y_vector_ratio, 3);
hold on;
scatter(x_vector, normalized_y_vector_MRLC, 3);
hold on;
scatter(x_vector, normalized_y_vector_pMRLC, 3);
        

