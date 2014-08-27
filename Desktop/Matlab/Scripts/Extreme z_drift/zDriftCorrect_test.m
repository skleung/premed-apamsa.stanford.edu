function [new_Z] = zDriftCorrect_test(Z , T , FNAME)

fnameA_montage = FNAME;
%Get the information about the files
infoM = imfinfo(fnameA_montage);
disp(infoM(1).Width);
disp(infoM(1).Height);
t = 1;
montage = double (imread (fnameA_montage) );
index_mapping = ones(6,1)*(1:10); % - rough_offset*ones(1,Z);
disp(index_mapping);
save_fnameB = ['1_test_' FNAME]; 
for n=1:6*Z
   % current_frame = double ( imread(fnameA_montage, n, 'Info', infoA));
    if n == 1
        %imwrite(uint16(current_frame), save_fnameB);
    else
        %imwrite(uint16(current_frame), save_fnameB, 'writemode', 'append');
    end
end


