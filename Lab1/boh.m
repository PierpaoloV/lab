
function d = boh2(im1,im2, type, metric, layers )
%my vector

%my matwix
switch type
    
    case 'a'
        %         x =[6.0000   -3.0000    2.0000    2.5000    2.0000    3.0000];
        %         x =[1.5000   -0.5000    1.0000    -0.5000    2.0000    3.0000];
        x =[2.0000   -2.0000    0.0000    2.5000    0.5000    0.5000];
        M = [ x(1) x(2) x(3);
            x(4) x(5) x(6);
            0 0 1];
        scale = [1 1 1 1 1 1];
        y=[1 0 0 0 1 0];
    case 'r'
        %         x =[6.0000   -3.0000    2.0000];
        x =[2.0000   -2.0000    0.0000];
        M=[ cos(x(3)) sin(x(3)) x(1);
            -sin(x(3)) cos(x(3)) x(2);
            0 0 1];
        scale = [1 1 0.1];
        y=[0 0 0];
end
im2a=affine_transform_2d_double(double(im1),double(M),1);
for s = 1:layers
    ss = layers + 1 - s;
    
    %we scale the translation to account for the image scaling
    switch type
        case 'r'
            y(1:2) = y(1:2)*(ss+1)/ss;
            
        case 'a'
            y(3) = y(3)*(ss+1)/ss;
            y(6) = y(6)*(ss+1)/ss;
            
            
    end
    %                 fprintf('/n starting x is ');
    %                 x
    y=y./scale;
    If = imresize(im2a, 1/ss);
    Im = imresize(im1, 1/ss);
    
    % we check if there is an inversion by comparing the
    % extreme histogram pixels
    if (mode(Im, 'all') - graythresh(Im)) > 0
        Im = 1 - Im;
        fprintf('The Moving image looks to be inverted, so we apply an inversion before registration');
    end
    if (mode(If, 'all') - graythresh(If)) > 0
        If = 1 - If;
        fprintf('The Fixed image looks to be inverted, so we apply an inversion before registration');
    end
    
    %                 'PlotFcns',@optimplotfval,
    %             [y]=fminsearch(@(y)affine_registration_function(y,scale,Im,If,metric, type),...
    %                 y,optimset('Display','final','MaxIter',600,...
    %                 'TolFun', 1.000000e-6,'TolX',1.000000e-6, 'MaxFunEvals', 1000*length(y)));
    
    [y]=fminsearch(@(y)affine_registration_function(y,scale,Im,If,metric,type),...
        y,optimset('Display','final','MaxIter',1500,...
        'TolFun', 1.000000e-8,'TolX',1.000000e-8, 'MaxFunEvals', 1000*length(y)));
    
end

%         x
%         y
d = sqrt(sum((x-y).^2));
end