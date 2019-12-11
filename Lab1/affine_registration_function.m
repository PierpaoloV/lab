function [e]=affine_registration_function(par,scale,Imoving,Ifixed,mtype,ttype)
% This function affine_registration_image, uses affine transfomation of the
% 3D input volume and calculates the registration error after transformation.
%
% I=affine_registration_image(parameters,scale,I1,I2,type);
%
% input,
%   parameters (in 2D) : Rigid vector of length 3 -> [translateX translateY rotate]
%                        or Affine vector of length 7 -> [translateX translateY
%                                           rotate resizeX resizeY shearXY shearYX]
%
%   parameters (in 3D) : Rigid vector of length 6 : [translateX translateY translateZ
%                                           rotateX rotateY rotateZ]
%                       or Affine vector of length 15 : [translateX translateY translateZ,
%                             rotateX rotateY rotateZ resizeX resizeY resizeZ,
%                             shearXY, shearXZ, shearYX, shearYZ, shearZX, shearZY]
%
%   scale: Vector with Scaling of the input parameters with the same length
%               as the parameter vector.
%   I1: The 2D/3D image which is affine transformed
%   I2: The second 2D/3D image which is used to calculate the
%       registration error
%   mtype: Metric type: s: sum of squared differences.
%
% outputs,
%   I: An volume image with the registration error between I1 and I2
%
% example,
%
% Function is written by D.Kroon University of Twente (July 2008)
x=par.*scale;

switch ttype
    case 'r'
        % Make the affine transformation matrix
        M=[ cos(x(3)) sin(x(3)) x(1);
            -sin(x(3)) cos(x(3)) x(2);
            0 0 1];
        
    case 'a'
        M = [ x(1) x(2) x(3);
            x(4) x(5) x(6);
            0 0 1];
        
end


I3=affine_transform_2d_double(double(Imoving),double(M),1); % 3 stands for cubic interpolation

% metric computation
switch mtype
    case 'sd' %squared differences
        e=sum((I3(:)-Ifixed(:)).^2)/numel(I3);
    case 'cc' %Normalized Cross Correlation Intensity Based
        a = (I3- mean(mean(I3)));
        b = (Ifixed- mean(mean(Ifixed)));
        numerator = sum(sum(a.*b));
        d = sum(sum(a.^2));
        d1 = sum(sum(b.^2));
        denominator = sqrt(d*d1);
        e =1-( numerator/denominator);
        
    case 'gcc' %Normalized Cross Correlation Intensity Based
        % A = edge(I3,'sobel');
        %B = edge(Ifixed,'sobel');
        %         [A, kk ] = imgradient(I3,'sobel');
        %         [B,kk1 ] = imgradient(Ifixed,'sobel');
        
        A1 = I3(1:end-1,2:end) - I3(1:end-1,1:end-1); %horizontal gradient
        B1 = Ifixed(1:end-1,2:end) - Ifixed(1:end-1,1:end-1); %horizontal gradient fixed img
        A = A1.*B1;
        A2 = I3(2:end,1:end-1) - I3(1:end-1,1:end-1); %vertical gradient
        B2 = Ifixed(2:end,1:end-1) - Ifixed(1:end-1,1:end-1); %vertical gradient fixed img
        B = A2.*B2;
        %         figure
        %         subplot(221), imshow(A1,[]),title('A1');
        %         subplot(222), imshow(A2,[]),title('A2');
        %         subplot(223), imshow(B1,[]),title('B1');
        %         subplot(224), imshow(B2,[]),title('B2');
        num = abs(A+B);
        numerator = sum(sum(num));
        d = sum(sum(A1.^2+A2.^2));
        d1 = sum(sum(B1.^2+B2.^2));
        denominator = sqrt(d*d1);
        e =1-(numerator/denominator);
        
    case 'ecc' %Efficient Normalized Cross Correlation Intensity Based
        A1 = I3(1:end-1,2:end) - I3(1:end-1,1:end-1); %horizontal gradient
        B1 = Ifixed(1:end-1,2:end) - Ifixed(1:end-1,1:end-1); %horizontal gradient fixed img
        A2 = I3(2:end,1:end-1) - I3(1:end-1,1:end-1); %vertical gradient
        B2 = Ifixed(2:end,1:end-1) - Ifixed(1:end-1,1:end-1); %vertical gradient fixed img
        p = abs(A1.*B1+A2.*B2);
        P = integralImage(p);
        %we now remove the first column and row to remove the 0s and make it the same size as p
        P(:,1)=[];
        P(1,:)=[];
        
        I32 = I3.^2;
        If2 = Ifixed.^2;
        
        A1 = I32(1:end-1,2:end) - I32(1:end-1,1:end-1); %horizontal gradient
        B1 = If2(1:end-1,2:end) - If2(1:end-1,1:end-1); %horizontal gradient fixed img
        A2 = I32(2:end,1:end-1) - I32(1:end-1,1:end-1); %vertical gradient
        B2 = If2(2:end,1:end-1) - If2(1:end-1,1:end-1); %vertical gradient fixed img
        e1 = A1 + A2;
        e2 = B1 + B2;
        
        E1 = integralImage(e1);
        %we now remove the first column and row to remove the 0s and make it the same size as p
        E1(:,1)=[];
        E1(1,:)=[];
        
        E2 = integralImage(e2);
        %we now remove the first column and row to remove the 0s and make it the same size as p
        E2(:,1)=[];
        E2(1,:)=[];
        
        e = P(end,end)/sqrt(E1(end,end)*E2(end,end));
        
    case 'mcc' %multiscale cross correlation
        scales = 3;
        e = 0;
        for i=1:scales
            e = e + mcccalc(imresize(I3,1/(i)),imresize(Ifixed,1/(i)));
        end
    otherwise
        error('Unknown metric type');
end


function [me] = mcccalc (I3, Ifixed)% Normalized Cross Correlation Intensity Based
        a = (I3- mean(mean(I3)));
        b = (Ifixed- mean(mean(Ifixed)));
        numerator = sum(sum(a.*b));
        d = sum(sum(a.^2));
        d1 = sum(sum(b.^2));
        denominator = sqrt(d*d1);
        me =1-( numerator/denominator);


function [me] = mecalc (I3, Ifixed)
        
        A1 = I3(1:end-1,2:end) - I3(1:end-1,1:end-1); %horizontal gradient
        B1 = Ifixed(1:end-1,2:end) - Ifixed(1:end-1,1:end-1); %horizontal gradient fixed img
        A2 = I3(2:end,1:end-1) - I3(1:end-1,1:end-1); %vertical gradient
        B2 = Ifixed(2:end,1:end-1) - Ifixed(1:end-1,1:end-1); %vertical gradient fixed img
        p = abs(A1.*B1+A2.*B2);
        P = integralImage(p);
        %we now remove the first column and row to remove the 0s and make it the same size as p
        P(:,1)=[];
        P(1,:)=[];
        
        I32 = I3.^2;
        If2 = Ifixed.^2;
        
        A1 = I32(1:end-1,2:end) - I32(1:end-1,1:end-1); %horizontal gradient
        B1 = If2(1:end-1,2:end) - If2(1:end-1,1:end-1); %horizontal gradient fixed img
        A2 = I32(2:end,1:end-1) - I32(1:end-1,1:end-1); %vertical gradient
        B2 = If2(2:end,1:end-1) - If2(1:end-1,1:end-1); %vertical gradient fixed img
        e1 = A1 + A2;
        e2 = B1 + B2;
        
        E1 = integralImage(e1);
        %we now remove the first column and row to remove the 0s and make it the same size as p
        E1(:,1)=[];
        E1(1,:)=[];
        
        E2 = integralImage(e2);
        %we now remove the first column and row to remove the 0s and make it the same size as p
        E2(:,1)=[];
        E2(1,:)=[];
        
        me = P(end,end)/sqrt(E1(end,end)*E2(end,end));
