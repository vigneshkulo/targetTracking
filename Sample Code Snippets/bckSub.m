% Application implementing simple background subtraction technique. The
% first frame in the video is the background image (should not have any 
% foreground pixels). Every other frame in the video file is subtracted
% with the background image. The output will have only the portion that
% changes from the background image, which is the moving foreground part.

close all
clear all

% Read input (Video File in our case. Can use live traffic feed also)
src = mmreader('traffic.mj2'); 

% Get number of frames in the video
numFrames = get(src, 'numberOfFrames');

% Define end of loop variable. Loop runs from frame 1 to 20 in our case.
lastFrame = 20;

% Read frame 1 or Background image.
bgImg = read(src,1); 

% Convert from Color Scale (RGB) to Grey Scale. Double gives double
% precision value
bgGrey = double(rgb2gray(bgImg)); 

% Get the height and width of Background Image.
[hImg wImg] = size(bgGrey); 

figure(1);

% Loop starts (lastFrame and numFrames can be used interchangeably)
for i = 1 : lastFrame 
    
    % Read the Foreground Image
    fgImg = read(src,i);
    
    % Convert from Color Scale (RGB) to Grey Scale. 
    fgGrey = double(rgb2gray(fgImg)); 

    % Define Threshold value( higher value more tolerance to noise ).
    Threshold = 20;
    
    % Subtract Foreground from Background image.
    diff = abs(fgGrey - bgGrey);
    
    % Check value of each pixel. If difference > Threshold, the pixel
    % belongs to the foreground image, else it belongs to the background.
    for j = 1 : wImg
        for k = 1 : hImg
            if (diff(k,j) > Threshold)
                Output(k,j) = fgGrey(k,j);
            else
                Output(k,j) = 0;
            end
        end
    end
    
    % Diplay Input image
    subplot(1,2,1) , imshow(fgImg), title ('Source');
    % Display Output image
    subplot(1,2,2) , imshow(Output), title ('Output');
    
    % Gives a pause between each iteration in loop.
    hold off;
    pause (.3);
end