function [new_Z] = tiff_playaround(FNAME)
fnameA = FNAME;
%Get the information about the files
infoA = imfinfo(fnameA);
x = infoA(1).Width;
y = infoA(1).Height;

ref_frame1 = double( imread(fnameA, 75 , 'Info', infoA ) );
T = 10;
Z = 5;
indices = zeros(T,Z);
for t = 1:T
    indices(t,:) = (1:Z) + (t-1)*Z;
end
disp(indices);
dz = 1-indices;
disp(dz);
