function [return_value] = no_bleedthrough(FILE_NAME_FIB, FILE_NAME_pMRLC, Z)

%Gets rid of the fibrin bleedthrough in 070614 data
fname_fib = FILE_NAME_FIB;
fname_pMRLC = FILE_NAME_pMRLC;
save_fname = ['no_bleedthrough_' fname_pMRLC ];

%Get the information about the files
info_fib = imfinfo(fname_fib);
info_pMRLC = imfinfo(fname_pMRLC);
x = info_fib(1).Width;
y = info_fib(1).Height;
num_z = Z;
threshold = 500;

%build 3d matrices
fib_3d = zeros(x, y, num_z);
pMRLC_3d = zeros(x, y, num_z);
for k = 1 : num_z
    fib_3d(:,:,k) = double( imread(fname_fib, k , 'Info', info_fib ) );
    pMRLC_3d(:,:,k) = double( imread(fname_pMRLC, k , 'Info', info_pMRLC ) );
end
disp('3D matrices built');

%creating new matrix------
save_3d = pMRLC_3d;
for i = 1 : x
    for j = 1 : y
        for k = 1 : num_z
            
            %if the fibrin has no signal, copy over value for pMRLC matrix
            if fib_3d(i,j,k) > threshold %|| (save_3d(i,j,k) > threshold && fib_3d(i,j,k) > threshold )
                save_3d(i,j,k) = 0;
            end         
            
        end
    end
end
disp('new matrix built');

%writing to a new file-----------
for k = 1 : num_z
    if k == 1
        imwrite( uint16( save_3d(:, :, k) ) , save_fname );
    else
        imwrite( uint16( save_3d(:, :, k) ) , save_fname , 'writemode', 'append');
    end
end
disp('completed writing to file');
