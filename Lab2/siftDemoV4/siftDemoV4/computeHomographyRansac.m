function [best_H, best_err, best_in] = computeHomographyRansac(F1, F2, trf, normaliz, iter, errth)
% This function cleans a set of matches with the goal of rejecting outliers.

% INPUTS
% F1: column of feature points
% F2: column of feature points to match (H*F1 = F2)
% trf: transformation number from 1 to 4 >>> 1=Euclidean, 2=Similarity, 3=Affine, 4=Projective
% normaliz: true or false. whether the data is to be normalised before the homography computation
% iter: optional number of iterations. Otherwise it is calculated.
% errth: threshold for the reprojective error. Used to calculate the inliers

% OUTPUTS
%     best_H: the best fitting Homography
%     best_err: normalised reprojection error
%     best_in: number of inliers found
%
% Function coded by Isaac Llorente, Pierpaolo Venditelli, MAIA master in Girona, 2019

if nargin < 3
    trf = 4; % We use Projective transformation by default
end
if nargin < 4
    normaliz = false;
end
if nargin < 5
    %     We estimate the iteration number needed [from doi:10.1145/358669.358692]
    w = 0.9;             % inlier proportion estimation
    p = 0.995;          % desired probability of success
    n = max(2,trf);     % number of points per sample
    iter = log(1-p)/log(1-w^n);
    iter = ceil(iter + 6*sqrt(1-w^n)/(w^n));    % for additional confidence we can add the standard deviation
    iter = max(20, iter);                             % we set 20 as the minimum number of iterations
end
if nargin < 6
    errth = 100; % error threshold for calculating inliers
end

len = size(F1, 1);          % Pool length of matched features
best_err = errth + 100;  % initialisation of best error
best_in = 1;                 % initialisation of best number of inliers

for i = 1:iter
    idx = randsample(len,max(2,trf)); % Indexes of the sampled feature points
    
    s1 = F1(idx,:);
    s2 = F2(idx,:);
    H = computeHomography(s1, s2, trf, normaliz);
    
    % We now find the inliers by using the reprojection error
    len = size(F1, 1);
    F = [F1, ones(len,1)];
    M = [F2, ones(len,1)];
    f2 = H*F';
    f2(1,:) = f2(1,:)./f2(3,:);
    f2(2,:) = f2(2,:)./f2(3,:);
    
    err1 = f2-M';
    err1 = err1(1:2,:)';
    mod_err = sqrt(err1(:,1).^2+err1(:,2).^2);
    in_idx = find(abs(mod_err)<=errth);              %index of inliers
    tot_in = length(in_idx);                                % total number of inliers
    
    if tot_in > best_in % we replace our best match in terms of number of inliers
        best_in = tot_in;
        best_H = computeHomography(F1(in_idx,:), F2(in_idx,:), trf, normaliz);
        best_err = reprojectionError(F1(in_idx,:), F2(in_idx,:), best_H)/tot_in;
        
    elseif tot_in == best_in % we compare the best fitting approach and get the minimum error one
        this_H = computeHomography(F1(in_idx,:), F2(in_idx,:), trf, normaliz);
        this_err = reprojectionError(F1(in_idx,:), F2(in_idx,:), this_H)/tot_in;
        if this_err < best_err
            best_err = this_err;
            best_H = this_H;
        end
        
    end
    
end
fprintf('\nThe number of inliers found was %d', best_in)
fprintf('\nThe normalised reprojective error was %f\n', best_err)








