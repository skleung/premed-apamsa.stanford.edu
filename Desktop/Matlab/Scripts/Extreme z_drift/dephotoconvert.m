function [pcc_ch ,  pcc_stack] = dephotoconvert( photoconverted_fname , photobleached_fname, pc_bg_fname, pb_bg_fname, stack_pc_fname, stack_pb_fname  )
%LMO 10/2013 FINAL
%[pcc_ch] = dephotoconvert( photoconverted_fname, photobleached_fname, pc_bg_fname, pb_bg_fname )
%For subtracting the signal of a photobleached (fibrin)signal from a
%photoconverted (LA) signal such that 0= LA - fibrin*f for a bg image
%pc_bg_fname and pb_bg_fname are small squares of SIP_fibrin in the background (devoid of cell
% signal) for the conversion
% photoconverted_fname and photobleached_fname are SIPs, stack_pc_fname is
% the raw image stack
%For normalization of the output images, divides the signal by the maximum
%pixel value, but does not correct for photobleaching
%%
pb_ch_info = imfinfo(photobleached_fname);
pc_ch_info = imfinfo(photoconverted_fname);
pb_bg_info = imfinfo(pb_bg_fname);
pc_bg_info = imfinfo( pc_bg_fname);
num_slices = numel(pb_ch_info);
trial = imread(pc_bg_fname, 1 , 'Info', pc_bg_info);
[limy limx] = size(trial);
t = numel(pb_ch_info);
frame_max = zeros(t,1);

pcc_save_fname = ['pcc_' photoconverted_fname];

%See how the BG mean signal intensity changes over time, and get parameters for normalization
for i=1:t
    pc_bg = imread(pc_bg_fname, i , 'Info', pc_bg_info);
    pc_bg = double (pc_bg);
    s = sort(pc_bg(:));
    BGpc_bg = s(floor(limx*limy*0.05));
    pc_bg = pc_bg-s(floor(limx*limy*0.05)); %background subtraction
    pc_bg(pc_bg<0) = 0;
    dIpc = mean(pc_bg(:)); %mean of the background subtracted image
    
    pb_bg = imread(pb_bg_fname, i , 'Info', pb_bg_info);
    pb_bg = double (pb_bg);
    s2 = sort(pb_bg(:));
    BGpb_bg = pb_bg-s2(floor(limx*limy*0.05));
    pb_bg = pb_bg-s2(floor(limx*limy*0.05)); %background subtraction
    pb_bg(pb_bg<0) = 0;
    dIpb = mean(pb_bg(:)); %mean of the background subtracted image
    
    f = dIpc/dIpb;
    
    pc = imread(photoconverted_fname, i , 'Info', pc_ch_info);
    pc = double(pc);
    pb = imread(photobleached_fname, i , 'Info', pb_ch_info);
    pb = double(pb);
    pc = pc - BGpc_bg;
    pc = pc - f*pb;
    pc(pc<0) = 0;
    frame_max(i,1) = max(pc(:));
end
maxPC = max(frame_max(:));
%Now, do the exact same procedure to make the images, but normalize all
%of them to the max value in all the frames.
for i=1:t
    %Recalculate all of the values from the bg image
    pc_bg = imread(pc_bg_fname, i , 'Info', pc_bg_info);
    pc_bg = double (pc_bg);
    s = sort(pc_bg(:));
    BGpc_bg = s(floor(limx*limy*0.05));
    pc_bg = pc_bg-BGpc_bg; %background subtraction
    pc_bg(pc_bg<0) = 0;
    dIpc = mean(pc_bg(:)); %mean of the background subtracted image
    
    pb_bg = imread(pb_bg_fname, i , 'Info', pb_bg_info);
    pb_bg = double (pb_bg);
    s2 = sort(pb_bg(:));
    BGpb_bg = pb_bg-s2(floor(limx*limy*0.05));
    pb_bg = pb_bg-BGpb_bg; %background subtraction
    pb_bg(pb_bg<0) = 0;
    dIpb = mean(pb_bg(:)); %mean of the background subtracted image
    
    f = dIpc/dIpb;
    
    %Modify the SIP image
    pc = imread(photoconverted_fname, i , 'Info', pc_ch_info);
    pc = double(pc);
    pb = imread(photobleached_fname, i , 'Info', pb_ch_info);
    pb = double(pb);
    pc = pc - BGpc_bg;
    pc = pc - f*pb;
    pc(pc<0) = 0;
    pc = pc./maxPC;
    if i==1
        imwrite( pc, pcc_save_fname );
    else
        imwrite( pc, pcc_save_fname ,'writemode','append');
    end
    
    %Modify the stack
    if exist(stack_pc_fname)==2
        
        stack_pc_ch_info = imfinfo(stack_pc_fname);
        stack_pb_ch_info = imfinfo(stack_pb_fname);
        Z = numel(stack_pb_ch_info)/t;
        save_fname = ['pcc_' stack_pc_fname ];
        
        
        if i==1 %figure out the normalization factor:
            max_stack_PC = zeros(Z,1);
            for z=1:Z
                frame = z;
                pc = double( imread(stack_pc_fname, frame , 'Info',  stack_pc_ch_info) );
                s = sort(pc(:));
                BGpc = s(floor(limx*limy*0.05));
                pc = pc-BGpc;
                
                pb = double( imread(stack_pb_fname, frame , 'Info', stack_pb_ch_info) );
                s = sort(pb(:));
                BGpb = s(floor(limx*limy*0.05));
                pb = pb-BGpb;
                
                pc = pc - f*pb;
                max_stack_PC(z,1) = max(pc(:));
            end
            MAX_stack_PC = max(max_stack_PC);
        end
        
        for z=1:Z
            frame = (i-1)*Z + z;
            pc = double( imread(stack_pc_fname, frame , 'Info',  stack_pc_ch_info) );
            s = sort(pc(:));
            BGpc = s(floor(limx*limy*0.05));
            pc = pc-BGpc;
            
            pb = double( imread(stack_pb_fname, frame , 'Info', stack_pb_ch_info) );
            s = sort(pb(:));
            BGpb = s(floor(limx*limy*0.05));
            pb = pb-BGpb;
            
            pc = pc - f*pb;
            pc(pc<0) = 0;
            pc = pc./MAX_stack_PC;
            
            if frame==1
                imwrite( pc, save_fname );
            else
                imwrite( pc, save_fname ,'writemode','append');
            end
        end
        pcc_stack = save_fname;
    end
    pcc_ch = pcc_save_fname;
end