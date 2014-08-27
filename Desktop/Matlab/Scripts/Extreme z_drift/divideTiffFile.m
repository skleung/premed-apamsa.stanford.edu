function [divided] = divideTiffFile(Z, T, FNAME, divNumber)

fnameA = FNAME;
infoA = imfinfo(fnameA);
div = round(T/divNumber);

for i = 1 : divNumber
    save_fname = [num2str(i) '_partial_' FNAME];
    for n = (div*(i-1))*Z + 1 : (div*i)*Z
        current_frame = double ( imread(fnameA, n, 'Info', infoA));
        if n == (div*(i-1))*Z + 1
          imwrite(uint16(current_frame), save_fname);
        else
          imwrite(uint16(current_frame), save_fname, 'writemode', 'append');
        end
    end   
end

end

