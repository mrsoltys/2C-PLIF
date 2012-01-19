function [TFORM1 TFORM2 Cs Scale]=ImgNorm()
%-------------------------------------------------------------------------%
%ImgNorm.m
%Last Update: 12/12/11

% Note: Needs the Image Proccessing Toolbox installed.
% Also needs the Calibration Toolbox for Matlab, available at: 
% http://www.vision.caltech.edu/bouguetj/calib_doc/

% Loads focus images (you tell it the file name), uses grid to create image
% calibration.  Must select exact same 4 points on each calibration image. 

% Returns the corners of the overlaping orthorectivied image (Cs), the
% scale of the image (Scale) in pixels/cm and Transformaiton matricies for
% both images (TFORM1) and (TFORM2)

%-------------------------------------------------------------------------%
data_calib      %Loads Calibration Images
disp('Please start in Lower Left corner and work in a Counter Clockwise Direction');
click_calib     %Gets Gridpoints
%go_calib_optim  %Run Calibration to find Extrensic and Intrestic parameters

%% Find scale for each image
[ans length]=size(x_1);
%Find each image's scale (in pixels/cm)
scale1=sqrt( (x_1(1,1)-x_1(1,length))^2+(x_1(2,1)-x_1(2,length))^2 ) / sqrt( n_sq_x^2+n_sq_y^2);
scale2=sqrt( (x_2(1,1)-x_2(1,length))^2+(x_2(2,1)-x_2(2,length))^2 ) / sqrt( n_sq_x^2+n_sq_y^2);

Scale   = max([scale1 scale2]);
XScale=Scale*n_sq_x
YScale=Scale*n_sq_y

BasePts=zeros(2,0);
for i=0:n_sq_y
    clearvars TempBasePts
    TempBasePts(1,:)=[BasePts(1,:) 0:Scale:XScale];
    TempBasePts(2,:)=[BasePts(2,:) ones(1,n_sq_x+1)*i*Scale];
    BasePts=TempBasePts;
end

%Note here:  Sometimes a transformation greater than a second order
%polynomial will cause abnormal transfmoration if the grid doesn't fill the
%whole image (espically bad for zoomed out images)

TFORM1 = cp2tform(x_1',BasePts', 'polynomial',2);  
TFORM2 = cp2tform(x_2',BasePts', 'polynomial',2);  

Cs1=FindCorners(TFORM1,size(I_1));
Cs2=FindCorners(TFORM2,size(I_2));
Cs(1)=max([Cs1(1) Cs2(1)]);
Cs(2)=min([Cs1(2) Cs2(2)]);
Cs(3)=max([Cs1(3) Cs2(3)]);
Cs(4)=min([Cs1(4) Cs2(4)]);



