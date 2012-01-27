%-----BeamDiam.m-----%
% Origionally written by D. Dombroski
% Modified by M. Soltys

% Load images of stationary beam, plot slice (as an average of 10 rows)
% to show gaussian shape, fit a least-squares curve to the data, and 
% determine diameter of beam

function [] = BeamDiam()

beam_def = exp(-1);                                                         %Dan Had e^-1, maybe use e^-2

%% Open Scale
    ScaleImg = imread('PE_Grid.JPG');
    imagesc(ScaleImg), colormap gray, hold on;
    title('Please Click The Corners of Two Squares in the Same Row')
    [x,y] = ginput(2);
    plot(x,y);

%% Establish Scale
    dX=abs(x(1)-x(2));
    dY=abs(y(1)-y(2));
    cms = input('How many cms did the line cover?') ;
    L=sqrt(dX^2+dY^2);
    scale=L/(cms*10); %Pixels/cm

%% Straighten image 
    imagesc(imrotate(ScaleImg,atan(dY/dX)*180/pi()))
            

leftmark = 175;
rightmark = 200;
rows = size(scale,1);
hold on, plot(leftmark,0:0.01:rows,'-k',rightmark,0:0.01:rows,'-k')
scale = (rightmark - leftmark)/5;  % pixels/mm

%% Open Beam Image
    figure;
    subplot(1,2,1);
    BeamImg = imrotate(imread('PE_250.JPG'),atan(dY/dX)*180/pi());
    imagesc(BeamImg), colormap gray;
    title('Beam')
    
%% Fit gaussian to beam cross-section
    Size=size(BeamImg)
    BeamImg=BeamImg(.1*Size(1):.9*Size(1),:)
    Size=size(BeamImg)
    y=1:Size(1);
    num=1500; %number of pixels to average
    ll=round(Size(2)/2-num/2);
    ul=ll+num;
    BeamXC=mean(BeamImg(:,ll:ul),2)
    subplot(1,2,2);
       
    [sigma,mu,Gscale]=mygaussfit(y,BeamXC);
    Gauss=Gscale*exp( -(y-mu).^2 / (2*sigma^2) );  
    plot(Gauss,y,'r');hold on;
    plot(BeamXC,y,'.','MarkerSize',5);hold off;
% Set color scaling limits to full resolution of camera
Clim = [0 1024];

% Open Beam Image
file = 'focus8';
beam = imread([path file],ext);
beam = double(beam);
figure, imagesc(beam), colormap hot, colorbar
mean(mean(beam))

   
    
index = [10 120 230];  % index of where to extract cross-sections
ydim = [1:size(beam,2)];  % establish 'x' axis for plotting
background = 0; % define background for 'tails' of beam profile


% Edges Demarcating Beam Width
beamedge1 = 185.5;
beamedge2 = 195;
width = beamedge2-beamedge1;
fprintf('\nBeam Diameter = %.2f pixels \n\n',width)
width = width/scale;
fprintf('\nBeam Diameter = %.2f mm \n\n',width)


% ------------------------------------------------------------------

% Beam Profile #1 (averaged over 10 pixel rows)
beam_profile = beam(index(1):index(1)+10,:); 
beam_profile = mean(beam_profile,1); % average
[y i] = max(beam_profile);
plotlim = [i-10:0.1:i+10];

figure, gaussfit(beam_profile,background)

axis([beamedge1-10 beamedge2+10 0 1.1*max(beam_profile)])
title('Least-squares Curve Fit of C/C_o = exp(-y^2/2sig^2)')
ylabel('pixel intensity')

hold on, plot(beamedge1,0:0.1:max(beam_profile)/2,'-k',beamedge2,0:0.1:max(beam_profile)/2,'-k') 

% Finding beam Diam
thresh = max(beam_profile)*beam_def;
hold on, plot(plotlim,thresh,'-k')
% [x,y] = polyxpoly(thresh*ones(length(plotlim)),plotlim,CCo,ydim)
% hold on, plot(160,[0:0.01:thresh],166,[0:0.01:thresh])


% Beam Profile #2 (averaged over 10 pixel rows)
beam_profile = beam(index(2):index(2)+10,:); 
beam_profile = mean(beam_profile,1);
[y i] = max(beam_profile);
plotlim = [i-10:0.01:i+10];

figure, gaussfit(beam_profile,background)

axis([beamedge1-10 beamedge2+10 0 1.1*max(beam_profile)])
title('Least-squares Curve Fit of C/C_o = exp(-y^2/2sig^2)')
ylabel('pixel intensity')

% Finding beam Diam 
thresh = max(beam_profile)*beam_def;
hold on, plot(plotlim,thresh,'-k')

hold on, plot(beamedge1,0:0.1:max(beam_profile)/2,'-k',beamedge2,0:0.1:max(beam_profile)/2,'-k')


% Beam Profile #3 (averaged over 10 pixel rows)
beam_profile = beam(index(3)-10:index(3),:); 
beam_profile = mean(beam_profile,1);
[y i] = max(beam_profile);
plotlim = [i-10:0.01:i+10];

figure, gaussfit(beam_profile,background)

axis([beamedge1-10 beamedge2+10 0 1.1*max(beam_profile)])
title('Least-squares Curve Fit of C/C_o = exp(-y^2/2sig^2)')
ylabel('pixel intensity')


% Finding beam Diam
thresh = max(beam_profile)*beam_def;
hold on, plot(plotlim,thresh,'-k')

hold on, plot(beamedge1,0:0.1:max(beam_profile)/2,'-k',beamedge2,0:0.1:max(beam_profile)/2,'-k')



end
