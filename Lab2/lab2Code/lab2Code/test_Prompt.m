% This script computes the Feature Extraction, matching, outlier rejection and Registration


trf = 4; % 1=Euclidean, 2=Similarity, 3=Affine, 4=Projective
normaliz = true; % Data normalisation. true OR false
% im1 = imread('skin1.jpg');
% im01 = imread('skin2.jpg');
im1 = imread('retina1.png');
im01 = imread('retina2.png');
siz = size(im1(:,:,1));
Z = uint8(zeros(siz));
im1r = retinaTest(im1); 
im2r = retinaTest(im01); 
im1r = uint8(255*im1r);
im2r = uint8(255*im2r);
[f1, f2] = matchGet(im1r, im2r);

H = computeHomography(f1, f2, trf, normaliz);
[best_H, best_err, best_in] = computeHomographyRANSAC(f1, f2, trf, normaliz);
err = reprojectionError(f1, f2, H);
fprintf('All features normalised reprojection error is %f, while the inliers one is %f\n', err, best_err);
im1 = rgb2gray(im1);
J = imwarp(im1, projective2d(H'), 'OutputView', imref2d( size(im01) ));
Jc = imwarp(im1, projective2d(best_H'), 'OutputView', imref2d( size(im01) ));
J = cat(3, rgb2gray(im01), J, Z);
Jc = cat(3, rgb2gray(im01), Jc, Z);

figure
subplot(141),imshow(im1), title('original image')
subplot(142),imshow(im01), title('target image')
subplot(143),imshow(J), title('with outliers')
subplot(144),imshow(Jc), title('after outlier rejection')