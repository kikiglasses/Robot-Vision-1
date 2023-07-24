        %% Question 4.1

I = im2double(im2gray(imread("Part 4\Uob_University_Square.jpg")));


figure;


subplot(2,3,1);
hold on;
imshow(I);
points = detectMinEigenFeatures(I);
plot(points.selectStrongest(100));
title("Minimum Eigenvalue");


subplot(2,3,2);
hold on;
imshow(I);
points = detectSURFFeatures(I);
plot(points.selectStrongest(100));
title("SURF");


subplot(2,3,3);
hold on;
imshow(I);
points = detectKAZEFeatures(I);
plot(points.selectStrongest(100));
title("KAZE");


subplot(2,3,4);
hold on;
imshow(I);
points = detectFASTFeatures(I);
plot(points.selectStrongest(100));
title("FAST");


subplot(2,3,5);
hold on;
imshow(I);
points = detectORBFeatures(I);
plot(points.selectStrongest(100));
title("ORB");


subplot(2,3,6);
hold on;
imshow(I);
points = detectHarrisFeatures(I);
plot(points.selectStrongest(100));
title("Harris-Stephens");

