function [ Iregistered, M] = affineReg2D( Imoving, Ifixed, init)
%Example of 2D affine registration
%   Robert Martí  (robert.marti@udg.edu)
%   Based on the files from  D.Kroon University of Twente

% clean
clear all; close all; clc;



% Read two imges
% Imoving=im2double(rgb2gray(imread('brain3.png')));  %Moving image
% Ifixed=im2double(rgb2gray(imread('brain1.png')));   %Fixed image

Im=Imoving;
If=Ifixed;
mtype = 'sd'; % metric type: sd: ssd gcc: gradient correlation; cc: cross-correlation
%   mtype = 'cc'; % metric type: sd: ssd gcc: gradient correlation; cc: cross-correlation
% mtype = 'gcc'; % metric type: sd: ssd gcc: gradient correlation; cc: cross-correlation
% mtype = 'mcc';

%  ttype = 'r'; % rigid registration, options: r: rigid, a: affine
ttype = 'a'; % rigid registration, options: r: rigid, a: affine


% Parameter scaling of the Translation and Rotation
% and initial parameters
switch ttype
    case 'r'
        x=[0 0 0];
        scale = [1 1 0.1];
        % Make the affine transformation matrix
        M=[ cos(x(3)) sin(x(3)) x(1);
            -sin(x(3)) cos(x(3)) x(2);
            0 0 1];
    case 'a'
        x=[1 0 0 0 1 0]; % this corresponds to the identity transformation
        scale = [1 1 1 1 1 1];
        %          scale = [0.1 0.01 0.01 0.1 1 1];
        M = [ x(1) x(2) x(3);
            x(4) x(5) x(6);
            0 0 1];
end



x=x./scale;

tic
[x]=fminsearch(@(x)affine_registration_function(x,scale,Im,If,mtype,ttype),...
    x,optimset('Display','iter','MaxIter',1500, 'TolFun', 1.000000e-10,'TolX',1.000000e-10, 'MaxFunEvals', 1000*length(x)));
% [x]=lsqnonlin(@(x)affine_registration_function(x,scale,Im,If,mtype,ttype),...
%     x,[],[],optimset('PlotFcns',@optimplotfval,'Display','iter','MaxIter',1000, 'TolFun', 1.000000e-10,'TolX',1.000000e-10, 'MaxFunEvals', 1000*length(x)));
toc
x=x.*scale;

switch ttype
    case 'r'
        %         x=[0 0 0];
        scale = [1 1 0.1];
        % Make the affine transformation matrix
        M=[ cos(x(3)) sin(x(3)) x(1);
            -sin(x(3)) cos(x(3)) x(2);
            0 0 1];
    case 'a'
        %          x=[1 0 0 0 1 0];
        scale = [1 1 1 1 1 1];
        %          scale = [0.1 0.01 0.01 0.1 1 1];
        M = [ x(1) x(2) x(3);
            x(4) x(5) x(6);
            0 0 1];
end

% Transform the image
Icor=affine_transform_2d_double(double(Im),double(M),1); % 3 stands for cubic interpolation

% Show the registration results
figure,
subplot(2,2,1), imshow(If), title('Fixed Image');
subplot(2,2,2), imshow(Im), title('Moving Image');
subplot(2,2,3), imshow(Icor),title('Final Moved Image') ;
subplot(2,2,4), imshow(abs(If-Icor)),title('Overlapped Images');

Iregistered = Icor;

