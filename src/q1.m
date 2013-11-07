img = imread('Beautiful-Green-Nature-With-Birds-Blue-Jay-Bird.jpg');
img = im2double(rgb2gray(img));

blur_angle = 2;

%interp = 'bilinear';
interp = 'bicubic';

r = imrotate(img, blur_angle, interp, 'crop');

s = (img + r) / 2; %todo: synth blur kernel

sz = max(size(img));
dth = atand(2/sz); % creates 1 pixel difference at the farmost pixel
sdth = s - imrotate(s, dth, interp, 'crop');

deriv_order = 1;
dy = diff(s, deriv_order, 1);
dx = diff(s, deriv_order, 2);

%imagesc(r-img);


theta = -4:0.05:4;
%-0.3:0.05:0.3;
th_sz = length(theta);

p = zeros(1, th_sz);
for i = 1:th_sz
    si = imrotate(sdth, theta(i), interp, 'crop');
%{
    xc = xcorr2(si,s);
    figure;
    imagesc(xc);
    colorbar;
    title(['theta' num2str(i)]);
    c = int16(size(xc)/2); %center pixel
    score = xc(c(1), c(2));
%}

    %dyi = diff(si, deriv_order, 1);
    %dxi = diff(si, deriv_order, 2);
    %score = norm(dyi-dy) + norm(dxi-dx);
    score = norm(si-sdth);
    
    p(i) = score;
    
end

figure;
plot(theta, p);


