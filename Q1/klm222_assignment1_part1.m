        %% Question 1.1

% Load Malards.jpg as 3 matrices
malards = imread("Part 1\Malards.jpg");

% Isolate red channel
malards_red = malards(:,:,1);

load roberts

malards_robA = conv2(malards_red,robertsA,'valid');
malards_robB = conv2(malards_red,robertsB,'valid');

% Apply Euclidean norm to combine two images
malards_rob = L2(malards_robA, malards_robB);

figure;
subplot(1,3,1);
imshow(abs(malards_robA)>50);

subplot(1,3,2);
imshow(abs(malards_robB)>50);

subplot(1,3,3);
imshow(abs(malards_rob)>50);


        %% Question 1.2
% Load Malards.jpg as 3 matrices
malards = imread("Part 1\Malards.jpg");
malards_gray = im2gray(malards);

A = [
        [0,-1,-1,-1,-1,0];
        [-1,-2,-3,-3,-2,-1];
        [-1,-3,12,12,-3,-1];
        [-1,-3,12,12,-3,-1];
        [-1,-2,-3,-3,-2,-1];
        [0,-1,-1,-1,-1,0];
    ];
malards_A = conv2(malards_gray,A,'valid');

B = [
        [1,1,1,1,1,1,];
        [-1,-2,-3,-3,-2,-1];
        [-1,-3,-4,-4,-3,-1];
        [1,3,4,4,3,1];
        [1,2,3,3,2,1];
        [-1,-1,-1,-1,-1,-1];
    ];
malards_B = conv2(malards_gray,B,'valid');

    
figure;
subplot(1,2,1)
imshow(malards_A);

subplot(1,2,2)
imshow(malards_B);


        %% Question 1.3

earth = imread("Part 1\Earth.jpg");

earth_gray = im2double(im2gray(earth));

DoG = DiffGaus(15, 0, 1, 0, 2*sqrt(2) );

earth_DoG = zero_one(conv2(earth_gray,DoG,'valid'));

figure;
imshow(earth_DoG);

        %% Question 1.4

earth = imread("Part 1\Earth.jpg");
earth_gray = im2double(im2gray(earth));

num = 8;
start = 0;
stop = 4;
filter_size = 65;

Gs = {earth_gray};
DoGs = {};

for k = start:(stop-start)/num:stop
    Gs{end+1} = zero_one(conv2(pad_resize(earth_gray,2^(-k), filter_size), Gaus(filter_size, 0, 2^(k) ), 'valid'));
    DoGs{end+1} = zero_one(conv2(pad_resize(earth_gray,2^(-k), filter_size), DiffGaus(filter_size, 0, 2^(k-(stop-start)/num), 0, 2^(k) ), 'valid'));
end

figure;
montage(Gs, 'size',[1,num+1], 'ThumbnailSize',[Inf,Inf]);
figure;
montage(DoGs, 'size',[1,num], 'ThumbnailSize',[Inf,Inf]);


        %% DiffGaus Function

function m = DiffGaus(size, m1, s1, m2, s2)

% Always take the larger s.d. Gaussian from the smaller s.d. Gaussian
if s1 > s2
    temps = s1;
    s1 = s2;
    s2 = temps;
    tempm = m1;
    m1 = m2;
    m2 = tempm;
end

% Create a vector to spread the gaussian over the right size
x = -(size-1)/2 : 1 : (size-1)/2;

    % Calculate the PDFs
% If the s.d. is less than 1, give identity kernel
if s1 < 1
    p1 = zeros(1,size);
    if mod(size, 2) == 0
        p1(size/2) = 0.5;
        p1((size/2) +1) = 0.5;
    else
        p1((size+1)/2) = 1;
    end
else
    p1 = 1/(s1 * sqrt(2* pi)) * exp(-(x-m1).^2/(2*s1^2));
end
p2 = 1/(s2 * sqrt(2* pi)) * exp(-(x-m2).^2/(2*s2^2));

% Create Gaussian kernels from the PDFs
G1 = p1'*p1;
G2 = p2'*p2;

% Take the differences of the kernels to get the DoG kernel
m = G1 - G2;
end


        %% Utility Functions

function m = pad_resize(img, scale, f_sz)
m = imresize(img, scale);
m = padarray(m, [ceil(   (f_sz-1)/2), ceil(   (f_sz-1)/2)], 0);
end

function m = zero_one(img)
% Set the minimum value of the image to 0, and the maximum value to 1
% while retaining distance
m = (img-min(min(img))) / (max(max(img)) - min(min(img)));
end


function m = Gaus(size, m1, s1)
% Create a vector to spread the gaussian over the right size
x = -(size-1)/2 : 1 : (size-1)/2;
% Calculate the PDFs
p1 = 1/(s1 * sqrt(2* pi)) * exp(-(x-m1).^2/(2*s1^2));
% Create Gaussian kernels from the PDFs
m = p1'*p1;
end

function m = L2(x,y)
m = abs(x) + abs(y);
end

