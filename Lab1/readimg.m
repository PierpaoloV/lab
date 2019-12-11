function [images] = readimg()
images = zeros(353,354,3);
s1 = 'brain';
s2 ='.png';
for i = 1:4
    img = strcat(s1,num2str(i),s2);
    currimg = im2double(rgb2gray(imread(img)));
    images(:,:,i) = currimg;
end
end


