img = imread('Beautiful-Green-Nature-With-Birds-Blue-Jay-Bird.jpg');
img = im2double(rgb2gray(img));

blur_angle = 1;

%interp = 'bilinear';
interp = 'bicubic';

%% create synthetic blurred image
% todo: synth blur kernel
r = imrotate(img, blur_angle, interp, 'crop');
s = (img + r) / 2; 

%% derivate by subtracting slightly rotated image
sz = max(size(img));
dth = atand(1/sz); % creates 1 pixel difference at the farmost pixel
sdth = s - imrotate(s, dth, interp, 'crop');

figure(1);
imagesc(sdth);

%% compare similarity with rotated copies of the derivative
theta = -3:0.1:3;
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