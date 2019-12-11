% This script computes the Registration for the checkerboard data set


trf = 4; % 1=Euclidean, 2=Similarity, 3=Affine, 4=Projective
normaliz = false; % no need to normalise
im1 = imread('skin1.jpg');
im01 = imread('skin2.jpg');
im02 = imread('retina1.png');
im03 = imread('retina2.png');
im1 = rgb2gray(im1);
% im01 = rgb2gray(im01);
% im02 = rgb2gray(im02);
% im03 = rgb2gray(im03);
siz = size(im1);
Z = uint8(zeros(siz));

[f1, f2] = matchGet('skin1.jpg', 'skin2.jpg');

H = computeHomography(f1, f2, trf, normaliz);
[best_H, best_err, best_in] = computeHomographyRANSAC(f1, f2, trf, normaliz);
% computeHomographyRANSAC(F1, F2, trf, normaliz, iter, errth)
err = reprojectionError(f1, f2, H);
fprintf('All features normalised reprojection error is %f, while the inliers one is %f', err, best_err);
J = imwarp(im1, projective2d(H'), 'OutputView', imref2d( size(im01) ));
Jc = imwarp(im1, projective2d(best_H'), 'OutputView', imref2d( size(im01) ));
% J = imwarp(im1, projective2d(H'));
% imshow(J)
% imshowpair(im1, J)
J = cat(3, rgb2gray(im01), J, Z);
Jc = cat(3, rgb2gray(im01), Jc, Z);

figure
subplot(121),imshow(im1), title('original image')
subplot(122),imshow(im01), title('target image')

figure
subplot(121),imshow(J), title('with outliers')
subplot(122),imshow(Jc), title('after outlier rejection')


% figure
% subplot(141),imshow(im1), title('img 0')
% subplot(142),imshow(im01), title('img 1')
% subplot(143),imshow(J), title('RGB overlaying img 0 transf. with img 1')
% subplot(144),imshow(Jc), title('inlier overlaying')