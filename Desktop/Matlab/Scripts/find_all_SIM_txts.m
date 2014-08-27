
function output = find_all_SIM_txts(Directory, xlsName)
disp(Directory);
output = 0;
temp_list = dir( fullfile(Directory,'*.txt') ) ;
originalSheet = xlsread(xlsName);
row_size = size(originalSheet,1);
for i = 1 : numel(temp_list)
    linecount = 0;
    zcount = 0;
    zspacing = 0;
    num_laser = 0;
    fileID = fopen(fullfile(Directory, temp_list(i).name) , 'r');
    tline = fgetl(fileID);
    while ischar(tline)
        if linecount == 0
            A = sscanf(tline, '%*s %d %d');
            num_laser = numel(A);
        end
        if linecount == 7
            A = sscanf(tline, '%f');
            zspacing = A(1);
        end
        if linecount == 8
            A = sscanf(tline, '%f');
            zspacing = abs( zspacing - A(1) );
        end
        if linecount >= 7
            zcount = zcount + 1;
        end
        tline = fgetl(fileID);
        linecount = linecount + 1;
    end
    C = { temp_list(i).name, fullfile(Directory, temp_list(i).name), num_laser, zcount, zspacing };
    position = strcat('A',num2str(row_size + 1));
    xlswrite(xlsName, C,'sheet1', position);
    row_size = row_size + 1;
end

ListSubFold = dir(Directory);
ListSubFold = ListSubFold( [ListSubFold(:).isdir] );
for i = 1 : numel(ListSubFold)
   if ~(strcmp(ListSubFold(i).name,'.') || strcmp(ListSubFold(i).name,'..'))
        output = find_all_SIM_txts( fullfile(Directory, ListSubFold(i).name), xlsName);
   end
end

end