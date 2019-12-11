% This script computes the Feature Extraction, matching, outlier rejection and Registration


trf = 4; % 1=Euclidean, 2=Similarity, 3=Affine, 4=Projective
normaliz = true; % Data normalisation. true OR false
im1 = imread('retina1.png');    % retina image to transform
im01 = imread('retina2.png');   % target image

siz = size(im1(:,:,1));
Z = uint8(zeros(siz)); % empty layer for the B channel in RGB

% Segmenting the vessels
im1r = getRetinaVessels(im1);
im2r = getRetinaVessels(im01); 
im1r = uint8(255*im1r);
im2r = uint8(255*im2r);

% Getting the features from both images
[f1, f2] = matchGet(im1r, im2r);

% We compute the homography both with outliers, and with outlier rejection,
% and calculate the normalised reprojection error
H = computeHomography(f1, f2, trf, normaliz);
err = reprojectionError(f1, f2, H);
[best_H, best_err, best_in] = computeHomographyRANSAC(f1, f2, trf, normaliz);
fprintf('All features normalised reprojection error is %f, while the inliers one is %f\n', err, best_err);

% We transform the original image and overlay it with the target
im1 = rgb2gray(im1);
J = imwarp(im1, projective2d(H'), 'OutputView', imref2d( size(im01) ));
Jc = imwarp(im1, projective2d(best_H'), 'OutputView', imref2d( size(im01) ));
J = cat(3, rgb2gray(im01), J, Z);
Jc = cat(3, rgb2gray(im01), Jc, Z);

% We plot the images
figure
subplot(221),imshow(im1), title('original image')
subplot(222),imshow(im01), title('target image')
subplot(223),imshow(J), title('with outliers')
subplot(224),imshow(Jc), title('after outlier rejection')