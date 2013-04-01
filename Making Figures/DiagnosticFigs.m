function [ A1, A2, Xs, Ys ] = DiagnosticFigs( MeanName , Shift, TitleText,angle,eps)

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

%Load Means
    subaxis(2,2,1,'Spacing', 0.05, 'Padding', 0.05, 'Margin', .03);
    mean2=0;  %need to intialize or gets confused with a funciton :/
    load(['Vars/Eps' sprintf('%.3f', eps) '/ProcMeansE' MeanName]);
        mean1=imrotate(mean1,angle);
        mean2=imrotate(mean2,angle);
        C1C2=imrotate(C1C2,angle);
        Cov=imrotate(Cov,angle);
    
%Figure out Dimentional Xs and Ys    
    [y x]=size(mean1);
    Xs=(x:-1:1)./Scale+Shift; %shift estimated from Focus 18 img.
    Ys=(y:-1:1)./Scale;

%and where to take slices
    X1=ceil(x/6)+1;
    X2=round(x/2);
    X3=floor(5*x/6)-1;
    Sixth=floor(x/6);
    
%
for i=1:x
    [sigma1(i),mu1(i),A1(i)]=mygaussfit(Ys,mean1(:,i));
    [sigma2(i),mu2(i),A2(i)]=mygaussfit(Ys,mean2(:,i));
end


    %RescaleProcessedImgs(USstart, USstop, 1/USscale1, 1/USscale2)
    %FindMeanE('',USstart, USstop,eps);
   
    %Fit gaussians to mean, use these to find centerpoint and spacing    
    [sigma1,mu1,A1]=mygaussfit(Ys,mean(mean1,2));
    [sigma2,mu2,A2]=mygaussfit(Ys,mean(mean2,2));

    S=abs(mu1-mu2);
    Ys=Ys-(mu1+mu2)/2;

%Plot Means w/ slices
    Img=ColorChangeWhite(mean1,mean2,.5);
    imshow(Img,'XData',Xs,'YData',Ys);
    hold on;axis on;
        plot(Xs(X1)+100.*mean(mean1(:,(X1-Sixth):(X1+Sixth) ),2),Ys,'r-.','LineWidth',1.5);
        plot(Xs(X1)+100.*mean(mean2(:,(X1-Sixth):(X1+Sixth) ),2),Ys,'b-.','LineWidth',1.5);
        plot(Xs(X1),Ys,'k-','LineWidth',.5);

        plot(Xs(X2)+100.*mean(mean1(:,(X2-Sixth):(X2+Sixth) ),2),Ys,'r-.','LineWidth',1.5);
        plot(Xs(X2)+100.*mean(mean2(:,(X2-Sixth):(X2+Sixth) ),2),Ys,'b-.','LineWidth',1.5);
        plot(Xs(X2),Ys,'k-','LineWidth',.5);
        
        plot(Xs(X3)+100.*mean(mean1(:,(X3-Sixth):(X3+Sixth) ),2),Ys,'r-.','LineWidth',1.5);
        plot(Xs(X3)+100.*mean(mean2(:,(X3-Sixth):(X3+Sixth) ),2),Ys,'b-.','LineWidth',1.5);
        plot(Xs(X3),Ys,'k-','LineWidth',.5);
        
        plot(Xs,ones(1,length(Xs))*S/2,'k--','LineWidth',1.5);
        plot(Xs,-ones(1,length(Xs))*S/2,'k--','LineWidth',1.5);
    hold off;
    axis([Xs(length(Xs)) Xs(1) -8 8]);
    title('$\left< C_1 \right>$ and $\left< C_2 \right>$','Interpreter','latex','FontSize',12)

subaxis(2,2,3,'Spacing', 0.05, 'Padding', 0.05, 'Margin', .03);
%load(['Vars/Eps' sprintf('%.3f', eps) '/CovE' MeanName]);

    Mix=Cov./C1C2;
    imagesc(Xs,Ys,Mix);axis image;caxis([-1 1]);
    B(1,:)= [0:1/31:1 ones(1,32)]; B(2,:)= [0:1/31:1 1:-1/31:0]; B(3,:)= [ones(1,32) 1:-1/31:0];
    colormap(B');caxis([-1 1]);freezeColors;cbfreeze(colorbar('location','South'));

    %
    title('$\frac{\left< c_1^\prime c_2^\prime \right>}{\left< C_1  C_2 \right>}$','Interpreter','latex','FontSize',12)

subaxis(2,2,2,'Spacing', 0.05, 'Padding', 0.05, 'Margin', .03);
    Start = str2num( MeanName(1:5) );
    Stop  = str2num( MeanName(7:11) );

    load(['ProcImgs/Proc' sprintf('%05d', round((Stop+Start)/2))]);
        C1=imrotate(C1,angle);
        C2=imrotate(C2,angle);
    Img=ColorChangeWhite(C1,C2,.75);
    imshow(Img,'XData',Xs,'YData',Ys);
    title('$C_1$ and $C_2$','Interpreter','latex','FontSize',12)
    
subaxis(2,2,4,'Spacing', 0.05, 'Padding', 0.05, 'Margin', .03);
   
    imagesc(fliplr(C1.*C2));axis image;colormap(flipud(gray));caxis([0 .05]);colorbar('location','South');
    title('$C_1 C_2$','Interpreter','latex','FontSize',12)
    

%FileName=[MeanName 'Diagnostics.pdf'];
print('-r500','-dpdf',TitleText);

end

