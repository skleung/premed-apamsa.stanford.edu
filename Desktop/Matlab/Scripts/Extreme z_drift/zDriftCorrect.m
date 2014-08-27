function [new_Z] = zDriftCorrect(Z , T , FNAME_ALIGN , FNAME1, FNAME2  )
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

fnameA = FNAME_ALIGN;
FNAME_ALIGN = fnameA;
save_fnameA = ['zdc_' FNAME_ALIGN ];
%Get the information about the files
infoA = imfinfo(fnameA);
x = infoA(1).Width;
y = infoA(1).Height;

RMSD = zeros(T,Z);
Z_align_ind = zeros(1, T);

ref_id = Z + round(Z*0.5); %Reference frame is the 50th percentile in z for the 2nd tp
ref_frame1 = double( imread(fnameA, ref_id-1 , 'Info', infoA ) );
ref_frame2 = double( imread(fnameA, ref_id , 'Info', infoA ) );
ref_frame3 = double( imread(fnameA, ref_id+1 , 'Info', infoA ) );

Z_align_ind(1,1) = ref_id -Z;
aligned_fname = ['aligned_' FNAME_ALIGN];
indices = zeros(T,Z);
thresh = 0.09; %threshold at which change the z slice

for t = 1:T
    indices(t,:) = (1:Z) + (t-1)*Z;
end

for t = 2:T %Find a preliminary alignment
    for z= 2:Z-1
        im_ind = indices(t,z);
        a1 = double( imread(fnameA, im_ind-1 , 'Info', infoA ) );
        a2 = double( imread(fnameA, im_ind , 'Info', infoA ) );
        a3 = double( imread(fnameA, im_ind+1 , 'Info', infoA ) );
        rmsd = ((ref_frame1 - a1).^2)+ ((ref_frame2 - a2).^2) + ((ref_frame3 - a3).^2) ;
        RMSD(t,z) = sum(rmsd(:));
    end
end
RMSD = RMSD(:, 2:Z-1);

prev_z = ref_id;
prevRMSD = 0;
for t = 2:T %Compensate for noise by only changing the index if a threshold
    %difference of RMSDs (between the 1st and 2nd lowest in t) is passed
    sorted = sort(RMSD(t,:));
    trial_z1 = find(RMSD(t,:)==sorted(1));
    trial_z2 = find(RMSD(t,:)==sorted(2));
    dRMSD = abs( sorted(1) - sorted(2) )/sorted(2);
    if trial_z1 ~= prev_z
        if dRMSD < thresh
        new_z = prev_z;
        else 
            new_z = trial_z1;
        end
    else
        new_z = trial_z1;
    end
        Z_align_ind(1,t) = new_z +1;
        prev_z = new_z;
end
%%
%Shift the stacks
dz = ref_id - Z - Z_align_ind;

if min(dz)<0
    DZ = abs( min(dz) );
else DZ = 0;
end

if max(dz)>0
    DZ = DZ + max(dz);
end

new_Z = Z + DZ;

index_mapping = zeros(T, Z + DZ );

for t=1:T
    first_frame = abs(min(dz))+ 1 + dz(t);
    last_frame = first_frame + Z -1 ;
    index_mapping(t, first_frame:last_frame) = (1:Z) + (t-1)*Z ;
end
disp(index_mapping);
blank = uint16(rand(size(ref_frame1)));

for t=1:T
    for z=1:DZ+Z
        if index_mapping(t,z) == 0 %if no image assigned to that slot
            im = blank;
            if t==1 && z==1
                im = uint16(ref_frame1);
                imwrite( im , save_fnameA)
            else imwrite( im , save_fnameA, 'writemode','append');
            end
        else %index mapping ~0
            im = imread(fnameA, index_mapping(t,z) ) ;
            if t==1 && z==1
                imwrite( im , save_fnameA);
            else
                imwrite( im , save_fnameA, 'writemode','append');
            end
        end
    end
end
%%

if exist(FNAME1) ==2
    save_FNAME1 = ['zdc_' FNAME1 ];
    for t=1:T
    for z=1:DZ+Z
        if index_mapping(t,z) == 0 %if no image assigned to that slot
            im = blank;
            if t==1 && z==1
                im = uint16(ref_frame1);
                imwrite( im , save_FNAME1)
            else imwrite( im , save_FNAME1, 'writemode','append');
            end
        else %index mapping ~0
            im = imread(FNAME1, index_mapping(t,z) ) ;
            if t==1 && z==1
                imwrite( im , save_FNAME1);
            else
                imwrite( im , save_FNAME1, 'writemode','append');
            end
        end
    end
    end
end
% 
if exist(FNAME2)==2
    save_FNAME2 = ['zdc_' FNAME2 ];
    for t=1:T
    for z=1:DZ+Z
        if index_mapping(t,z) == 0 %if no image assigned to that slot
            im = blank;
            if t==1 && z==1
                im = uint16(ref_frame2);
                imwrite( im , save_FNAME2)
            else imwrite( im , save_FNAME2, 'writemode','append');
            end
        else %index mapping ~0
            im = imread(FNAME2, index_mapping(t,z) ) ;
            if t==1 && z==1
                imwrite( im , save_FNAME2);
            else
                imwrite( im , save_FNAME2, 'writemode','append');
            end
        end
    end
    end
end
disp('done');
end

