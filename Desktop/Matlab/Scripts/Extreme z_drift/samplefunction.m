function [] = samplefunction(n)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
myText = '0';
for k=1:n
    myText = [myText, num2str(k)];
end

disp(myText);
end

