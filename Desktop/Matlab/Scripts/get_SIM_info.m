function [ SIM_infos ] = get_SIM_info( Directory )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
find_all_SIM_txts(Directory);
fileID = fopen('C:\Users\MinCheol\Desktop\Matlab\tempText20.txt', 'r');
tline = fgetl(fileID);
count = 1;
while ischar(tline)
     disp(tline);
     A = textscan(tline, '%s %s %d %d %f');
     disp(A);
     count = count + 1;
     tline = fgetl(fileID); 
end
fclose(fileID);