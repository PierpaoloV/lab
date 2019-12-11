trf = 'Projective';
% trf = 'Affine';
% trf = 'Similarity';
% trf = 'Euclidean';
normaliz = false;

H = computeHomography(Features(1).xy, Features(2).xy, trf, normaliz);
err = reprojectionError(Features(1).xy, Features(2).xy, H)
J = imwarp(im1,projective2d(H'));
figure
subplot(331),imshow(im1), title('img 0')
subplot(332),imshow(im01), title('img 1')
subplot(333),imshow(J), title('img 0 transformed')

H = computeHomography(Features(1).xy, Features(3).xy, trf, normaliz);
err = reprojectionError(Features(1).xy, Features(3).xy, H)
J = imwarp(im1,projective2d(H'));
subplot(334),imshow(im1), title('img 0')
subplot(335),imshow(im02), title('img 2')
subplot(336),imshow(J), title('img 0 transformed')


H = computeHomography(Features(1).xy, Features(4).xy, trf, normaliz);
err = reprojectionError(Features(1).xy, Features(4).xy, H)
J = imwarp(im1,projective2d(H'));
subplot(337),imshow(im1), title('img 0')
subplot(338),imshow(im03), title('img 3')
subplot(339),imshow(J), title('img 0 transformed')