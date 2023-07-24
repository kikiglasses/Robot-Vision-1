        %% Question 3.1

I = imread('Part 3/Dice.jpg');

I = im2double(im2gray(I));

edges = {};
edges{end+1} = edge(I,'Sobel');
edges{end+1} = edge(I,'Prewitt');
edges{end+1} = edge(I,'Roberts');
edges{end+1} = edge(I,'log');
edges{end+1} = edge(I,'Canny');

% Show original image and the calculated edges
figure;
montage(edges,'size',[1,5], 'ThumbnailSize',[Inf,Inf]);

    %% Canny is best edge detector in this example

BW = edge(I,'Canny');

% Diameter appears to be roughly 10-12 in the image
r_min = 3;
r_max = 8;
% Use built-in imfindcircles function to do circular Hough transform
[centers,radii] = imfindcircles(I, [r_min, r_max],'ObjectPolarity', 'dark', 'Sensitivity', 0.9);

% Remove edges from BW that correlate to the circles
for center = centers'
    for a = -6:6
        for b = -6:6
            BW(round(center(2)+a),round(center(1)+b)) = 0;
        end
    end
end

% Calculate the Hough Transform
[H,theta,rho] = hough(BW);

    %% Hough Transform: Will will use the the built in function
% Calculate Hough Peaks (number of votes per line as in Lecture

P  = houghpeaks(H,100,'threshold',ceil(0.3*max(H(:))), 'NHoodsize', [33,9]);
x = theta(P(:,2));
y = rho(P(:,1));

% show the Hough Map and the identified peaks (features)
figure;
imshow(H,[],'XData',theta,'YData',rho,'InitialMagnification','fit');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
title('Hough Transform');
plot(x,y,'s','color','red', 'markersize', 20);

    %% Now we will find the lines
% Find lines and plot them
lines = houghlines(BW,theta,rho,P,'FillGap',5,'MinLength',15);

figure;
imshow(I);
hold on
viscircles(centers, radii,'Color','r','LineWidth',4);
max_len = 0;
for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1),xy(:,2),'LineWidth',5,'Color','green');

    % plot beginnings and ends of lines
    plot(xy(1,1),xy(1,2),'x','LineWidth',4,'Color','yellow');
    plot(xy(2,1),xy(2,2),'x','LineWidth',4,'Color','red');
end

