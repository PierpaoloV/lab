function err1 = reprojectionError(Feat1, Feat2, H)
% This function returns the normalised reprojection error, 
% following the lecture's notes

len = size(Feat1, 1);
F = [Feat1, ones(len,1)];
M = [Feat2, ones(len,1)];
f2 = H*F';
f2(1,:) = f2(1,:)./f2(3,:);
f2(2,:) = f2(2,:)./f2(3,:);

err1 = f2-M';
err1 = (sum(err1(1,:)*err1(1,:)','all') + sum(err1(2,:)*err1(2,:)','all'))/(2*len);
end