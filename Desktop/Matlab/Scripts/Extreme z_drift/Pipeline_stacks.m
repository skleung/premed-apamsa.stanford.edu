%Pipeline
% Requires: zDriftCorrect.mat ; dephotoconvert.mat ; photobleach_correct.m
% Requires person interaction after zDriftCorrection and for protrusion
% crop (kymograph)
%------------------------------------------------------------------------%
%STEPS
% 1) z drift correction
%*2) MANUALLY crop z-drift data and make SIP *add 5 um scalebar
% 3) Photoconversion correction: Subtract a fraction of the fib ch from the photoconverted ch (Q2)
% 4) Photobleach correction: assumes the summed signal is constant

%-----------Initial Inputs-----------------------------------------------%
clc;
clear all;
close all;
tic

T = 200;
Z = 12;
folder = 'H:\Analysis_development\Pipeline\TEST' ;
prefix = '080213p6_';
suffix = '.tif';
ch_types = {'LA', 'MRLC', 'fib'}; %make sure the first two are cell signal
% Choose your method of modification:
Q0 = 1; %Fix z drift? Requires check and re-cropping
Q1 = 1; %Subtract a portion of the fibrin channel from the LA channel? pcc
Q2 = 1; %Correct photobleaching? pbc

%Load in files, define variables 
%takes ~5 minutes for z-drift correction
cd(folder);

fnames = cell(length(ch_types), 1);
SUMfnames = cell(length(ch_types), 1);
im_info = cell(length(ch_types), 1);
for ch_id=1:length(ch_types)
    fnames{ch_id,1} = [prefix ch_types{ch_id} suffix];
    im_info{ch_id,1} = imfinfo(fnames{ch_id,1});
end

limx = im_info{1,1}(1,1).Width;
limy = im_info{1,1}(1,1).Height;

if Q0 ==1 %Fix Z drift
    FNAME_ALIGN = fnames{3};
    FNAME1 = fnames{1};
    FNAME2 = fnames{2};
    zDriftCorrect(Z , T , FNAME_ALIGN , FNAME1, FNAME2  );
end

for i=1:length(ch_types)
    fnames{i} = ['zdc_' fnames{i}];
    SUMfnames{i} = ['SUM_' fnames{i}];
end
toc    
'Need to: crop frames to discard, crop out a "bg_" image for fixing pc, make SIP'
%%
%Fix photoconversion (choose none, one, or both of 2 methods (Q1-3))
tic
if Q1 == 1 %Photoconvert correction by subtracting fibrin for SIP
    photoconverted_fname = SUMfnames{1};
    photobleached_fname = SUMfnames{3};
    pc_bg_fname = ['bg_' SUMfnames{1} ];
    pb_bg_fname = ['bg_' SUMfnames{3} ];
    stack_pc_fname = fnames{1};
    stack_pb_fname = fnames{3};
    [pcc_ch , pcc_stack] = dephotoconvert( photoconverted_fname , photobleached_fname, pc_bg_fname, pb_bg_fname, stack_pc_fname, stack_pb_fname );
    SUMfnames{1} = pcc_ch;
    fnames{1} = pcc_stack;
end

%Photobleach correction
if Q2 == 1
    for ch_id=1:length(ch_types)
        [pbc_ch , pbc_stack] = photobleach_correct( SUMfnames{ch_id} , fnames{ch_id} );
        SUMfnames{ch_id} = pbc_ch;
        fnames{ch_id} = pbc_stack;
    end
end