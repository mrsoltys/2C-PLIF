function [rNew cNew]=PxlRotate(r,c,Size,ang)
%--------------------------------------------------------------------------------%
% PxlRotate(r,c,Size,ang)
% Finds new pixel locations in an image using imrotate. Must use method
% crop for this to be accurate.
%--------------------------------------------------------------------------------%
Rcent=Size(1)/2;
Ccent=Size(2)/2;
x=c-Ccent;
y=r-Rcent;

r=sqrt(x^2+y^2);
theta=atan2(y,x);

thetaNew=theta-ang*pi()/180;

xNew=r*cos(thetaNew);
yNew=r*sin(thetaNew);

rNew=yNew+Rcent;
cNew=xNew+Ccent;
end
