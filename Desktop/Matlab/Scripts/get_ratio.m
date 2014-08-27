function [return_value] = get_ratio(FILE_NAME_MRLC, FILE_NAME_pMRLC, Z)

%save filenames
fname_MRLC = FILE_NAME_MRLC;
fname_pMRLC = FILE_NAME_pMRLC;
save_fname = ['ratio_' fname_pMRLC ' ' fname_MRLC];

%save values
info_MRLC = imfinfo(fname_MRLC);
info_pMRLC = imfinfo(fname_pMRLC);
x = info_MRLC(1).Width;
y = info_MRLC(1).Height;
num_z = Z;

%build 3d matrices
MRLC_3d = zeros(x, y, num_z);
pMRLC_3d = zeros(x, y, num_z);
for k = 1 : num_z
    MRLC_3d(:,:,k) = double( imread(fname_MRLC, k) );
    pMRLC_3d(:,:,k) = double( imread(fname_pMRLC, k) );
end

%build ratio matrix
save_3d = zeros(x, y, num_z);
max_ratio = 0;
for i = 1 : x
    for j = 1 : y
        for k = 1 : num_z
            if MRLC_3d(i,j,k) > 50
                save_3d(i, j, k) = pMRLC_3d(i,j,k)/MRLC_3d(i,j,k)*50;
                if save_3d(i,j,k) > max_ratio
                    max_ratio = save_3d(i,j,k);
                end
            end
        end
    end
end

%calculate maximum
for i = 1 : x
    for j = 1 : y
        for k = 1 : num_z
            save_3d(i, j, k) = uint16(save_3d(i,j,k)/max_ratio*65355);
        end
    end
end

%writing to a new file-----------
for k = 1 : num_z
    if k == 1
        imwrite( uint16( save_3d(:, :, k) ) , save_fname );
    else
        imwrite( uint16( save_3d(:, :, k) ) , save_fname , 'writemode', 'append');
    end
end