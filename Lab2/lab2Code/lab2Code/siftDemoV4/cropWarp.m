function J = cropWarp(img1, H, siz2)
%This function returns the correctly cropped version of the warped image,
%given the image to be transformed, the transformation matrix, and the size
%of the target image

if nargin == 2
    siz2 = size(img1);
end

siz1 = size(img1);

c = H * [0;0;1];
c1 = c/c(3,1);

c = H * [0;siz1(2);1];
c2 = c/c(3,1);

c = H * [siz1(1);0;1];
c3 = c/c(3,1);

c = H * [siz1(1);siz1(2);1];
c4 = c/c(3,1);

if length(siz1) >2
    img1 = rgb2gray(img1);
end

cn = round(min([c1(1),c2(1),c3(1),c4(1)]));
% cs = max([c1(1),c2(1),c3(1),c4(1)]);
cw = round(min([c1(2),c2(2),c3(2),c4(2)]));
% ce = max([c1(2),c2(2),c3(2),c4(2)]);

J = imwarp(img1, projective2d(H'));
J = imwarp(img1, projective2d(H'), 'OutputView', imref2d( siz2 ));
imshow(J)
J2 = J(1-cn:siz2(1)-cn, 1-cw:siz2(2)-cw);
J2 = J(1-cn:siz2(1)-cn, 1-cw:2204);
