function [new] = folder_search_testing(initialPath)
cd (initialPath);
list = dir (initialPath);
for n = 1 : 12
    if list(n).isdir ~= 1
        disp(list(n));
end
listName = {list.name};
end
