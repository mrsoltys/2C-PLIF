function [ Scale1, Scale2 ] = PlumeResale(Start, Stop , Shift, TitleText, angle, eps)

    if nargin == 3
        angle = 0;
        eps = -Inf;
    elseif nargin == 4
        eps = -Inf;        
    end

%Intilize Figure
    Figure1=figure(1);
    clf(Figure1);
    set(Figure1,'PaperUnits', 'inches', 'PaperSize', [8.5 8.5]);
    set(Figure1,'defaulttextinterpreter','latex')
    load('Vars/PreRunVars.mat','Scale')

    MeanName=[sprintf('%05d', Start(1)) '-' sprintf('%05d', Stop(length(Start)))]

%Load Means
    subaxis(2,2,1,'Spacing', 0.05, 'Padding', 0.05, 'Margin', .03);
    mean2=0;  %need to intialize or gets confused with a funciton :/
    load(['Vars/Eps' sprintf('%.3f', eps) '/ProcMeansE' MeanName]);
        mean1=imrotate(mean1,angle);
        mean2=imrotate(mean2,angle);
    
%Figure out Dimentional Xs and Ys    
    [y x]=size(mean1);
    Xs=(x:-1:1)./Scale+Shift; %shift estimated from Focus 18 img.
    Ys=(y:-1:1)./Scale;

%and where to take slices
    X1=ceil(x/6)+1;
    X2=round(x/2);
    X3=floor(5*x/6)-1;
    Sixth=floor(x/6);

%Run through images taking gaussians
for i=1:x
    [sigma1(i),mu1(i),A1(i)]=mygaussfit(Ys,mean1(:,i));
    [sigma2(i),mu2(i),A2(i)]=mygaussfit(Ys,mean2(:,i));
end

%Fit to A/x^2
Scale1=trimmean(A1.*Xs.^2,20);
Scale2=trimmean(A2.*Xs.^2,20);

RescaleProcessedImgs(Start, Stop, 1/Scale1, 1/Scale2)
FindMeanE('',Start, Stop,eps);