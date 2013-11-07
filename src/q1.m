img = imread('Beautiful-Green-Nature-With-Birds-Blue-Jay-Bird - copy.jpg');
img = im2double(rgb2gray(img));

blur_angle = 0.5;

%interp = 'bilinear';
interp = 'bicubic';

%% create synthetic blurred image
% todo: synth blur kernel
r = imrotate(img, blur_angle, interp, 'crop');
s = (img + r) / 2; 

%% derivate by subtracting slightly rotated image
sz = max(size(img));
dth = atand(2/sz); % creates 1 pixel difference at the farmost pixel
sdth = s - imrotate(s, dth, interp, 'crop');

figure(1);
imagesc(sdth);

%% compare similarity with rotated copies of the derivative
theta = -2:0.1:2;
th_sz = length(theta);
p = zeros(th_sz, 2);

coeff = dot(sdth(:), sdth(:));
for i = 1:th_sz
    si = imrotate(sdth, theta(i), interp, 'crop');
    score = dot(si(:), sdth(:));
    p(i,:) = score / coeff;
end

figure(2);
plot(theta, p);
title(['synthetic blur angle = ' num2str(blur_angle)])