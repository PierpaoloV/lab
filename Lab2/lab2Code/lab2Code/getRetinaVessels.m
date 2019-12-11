function cleanVess = getRetinaVessels (I)
% based on the work of  Tyler Coye (2019). Novel Retinal Vessel Segmentation Algorithm: Fundus Images (https://www.mathworks.com/matlabcentral/fileexchange/50839-novel-retinal-vessel-segmentation-algorithm-fundus-images), MATLAB Central File Exchange. Retrieved November 23, 2019. 

% Read image
im = im2double(I);

% Convert RGB to Gray via PCA
lab = rgb2lab(im);
f = 0;
wlab = reshape(bsxfun(@times,cat(3,1-f,f/2,f/2),lab),[],3);
[C,S] = pca(wlab);
S = reshape(S,size(lab));
S = S(:,:,1);
gray = (S-min(S(:)))./(max(S(:))-min(S(:)));

%% Contrast Enhancment of gray image using CLAHE
J = adapthisteq(gray,'numTiles',[8 8],'nBins',128);

%% Background Exclusion
% Apply Average Filter
h = fspecial('average', [9 9]);
JF = imfilter(J, h);
% figure, imshow(JF), title('after average filter')

% Take the difference between the gray image and Average Filter
Z = imsubtract(JF, J);
% figure, imshow(Z), title('after difference')

%% Threshold using the IsoData Method
level=isodata(Z); % this is our threshold level

%% Convert to Binary
% BW = im2bw(Z, level-.008); % original
BW = im2bw(Z, level-.000);
% figure, imshow(BW), title('after converting to binary')


%% Remove small pixels
BW2 = bwareaopen(BW, 100);
% figure, imshow(BW2), title('after removing small px')


%%Apply mask
grimg = rgb2gray(I);
thOtsu = graythresh(grimg);
mask = imbinarize(grimg,thOtsu);

%%erode mask
se = strel('disk',5);
erodedMask = imerode(mask,se);

%%apply mask
almostClean = erodedMask.*BW2;
% figure, imshow(almostClean), title('After applying mask')

%%Keep maximum area blob
cleanVess = bwareafilt(almostClean>0,1);
% figure, imshow(cleanVess)
end