% LMO 1-2014: For fixing extreme drift in z using a zxt montage generated in Fiji (z
% horizontally, t vertically)

FNAME_MONTAGE = ['zdc_1_partial_s2_MRLC_montage.tif'];
fnameA = ['zdc_1_partial_s2_MRLC.tif'];
FNAME1 = ['zdc_s2 _MRLC.tif'];
FNAME2 = ['0']; % set as ['0'] if there is no second channel.

Z = 41;
T = 40;
max_zd = 7; % maxiumum number of planes in any tp that can be thrown away

infoM = imfinfo(FNAME_MONTAGE);
x = infoM (1).Width;
y = infoM (1).Height;

stdI = zeros(T,Z);
sumI = zeros(T,Z);
montage = double( imread(FNAME_MONTAGE));
box_width = x/Z;
box_height = y/T;
for t=1:T
    for z=1:Z
        x_min = (z-1)*box_width +1;
        x_max = z*box_width;
        y_min = (t-1)*box_height +1;
        y_max = t*box_height;
        im = montage(y_min:y_max, x_min:x_max);
        stdI(t,z) = std(im(:));
        sumI(t,z) = sum(im(:));
    end
end

lower_thresh = min(sumI( : , max_zd));
%disp(find (sumI(: , max_zd) == lower_thresh) );
%disp(lower_thresh);
rough_offset = zeros(T,1);
for t=1:T
    test = min( sumI(t,1:round(Z/3)) );
    if test < lower_thresh
        %disp([num2str(t) ': ' num2str(find(sumI(t,1:round(Z/3))<lower_thresh))]);
        rough_offset(t,1) = max(find(sumI(t,1:round(Z/3))<lower_thresh));
    end
end
%disp(rough_offset);
index_mapping = zeros(T,Z);
for t = 1 : T
    index_mapping(t, :) = (1:Z) + (t-1)*Z;    
end
for t = 1 : T
    maxInRow = max(index_mapping(t, :) );
    for z = 1 : Z
        new_map = index_mapping(t,z) + rough_offset(t,1);
        if (new_map <= maxInRow)
            index_mapping(t,z) = index_mapping(t,z) + rough_offset(t,1);
        else
            index_mapping(t,z) = maxInRow;
        end
    end
end
%disp(index_mapping);
%index_mapping = ones(T,1)*(1:Z) - rough_offset*ones(1,Z);
%disp(index_mapping);
dz = max_zd; % to make it compatible with zDriftCorrect.m (below)
DZ = 0;

ref_frame1 = imread(fnameA,1);
blank = uint16(rand(size(ref_frame1)));

save_fnameA = ['xzdc_' fnameA];
for t=1:T
    for z=1:Z
        if index_mapping(t,z) < 1 % if no image assigned to that slot
            im = blank;
            if t==1 && z==1
                im = uint16(ref_frame1);
                imwrite( im , save_fnameA)
            else imwrite( im , save_fnameA, 'writemode','append');
            end
        else % index mapping ~0
            im = imread(fnameA, index_mapping(t,z) ) ;
            if t==1 && z==1
                imwrite( im , save_fnameA);
            else
                imwrite( im , save_fnameA, 'writemode','append');
            end
        end
    end
end
%{
if exist(FNAME1) ==2
    save_FNAME1 = ['xzdc_' FNAME1 ];
    for t=1:T
    for z=1:DZ+Z
        if index_mapping(t,z) == 0 % if no image assigned to that slot
            im = blank;
            if t==1 && z==1
                im = uint16(ref_frame1);
                imwrite( im , save_FNAME1)
            else imwrite( im , save_FNAME1, 'writemode','append');
            end
        else % index mapping ~0
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
if exist(FNAME2) ==2
    save_FNAME2 = ['xzdc_' FNAME2 ];
    for t=1:T
    for z=1:DZ+Z
        if index_mapping(t,z) == 0 % if no image assigned to that slot
            im = blank;
            if t==1 && z==1
                im = uint16(ref_frame2);
                imwrite( im , save_FNAME2)
            else imwrite( im , save_FNAME2, 'writemode','append');
            end
        else % index mapping ~0
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
'rough z correction complete'
%}