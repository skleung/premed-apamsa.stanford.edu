tempID = fopen('C:\Users\MinCheol\Desktop\Matlab\tempText6.txt', 'wt');
disp(tempID);
find_all_SIM_txts('C:\Users\MinCheol\Desktop\Matlab\Parent Folder', tempID);
fclose(tempID);