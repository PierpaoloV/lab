function [e] = calculatemetric(par,scale,I_fix, I_mov, metric,trans)
%Calculate the metric given the different parameters 


x=par.*scale;

switch trans
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


I_mov=affine_transform_2d_double(double(I_mov),double(M),1);
switch metric
    case 'sd' %squared differences
        e=sum((I_mov(:)-I_fix(:)).^2)/numel(I_mov);
        
    case 'cc' %Normalized Cross Correlation Intensity Based
        a = (I_mov- mean(mean(I_mov)));
        b = (I_fix- mean(mean(I_fix)));
        numerator = sum(sum(a.*b));
        d = sum(sum(a.^2));
        d1 = sum(sum(b.^2));
        denominator = sqrt(d*d1);
        e =1-( numerator/denominator);
        
    case 'gcc' %Normalized Cross Correlation Intensity Based
        A1 = I_mov(1:end-1,2:end) - I_mov(1:end-1,1:end-1); %horizontal gradient
        B1 = I_fix(1:end-1,2:end) - I_fix(1:end-1,1:end-1); %horizontal gradient fixed img
        A = A1.*B1;
        A2 = I_mov(2:end,1:end-1) - I_mov(1:end-1,1:end-1); %vertical gradient
        B2 = I_fix(2:end,1:end-1) - I_fix(1:end-1,1:end-1); %vertical gradient fixed img
        B = A2.*B2;
        num = abs(A+B);
        numerator = sum(sum(num));
        d = sum(sum(A1.^2+A2.^2));
        d1 = sum(sum(B1.^2+B2.^2));
        denominator = sqrt(d*d1);
        e =1-(numerator/denominator);
        
    case 'ecc' %Efficient Normalized Cross Correlation Intensity Based
        A1 = I_mov(1:end-1,2:end) - I_mov(1:end-1,1:end-1); %horizontal gradient
        B1 = I_fix(1:end-1,2:end) - I_fix(1:end-1,1:end-1); %horizontal gradient fixed img
        A2 = I_mov(2:end,1:end-1) - I_mov(1:end-1,1:end-1); %vertical gradient
        B2 = I_fix(2:end,1:end-1) - I_fix(1:end-1,1:end-1); %vertical gradient fixed img
        p = abs(A1.*B1+A2.*B2);
        P = integralImage(p);
        %we now remove the first column and row to remove the 0s and make it the same size as p
        P(:,1)=[];
        P(1,:)=[];
        
        I32 = I_mov.^2;
        If2 = I_fix.^2;
        
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
    otherwise 
        error('Unknown metric type');


end

% function [met] = msmetric(I_fix, I_mov, metric, scales)
% % if nargin < 3 reutrn error as print
% met = 0;
% end