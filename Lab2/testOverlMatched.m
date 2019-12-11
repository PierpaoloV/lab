% This script computes the Registration for the checkerboard data set


trf = 'Projective';
trf = 'Affine';
trf = 'Similarity';
normaliz = false;
im1 = imread('skin1.jpg');
im01 = imread('skin2.jpg');
im02 = imread('02.png');
im03 = imread('03.png');
im1 = rgb2gray(im1);
% im01 = rgb2gray(im01);
% im02 = rgb2gray(im02);
% im03 = rgb2gray(im03);
siz = size(im1);
Z = uint8(zeros(siz));

[f1, f2] = matchGet('skin1.jpg', 'skin2.jpg');

H = computeHomography(f1, f2, trf, normaliz);
H = computeHomography(f1(1:18,:), f2(1:18,:), trf, normaliz); %manually take out the outlier to test the matchng
err = reprojectionError(f1, f2, H)
J = imwarp(im1, projective2d(H'), 'OutputView', imref2d( size(im01) ));
% J = imwarp(im1, projective2d(H'));
% imshow(J)
% imshowpair(im1, J)
J = cat(3, rgb2gray(im01), J, Z);
figure
subplot(131),imshow(im1), title('img 0')
subplot(132),imshow(im01), title('img 1')
subplot(133),imshow(J), title('RGB overlaying img 0 transf. with img 1')

falseColorOverlay = imfuse( J, im01);
imshow( falseColorOverlay, 'initialMagnification', 'fit');

% H = computeHomography(Features(1).xy, Features(3).xy, trf, normaliz);
% err = reprojectionError(Features(1).xy, Features(2).xy, H)
% J = imwarp(im1,projective2d(H'));
% siz2 = size(J);
% h = round((siz2(1)-siz(1))/2);
% w = round((siz2(2)-siz(2))/2);
% J = J(1+h:h+siz(1),1+w:w+siz(2));
% J = cat(3, rgb2gray(im02), J, Z);
% subplot(334),imshow(im1), title('img 0')
% subplot(335),imshow(im02), title('img 2')
% subplot(336),imshow(J), title('RGB overlaying img 0 transf. with img 2')
% 
% 
% H = computeHomography(Features(1).xy, Features(4).xy, trf, normaliz);
% err = reprojectionError(Features(1).xy, Features(2).xy, H)
% J = imwarp(im1,projective2d(H'));
% J = padarray(J,[50,50],'both');
% siz2 = size(J);
% [x, y] = find( im1>200 );
% cdg = [mean(x) mean(y)];
% % T = graythresh(im03);
% [x, y] = find( J > 200 );
% cdg2 = [mean(x) mean(y)];
% aux = -22;
% aux2 = -30;
% h = round(cdg2(1)-cdg(1)+1+aux);
% w = round(cdg2(2)-cdg(2)+1+aux2);
% J = J(h:h+siz(1)-1, w:w+siz(2)-1);
% J = cat(3, im03, J, Z);
% subplot(337),imshow(im1), title('img 0')
% subplot(338),imshow(im03), title('img 3')
% subplot(339),imshow(J), title('RGB overlaying img 0 transf. with img 3')