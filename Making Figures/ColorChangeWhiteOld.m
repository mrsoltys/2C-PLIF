function CombImg = ColorChangeWhiteOld(Img1, Img2, Scale)
%-------------------------------------------------------------------------%
%ColorChangeWhite(Img2, Img1, Scale)
%Inputs:
%   Required:
%       Img1 and Img2 are two matricies images with values varying from 0-1.
%
%       Note: If Img1 or Img2 contain out of range values, round using:
%       Img1(Img1>1)=1;Img1(Img1<0)=0
%
%       , values > 1 will
%       be rounded to 1 and values < 0 will be set to 0.
%              
%   Optional:
%       0 < Scale < 1 Enanches colors non-linearly.  
%       Scale > 1 Threshold's values that show Red or Blue, and results in
%       less Purple  This may result in >1 values, which imshow and
%       imwrite will round to 1.
%
%
%Output:
%   CombImg is a single false color Image with  Img2 shown in Red and Img1 shown in Blue.
%
%Testing:
%   To obtain a colormap, use the following code:
%    for i=1:101
%         Red(i,:)=0:.01:1;
%    end
%    Blue=flipud(Red');
%    ColorMapImg=ColorChangeWhite(Red, Blue, Scale)
%    imshow(ColorMapImg);

%Last Update: 10/20/11
%-------------------------------------------------------------------------%

%% If No Scale is inputed, set to default 1
if nargin == 2
    Scale=1;
else
    % Scale
    Img1=Img1.^Scale;
    Img2=Img2.^Scale;
end

 %Red
    CombImg(:,:,1)=1+(Img2-Img1);
 %Blue
    CombImg(:,:,3)=1+(Img1-Img2);
 %Green
    CombImg(:,:,2)=1-max(Img1,Img2);

CombImg=real(CombImg);

CombImg(CombImg>1)=1;
% This is older code. It produces nice looking images but isn't very logical

% CombImg(:,:,1)=((Img1).^2+(1-Img2).^2)./(Img1+1-Img2);
% CombImg(:,:,3)=((Img2).^2+(1-Img1).^2)./(1-Img1+Img2);
% CombImg(:,:,2)=(1-Img1).*(1-Img2);
% CombImg=CombImg;