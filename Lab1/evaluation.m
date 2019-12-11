function [x] = evaluation(trans, metric, layers, images)
%This is the optimization/evaluation
numi = size(images,3); %number of images
cols = 4; %columns for the plots
rows = ceil(numi*(numi-1)/cols);
figure();
index = 0;
for i = 1:numi %fixed image
    for j = 1:numi %moving image
        if i~= j
            switch trans
                case 'r'
                    x=[0 0 0];
                    scale = [1 1 0.1];
                case 'a'
                    x=[1 0 0 0 1 0]; % this corresponds to the identity transformation
                    scale = [1 1 1 1 1 1];
            end
            
            for s = 1:layers
                ss = layers + 1 - s;
                
                %we scale the translation to account for the image scaling
                switch trans
                    case 'r'
                        x(1:2) = x(1:2)*(ss+1)/ss;
                    case 'a'
                        x(3) = x(3)*(ss+1)/ss;
                        x(6) = x(6)*(ss+1)/ss;
                end
%                 fprintf('/n starting x is ');
%                 x
                x=x./scale;
                If = imresize(images(:,:,i), 1/ss);
                Im = imresize(images(:,:,j), 1/ss);
                
                % we check if there is an inversion by comparing the
                % extreme histogram pixels
                comp = (mode(If, 'all') - graythresh(If))*(mode(Im, 'all') - graythresh(Im));
                if comp < 0
                    Im = 1 - Im;
                    fprintf('The Moving image looks to be inverted with respect to the Fixed one, so we apply an inversion before registration');
                end
                
                %                 'PlotFcns',@optimplotfval,
                [x]=fminsearch(@(x)affine_registration_function(x,scale,Im,If,metric, trans),...
                    x,optimset('Display','final','MaxIter',600,...
                    'TolFun', 1.000000e-6,'TolX',1.000000e-6, 'MaxFunEvals', 1000*length(x)));
                
                [x]=fminsearch(@(x)affine_registration_function(x,scale,Im,If,metric,trans),...
                    x,optimset('Display','final','MaxIter',1500,...
                    'TolFun', 1.000000e-8,'TolX',1.000000e-8, 'MaxFunEvals', 1000*length(x)));
                
                
                x=x.*scale;
%                 fprintf('/n ending x is ');
%                 x
                
            end
            
            %here we have finished the evaluation for the i, j combination
            %of images, and can, thus, return the transformation matrix and
            %the final metric for evaluation
            switch trans
                case 'r'
                    M=[ cos(x(3)) sin(x(3)) x(1);
                        -sin(x(3)) cos(x(3)) x(2);
                        0 0 1];
                case 'a'
                    M = [ x(1) x(2) x(3);
                        x(4) x(5) x(6);
                        0 0 1];
            end
            
            
                Im = images(:,:,j);
                
                % we check if there is an inversion by comparing the
                % extreme histogram pixels
                comp = (mode(If, 'all') - graythresh(If))*(mode(Im, 'all') - graythresh(Im));
                if comp < 0
                    Im = 1 - Im;
                    fprintf('The Moving image looks to be inverted with respect to the Fixed one, so we apply an inversion before registration');
                end
                
            % %Transformation to get the final registered moving image
            % %             1: lineal
            % %             3: cubic
            % %             5: nearest
            Ifinal = affine_transform_2d_double(double(Im),double(M),1); % 3 stands for cubic interpolation
            index = index + 1; %subplot index
            subplot(rows, cols, index);
            imshow(abs(Ifinal-images(:,:,i)));
            tit = [num2str(i) ' - ' num2str(j)];
            title(tit);
            
            fprintf('Evaluation is  %d %% done \n',round(100*index/numi/(numi-1)));
        end
    end
end



end