% This script computes the Registration for the checkerboard data set
clc; close all; clear all;

trf = 4; % 1=Euclidean, 2=Similarity, 3=Affine, 4=Projective
normaliz = false; % no need to normalise
im1 = imread('ELM_42_14415.jpg');
im5 = imread('ELM_42_14415.jpg');
im01 = imread('ELM_42_14437.jpg');
asd = preprocesskin(im1);
imwrite(asd,'ELM_42_14415pre.jpg');
bas = preprocesskin(im01);
imwrite(bas,'ELM_42_14437pre.jpg');
im02 = imread('ELM_42_14415pre.jpg');
im03 = imread('ELM_42_14437pre.jpg');
im1 = rgb2gray(im1);
% im01 = rgb2gray(im01);
% im02 = rgb2gray(im02);
% im03 = rgb2gray(im03);
siz = size(im1);
Z = uint8(zeros(siz));

[f1, f2] = matchGet('skin1.jpg', 'skin2.jpg');
[f1, f2] = matchGet('ELM_42_14417.jpg', 'ELM_42_14461.jpg');

H = computeHomography(f1, f2, trf, normaliz);
[best_H, best_err, best_in] = computeHomographyRansac(f1, f2, trf, normaliz);
% computeHomographyRANSAC(F1, F2, trf, normaliz, iter, errth)
err = reprojectionError(f1, f2, H);
fprintf('All features normalised reprojection error is %f, while the inliers one is %f', err, best_err);
J = imwarp(im1, projective2d(H'), 'OutputView', imref2d( size(im03) ));
Jc = imwarp(im1, projective2d(best_H'), 'OutputView', imref2d( size(im03) ));


% J = imwarp(im1, projective2d(H'));
% imshow(J)
% imshowpair(im1, J)

J = cat(3, rgb2gray(im03), J, Z);
Jc = cat(3, rgb2gray(im03), Jc, Z);



[O, K] = thirdpartymatch(im02, im03);
H1 = computeHomography(O, K, trf, normaliz);
[best_H1, best_err1, best_in1] = computeHomographyRansac(O, K, trf, normaliz);
% computeHomographyRANSAC(F1, F2, trf, normaliz, iter, errth)
err1 = reprojectionError(O, K, H1);
fprintf('All features normalised reprojection error is %f, while the inliers one is %f \n', err1, best_err1);
J1 = imwarp(im1, projective2d(H1'), 'OutputView', imref2d( size(im03) ));
Jc1 = imwarp(im1, projective2d(best_H1'), 'OutputView', imref2d( size(im03) ));

J1 = cat(3, rgb2gray(im03), J1, Z);
Jc1 = cat(3, rgb2gray(im03), Jc1, Z);
figure
subplot(121),imshow(im02), title('original image')
subplot(122),imshow(im03), title('target image')
% 
% figure
% subplot(121),imshow(J), title('with outliers')
% subplot(122),imshow(Jc), title('after outlier rejection')

figure
subplot(121),imshow(J), title('SIFT overlaying outliers')
subplot(122),imshow(J1), title('VLSIFT overlaying outliers')
% subplot(143),imshow(J), title('RGB overlaying img 0 transf. with img 1')
% subplot(144),imshow(Jc), title('inlier overlaying')

figure
subplot(121),imshow(Jc), title('SIFT overlaying inliers')
subplot(122),imshow(Jc1), title('VLSIFT overlaying inliers')