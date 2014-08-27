function [pbc_ch , pbc_stack] = photobleach_correct( photobleached_fname , photobleached_stack )
%LMO 10/2013 FINAL
% function [pbc_ch , pbc_stack] = photobleach_correct( photobleached_fname , photobleached_stack )
%Conserves sum of signal, corrects for
%photobleaching in SIP data. Then applied to stack, if exists
save_fname = ['pbc_' photobleached_fname ];
pb_ch_info = imfinfo(photobleached_fname);
trial = imread(photobleached_fname, 1 , 'Info', pb_ch_info);
[limy limx] = size(trial);
T = numel(pb_ch_info);

bg = zeros(1,T);
decay = zeros(1,T);
max_decay = zeros(1,T);

for i=1:T %See how the summed signal intensity decays over time, and get parameters for normalization
    ia = imread(photobleached_fname, i , 'Info', pb_ch_info );
    ch = double (ia);
    s = sort(ch(:));
    bg(1,i) = s(floor(limx*limy*0.05));
    ch = ch - bg(1,i); %background subtraction, 5th percentile of signal
    ch(ch<0) = 0; %Eliminate negative pixel values
    decay(1,i) = mean(ch(:)); %mean of the background subtracted image
    max_decay(1,i) = max(ch(:))/mean(ch(:)); %max for each timepoint of the background subtracted, decay normalized image
end
maxCH = max(max_decay(:));

if exist(photobleached_stack) == 2 %Get max parameter for the stack
    stack_info = imfinfo(photobleached_stack);
    trial = imread(photobleached_stack, 1 , 'Info', stack_info);
    I = numel(stack_info);
    Z = I/T;
    max_stack = zeros(1,I);
    bg_stack = zeros(1,I);
    for i=1:I
        t = ceil(i/Z);
        ch = double( imread(photobleached_stack, i , 'Info', stack_info ) );
        s = sort(ch(:));
        bg_stack(1,i) = s(floor(limx*limy*0.05));
        ch = ch - bg_stack(1,i); %background subtraction, 5th percentile of signal
        ch(ch<0) = 0; %Eliminate negative pixel values
        ch = ch/decay(1,t); %normalize to the decay constant of the relevant tp
        max_stack(1,i) = max(ch(:));
    end
    MAX_stack = max(max_stack);
end

for i=1:T %Normalize the SIP
    ia = imread(photobleached_fname, i , 'Info', pb_ch_info );
    ch = double (ia);
    ch = ch-bg(1,i); %background subtraction, 5th percentile of signal
    ch = ch/decay(1,i); %Normalize for photobleaching by global time decay
    ch = ch/maxCH; %Normalize by a global term so that max of all pixel values in whole stack is 1
    ch(ch<0) = 0; %Eliminate negative pixel values
    if i==1
        imwrite( ch, save_fname );
    else
        imwrite( ch,  save_fname ,'writemode','append');
    end
    pbc_ch = save_fname;
end

if exist(photobleached_stack) == 2 %Normalize the stack
    save_stack = ['pbc_' photobleached_stack ];
    for i=1:I
        t = ceil(i/Z);
        ch = double( imread(photobleached_stack, i , 'Info', stack_info ) );
        ch = ch - bg_stack(1,i); %background subtraction, 5th percentile of signal
        ch(ch<0) = 0; %Eliminate negative pixel values
        ch = ch/decay(1,t); %normalize to the decay constant of the relevant tp
        ch = ch./MAX_stack;
        if i==1
            imwrite( ch, save_stack );
        else
            imwrite( ch,  save_stack ,'writemode','append');
        end
        pbc_stack = save_stack;
    end
    
end
end