function [new_Z] = zDriftCorrect_test_read(FNAME)
% [save_fnameA save_fname1 save_fname2 new_Z] = zDriftCorrect(Z , T , FNAME_ALIGN , FNAME1, FNAME2  )
%INPUTS:
%Z is the number of Zs ; T is the number of timepoints
%FNAME_ALIGN is the filename of the fibrin stack, or most constant channel.
%FNAME1 and FNAME2 are the filenames of the channels aligned to FNAME_ALIGN
%OUTPUS
%Saves the files into working directory under fnames, defines new Z height
%Works for files with >5 z slices and that drift less than 50% of their Z
%height
%Minimizes the RMSD of the middle three stacks of the second timepoint to the rest of the stacks 
fnameA = FNAME;
%Get the information about the files
infoA = imfinfo(fnameA);
t = 1; 
current_frame = double ( imread(fnameA, 1, 'Info', infoA));
disp(current_frame(:,1));   
 
