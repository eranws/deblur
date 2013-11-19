img = imread('Beautiful-Green-Nature-With-Birds-Blue-Jay-Bird - copy.jpg');
img = im2double(rgb2gray(img));

%img = imresize(img, 0.5);
%img = ones(size(img));

blur_angle = 0.5;

sm = size(img) * tand(blur_angle); %safe_margins
sm = ceil(sm) + 2; % +2 to be extra safe...

%interp = 'bilinear';
interp = 'bicubic';

%% create synthetic blurred image
% todo: synth blur kernel
r = imrotate(img, blur_angle, interp, 'crop');
s = (img + r) / 2; 

%% derivate by subtracting slightly rotated image
sz = max(size(img));

dth = atand(2/sz); % creates 1 pixel difference at the farmost pixel
sdth = s;
N = 3;
for i = 1:N
 sdth = sdth + (-1)^i * nchoosek(N,i) * imrotate(s, dth * i/N, interp, 'crop');
end
sdth = sdth / (2 ^ N);

%% compare similarity with rotated copies of the derivative
% use gradient descent?
theta = -1:0.02:1;
th_sz = length(theta);
p = zeros(th_sz, 2);

sdth_sm = sdth(sm(1):end-sm(1), sm(2):end-sm(2)); 
coeff = dot(sdth_sm(:), sdth_sm(:));
for i = 1:th_sz
    si = imrotate(sdth, theta(i), interp, 'crop');
    %score = dot(si(:), sdth(:));
    si_sm = si(sm(1):end-sm(1), sm(2):end-sm(2)); 
    score = dot(si_sm(:), sdth_sm(:));
    p(i,:) = score / coeff;
end

figure(1);
plot(theta, p);
title(['synthetic blur angle = ' num2str(blur_angle)])