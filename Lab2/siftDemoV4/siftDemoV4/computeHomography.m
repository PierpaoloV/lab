function [H] = computeHomography(Features, Matches, Model, norm)
%   This function computes the homography between two images Fixed and Moved
%       given a model (Euclidean, Similarity, Affine and Projective)
%       H*Features = Matches
%
%   We also give the user an opportunity for chosing the correct
%       transformation, in case there's a typo in the function calling
%
% Model: transformation 1=Euclidean, 2=Similarity, 3=Affine, 4=Projective


cond = false; %initialization of the condition to ask for correct user input

%We normalize the data if asked for. This could speed up the process.
originalF = Features;
originalM = Matches;
if norm
    %     fprintf('normalizing the features')
    
    mf = mean(Features);
    mm = mean(Matches);
    Features = Features - mf;
    Matches = Matches - mm;
    sf = std(Features(:));
    sm = std(Matches(:));
    Features = Features / sf;
    Matches = Matches / sm;
end

%We expand the coordinates to homogeneous
len = size(Features, 1);
F = [Features, ones(len,1)];
M = [Matches, ones(len,1)];

switch Model
    case 1 % Euclidean
        %we have translation and rotation
        mfx = mean(Features);
        mmx = mean(Matches);
        F2 = F(:,1:2)-mfx;
        M2 = M(:,1:2)-mmx;
        % We use the properties of Singular value decomposition
        [U, ~, V] = svd(F2'*M2);
        r2 = V*U';
        H = [eye(2), mmx'; 0,0,1]*[r2, [0;0];0 0 1]*[eye(2), -mfx'; 0,0,1];
        
        
    case 2 % 'Similarity'
        %we have translation, scale and rotation
        mfx = mean(Features);
        mmx = mean(Matches);
        F2 = F(:,1:2)-mfx;
        M2 = M(:,1:2)-mmx;
        s = sqrt((M2(:,1)'*M2(:,1)+M2(:,2)'*M2(:,2))/(F2(:,1)'*F2(:,1)+F2(:,2)'*F2(:,2)));
        F2 = F2*s;
        [U, ~, V] = svd(F2'*M2);
        r2 = V*U';
        %         r2 = M2'/F2';     % Direct way to obtain the LSE 2x2 matrix
        H = [eye(2), mmx'; 0,0,1]*[r2*s, [0;0];0 0 1]*[eye(2), -mfx'; 0,0,1];
        
    case 3 % 'Affine'
        % F2*h2 = M2
        % H = M'/F';   % direct implementation
        h2 = [F, zeros(len, 3); zeros(len, 3), F] \ [M(:,1);M(:,2)];
        H = [h2(1:3)';h2(4:6)';0 0 1];
    case 4 % 'Projective'
        h2 = [F, zeros(len, 3), -M(:,1).*F(:,1), -M(:,1).*F(:,2);...
            zeros(len, 3), F, -M(:,2).*F(:,1), -M(:,2).*F(:,2)] \ [M(:,1);M(:,2)];
        H = [h2(1:3)';h2(4:6)';[h2(7:8)',1]];
        
    otherwise
        while ~cond
            fprintf('\nNone of the predefined transformation methods called. Please choose one');
            prompt =  '\nPress a number from 1 to 4: 1=Euclidean, 2=Similarity, 3=Affine, 4=Projective or 0=Stop\n';
            x = input(prompt);
            cond = mod(x,1) == 0 & x<5 &x>=0;
            
        end
        if x == 0
            fprintf ('Computation stopped by user request')
            H=[];
        else
            H = computeHomography(originalF, originalM, x, norm);
            norm = false;
        end
end

if norm & ~cond
    %     fprintf('we de-normalise')
    H = [eye(2), mm';0,0,1] * ([eye(2)*(sm),[0;0];0,0,1] * (H * ([eye(2)*(1/sf),[0;0];0,0,1] * [eye(2), -mf';0,0,1])));
end

