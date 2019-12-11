%%Brief script for images matching

function [O, K] = thirdpartymatch(Ia, Ib, featnum)
tic
if nargin == 2
    featnum = -1;
end

% VL_DEMO_SIFT_MATCH  Demo: SIFT: basic matching
% pfx = fullfile(vl_root,'figures','demo') ;
% randn('state',0) ;
% rand('state',0) ;


% --------------------------------------------------------------------
%                                                    Create image pair
% --------------------------------------------------------------------

% Ia = imread(fullfile(vl_root,'data','roofs1.jpg')) ;
% Ib = imread(fullfile(vl_root,'data','roofs2.jpg')) ;

% --------------------------------------------------------------------
%                                           Extract features and match
% --------------------------------------------------------------------
trr=35.6;
[fa,da] = vl_sift(im2single(rgb2gray(Ia))) ;
% [fa,da] = vl_sift(im2single(rgb2gray(Ia)),'FirstOctave',-1,'peakthresh',trr/1000);

% [fa,da] = vl_sift(im2single(rgb2gray(Ia)),'FirstOctave',-1,'peakthresh',trr/1000);
fprintf('\nI calculated on the fisrt image');
 %A THRESHOLD OF 0.01 IS GOOD BECAUSE IT ALLOW THE VISUALIZATION OF A SERIES
 %OF POINTS ALREADY
[fb,db] = vl_sift(im2single(rgb2gray(Ib))) ;
% [fb,db] = vl_sift(im2single(rgb2gray(Ib)),'FirstOctave',-1,'peakthresh',trr/1000);
% [fb,db] = vl_sift(im2single(rgb2gray(Ib)),'FirstOctave',-1,'peakthresh',trr/1000);
fprintf('\nI calculated on the second image');

[matches, scores] = vl_ubcmatch(da,db) ;
fprintf('\nI ubmatched');
fprintf('\n I got %d, matches', size(matches,2));
[drop, perm] = sort(scores, 'descend') ;

fprintf('\nI sorted\n');
matches = matches(:, perm) ;
scores  = scores(perm) ;
if featnum > 0
    matches = matches(:,1:featnum);
    scores = scores(1:featnum);
end
% figure(1) ; clf ;
% imagesc(cat(2, Ia, Ib)) ;
% axis image off ;
% vl_demo_print('sift_match_1', 1) ;
% 
% figure(2) ; clf ;
% figure(1) ; clf ;
% imagesc(cat(2, Ia, Ib)) ;

xa = fa(1,matches(1,:)) ;
xb = fb(1,matches(2,:)) ;
ya = fa(2,matches(1,:)) ;
yb = fb(2,matches(2,:)) ;
f1 = [xa ;ya]';
f2 = [xb ;yb]';
% xa = fa(1,matches(1,:)) ;
% xb = fb(1,matches(2,:)) + size(Ia,2) ;
% ya = fa(2,matches(1,:)) ;
% yb = fb(2,matches(2,:)) ;
% hold on ;
% h = line([xa ; xb], [ya ; yb]) ;
% set(h,'linewidth', 1, 'color', 'b') ;
% 
% vl_plotframe(fa(:,matches(1,:))) ;
% fb(1,:) = fb(1,:) + size(Ia,2) ;
% vl_plotframe(fb(:,matches(2,:))) ;
% axis image off ;

O = f1;
K = f2;
% vl_demo_print('sift_match_2', 1) ;
toc
end