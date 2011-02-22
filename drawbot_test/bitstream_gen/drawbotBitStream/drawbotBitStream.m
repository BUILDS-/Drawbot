function drawbotBitStream
% FUNCTION: drawbotBitStream
%       - BUILDS DRAWBOT IMAGE GENERATOR: Convert Standardized Images to
%                                         Arduino string format
%               By: SAMIR AHMED
%                   JEFF CROWELL
%       FEBRUARY 20th 2011
%       
%       MUST HAVE IMAGE FILE IN THE SAME CURRENT DIRECTORY
%       SAVES FILE TO CURRENT DIRECTORY as "drawbot1.txt"


clear all
close all
clc
disp('Drawbot Bitstream Generator')
disp('By Samir Ahmed and Jeff Crowell')
disp('-----------------------------------')
disp('Select File From Current Directory')

I=uigetfile({'*.jpg;*.png;*.gif','All Image Files'},'BUILDS DrawBot: Select an Image');
I=imread(I);

disp('File Opened')

mainFig=figure(1);
set(mainFig,'NumberTitle','off','Name','BUILDS DRAWBOT: IMAGE PREVIEW');
imshow(I);

disp('Opening Threshold Selector Window')
threshold=uiImageSelect(I);

disp('>>Converting To Black And White')
J=im2bw(I,threshold);
disp('>>Converting To Cascaded Image')
J=bwcascade(J);
disp('>>Converting To Square Image')
J=imcenter(J);

mainFig=figure(2);
set(mainFig,'NumberTitle','off','Name','BUILDS DRAWBOT: EXPORT PREVIEW');
imshow(J);

disp('>>Creating Export String')
exportStr=cascadeStr(J);
disp('>>Generating Transfer .txt File')
generateTransfer(exportStr);
end

function generateTransfer(exportStr)
% Simple Function for exporting the transfer File

    fid=fopen('drawbot1.txt','w');
    if fid ~= -1
        disp('File "drawbot1.txt"')
        fprintf(fid,'%s',exportStr);
        closeresult = fclose(fid);
        if closeresult==0
            disp('File Sucessfully Saved To Current Directory')
        else
            disp('ERROR: Could Not Generate Transfer File')
        end
    else
        disp('ERROR: Could Not Generate Transfer File')
    end
end
        
function grayThreshold=uiImageSelect(I)
    % This functions takes in a image, subplots various options
    % Allows a user to select the bw image of his or her choice

    screenSize=get(0,'MonitorPositions');
    screenSize=[.02*screenSize(3) 0.05*screenSize(4) 0.95*screenSize(3) 0.85*screenSize(4)];
    sub=figure(2);
    set(sub,'Position',screenSize,...
        'NumberTitle','off',...
        'Name','BUILDS DRAWBOT: Gray Threshold Select Screen');

    counter = 1;
    for ii=0:.1:1
        subplot(1,11,counter)
        J = im2bw(I,ii);
        imshow(J);
        title(ii);
        counter=counter+1;
    end

    choicestr=sprintf('Exactly Enter Desired Threshold \n(OR enter -1 for smaller division): ');
    choice = input(choicestr);
    while (choice<0)
        smaller= input(' Select A Starting Point for Smaller Increments: ');

        figure(2);

        counter=1;
        for ii=smaller:.01:smaller+.1
            subplot(1,11,counter)
            J = im2bw(I,ii);
            imshow(J);
            title(ii);
            counter=counter+1;
        end

        choice = input(choicestr);
    end

    grayThreshold=choice;
    close(sub);
end

function imageout=imcenter(J)
    % Image Center takes in an image of any dimensions and returns a square
    % image with the dimensions of the longer side squared. The image is
    % padded with white spaces

    [r c]=size(J);

    if r ~= c
        if r>c
            longer=r;
            shorter = c;
        else
            longer =c;
            shorter = r;
        end

        padlength = floor((longer-shorter)/2);
        padlength2 = longer - shorter -padlength ;

        if r>c
            pad=ones(r,padlength);
            pad2=ones(r,padlength2);
            J=[pad J pad2];
        else
            pad=ones(padlength,c);
            pad2=ones(padlength2,c);
            J=[pad; J; pad2];
        end
    end
    imageout=J;
end

function cascadedImage=bwcascade(J)
    % BlackWhiteCascade is a function that takes in a black in white image
    % MATLAB will cascade the rows so that it a matrix
    %    1 2 3               1 2 3
    %    4 5 6  will become  6 5 4
    %    7 8 9               7 8 9
    %
    % INPUT ARGUMENTS - J ( b/w image)
    % OUTPUT ARGUMENTS - cascadedimage (the image altered with cascade)

    % I dont bother to preallocate for such a small vector
    supervec = [];
    [r c]= size(J);

    for ii=1:r
        vec= J(ii,:);
        if mod(ii,2)==1
            % To create the cascade we horizontally flip every other row
            vec=fliplr(vec);
        end
        supervec=[supervec vec];
    end
    % Now we reshape to get it back to the original size
    cascadedImage=rot90(reshape(supervec,c,r),-1);

end

function outStr= cascadeStr(J)
    % This function takes the image (J) and converts it to a string of 1's and 0's
    % This is to be exported for us in JEFF CROWELL's arduino code;
    J=not(J);
    [r c]=size(J);

    superString=blanks(r*c);
    counter=1;
    for ii=1:r
        for jj=1:c
            superString(counter)=sprintf('%d',J(ii,jj));
            counter=counter+1;
        end
    end

    outStr=superString;
end