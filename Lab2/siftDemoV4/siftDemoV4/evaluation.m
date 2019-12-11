%

%  Read image
img = imread('retina1.png');
img2 = imread('retina2.png');

% call sift
[image, descriptors, locs] = sift('retina1.png');
showkeys(image, locs);

%folder 0
match('retina1.png', 'retina2.png');
match('skin1.jpg', 'skin2.jpg');        %good

%folder 1
match('00.png', '01.png');              %terrible

%folder 2
match('ELM_42_14445.jpg', 'ELM_42_14465.jpg'); % nothing
match('ELM_42_14445.jpg', 'ELM_42_14490.jpg'); % terrible
match('ELM_42_14465.jpg', 'ELM_42_14490.jpg'); % terrible



computeHomography(Features(1).xy, Features(2).xy, Model)

tform = affine2d(H)
tform = projective2d(H)

J = imwarp(I,projective2d(H));
figure
imshow(J)



