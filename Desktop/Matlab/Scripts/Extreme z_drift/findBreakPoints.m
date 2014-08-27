function [breakpoint] = findBreakPoints(Z , T , FNAME)
fnameA = FNAME;
infoA = imfinfo(fnameA);
maxInt = zeros(1, T);
for n = 1 : T
    current_frame = double ( imread(fnameA, 1+Z*(n-1), 'Info', infoA));
    maxInt(1, n) = max(current_frame(:));
end

for n = 1 : T - 1
    if maxInt(1, n)*3 < maxInt(1,n+1)
        disp(n);
    end
end


