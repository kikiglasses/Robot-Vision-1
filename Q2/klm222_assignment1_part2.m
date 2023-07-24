        %% Question 2.1

oldhouse = im2double(im2gray(imread("Part 2\Old_house.jpg")));
butterfly = im2double(im2gray(imread("Part 2\Butterfly.jpg")));

figure;
subplot(1,2,1);
imshow(convolve(oldhouse, Gaus(15,0,5)));
subplot(1,2,2);
imshow(convolve(butterfly, Gaus(15,0,5)));

        %% Question 2.2
oldhouse = im2double(im2gray(imread("Part 2\Old_house.jpg")));
butterfly = im2double(im2gray(imread("Part 2\Butterfly.jpg")));

mean_filter = ones(15)/225;

figure;
subplot(1,2,1);
imshow(convolve(oldhouse, mean_filter));
subplot(1,2,2);
imshow(convolve(butterfly, mean_filter));

        %% Question 2.3
oldhouse = im2double(im2gray(imread("Part 2\Old_house.jpg")));
butterfly = im2double(im2gray(imread("Part 2\Butterfly.jpg")));

figure;
subplot(1,2,1);
imshow(simpleMedian(oldhouse,12,12));
subplot(1,2,2);
imshow(simpleMedian(butterfly,12,12));


        %% Question 2.4

butterfly = im2double(im2gray(imread("Part 2\Butterfly.jpg")));

gn =  imnoise(butterfly, 'gaussian', 0.1, 0.2);
sp = imnoise(butterfly, 'salt & pepper', 0.09);

mean_filter = ones(15)/225;

figure;
subplot(2,4,1);
imshow(sp)
title('S&P Corrupted Image')
subplot(2,4,2);
imshow(convolve(sp,Gaus(15,0,5)))
title('Gaussian Filter on S&P noise')
subplot(2,4,3);
imshow(convolve(sp,mean_filter))
title('Mean Filter on S&P noise')
subplot(2,4,4);
imshow(simpleMedian(sp,12,12));
title('Median Filter on S&P noise')

subplot(2,4,5);
imshow(gn)
title('Gaussian Corrupted Image')
subplot(2,4,6);
imshow(convolve(gn,Gaus(15,0,5)))
title('Gaussian Filter on Gaussian noise')
subplot(2,4,7);
imshow(convolve(gn,mean_filter))
title('Mean Filter on Gaussian noise')
subplot(2,4,8);
imshow(simpleMedian(gn,12,12));
title('Median Filter on Gaussian noise')

        %% convolve Function

function I2 = convolve(I,F)
Fw = size(F,1);
Fh = size(F,2);
Iw = size(I,1)-1+mod(Fw,2);
Ih = size(I,2)-1+mod(Fh,2);

padded = mypad(I,size(F));
% The resultant image loses 1 pixel in each direction that the filter has
% even length in
I2 = zeros(  size(I,1)-1+mod(Fw,2),  size(I,2)-1+mod(Fw,2)   );

for a = 1:Iw         % Rows
    for b = 1:Ih     % Columns
        for c = 1:Fw
            for d = 1:Fh
                I2(a,b) = I2(a,b) + padded(a+c-1, b+d-1)*F(c,d);
            end
        end

    end
end
end

        %% simpleMedian Function

function I2 = simpleMedian(I, Fw, Fh)
Iw = size(I,1)-1+mod(Fw,2);
Ih = size(I,2)-1+mod(Fh,2);

padded = mypad(I,[Fw,Fh]);
% The resultant image loses 1 pixel in each direction that the filter has
% even length in
I2 = zeros(  size(I,1)-1+mod(Fw,2),  size(I,2)-1+mod(Fw,2)   );

for a = 1:Iw         % Rows
    for b = 1:Ih     % Columns
        list = [];
        for c = 1:Fw
            for d = 1:Fh
                list(end+1) = padded(a+c-1, b+d-1);
            end
        end
        I2(a,b) = median(list);
    end
end
end

        %% Utility Functions

function m = mypad(img, dim)

width_radius = ceil(dim(1)/2) - 1;
height_radius = ceil(dim(2)/2) - 1;

m = padarray(img, [width_radius, height_radius], 0);
end

function m = Gaus(size, m1, s1)
% Create a vector to spread the gaussian over the right size
x = -(size-1)/2 : 1 : (size-1)/2;
% Calculate the PDFs
p1 = 1/(s1 * sqrt(2* pi)) * exp(-(x-m1).^2/(2*s1^2));
% Create Gaussian kernels from the PDFs
m = p1'*p1;
end