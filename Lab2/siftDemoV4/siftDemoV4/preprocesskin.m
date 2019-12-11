function [J] = preprocesskin(I)
% I = imread('skin1.jpg');
% if size(I,3) ==3
%     Ia = rgb2gray(I);
% end
%removal of hairs
% se = strel('disk', 6);
% Ih = imbothat(I,se);
% Ih(Ih>15) =255;
% 
% Ih2 = imadd(I, ceil(Ih./2));


%contrast enhancement
r = I(:,:,1);
g = I(:,:,2);
b = I(:,:,3);
re = adapthisteq(r);
ge = adapthisteq(g);
be = adapthisteq(b);
J = zeros(size(I));
J(:,:,1)=re;
J(:,:,2)=ge;
J(:,:,3)=be;
J = uint8(J);
% figure;
% subplot(121), imshow(I,[]), title('orimage');
% subplot(122), imshow(J,[]), title('clahe');


end