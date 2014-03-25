function [ A1, A2, Xs, Ys ] = MeanFigsP( MeanName , S, Shift, TitleText, FileName,eps,S1,S2)

%Intilize Figure
    Figure1=figure(1);
    clf(Figure1);
set(Figure1,'defaulttextinterpreter','latex','PaperUnits','inches','PaperSize',[11 8.5],'PaperPosition',[.5,.5,11,8.5]);
    load('Vars/PreRunVars.mat','Scale')

%First Plot: Means
subaxis(2,2,1)
mean2=0;  %need to intialize or gets confused with a funciton :/
load(['Vars/Eps' sprintf('%.3f', eps) '/ProcMeansE' MeanName]);
    mean1=fliplr(mean1');mean2=fliplr(mean2');
    RMSE1=fliplr(RMSE1');RMSE2=fliplr(RMSE2');
    C1C2=fliplr(C1C2');Cov=fliplr(Cov');
    [y x]=size(mean1);
    
    Xs=(x:-1:1)./Scale+Shift; %shift estimated from Focus 18 img.
    Ys=(y:-1:1)./Scale;
    
    X1=ceil(x/6)+1;
    X2=round(x/2);
    X3=floor(5*x/6)-1;
    Sixth=floor(x/6);
    
    for i=1:x
        [sigma1(i),Mu1(i),A1(i)]=mygaussfit(Ys ,mean1(:,i));
        [sigma2(i),Mu2(i),A2(i)]=mygaussfit(Ys ,mean2(:,i));
    end
    
        %[sigma1,mu1,S1]=mygaussfit(Ys,mean(mean1,2));
        %[sigma2,mu2,S2]=mygaussfit(Ys,mean(mean2,2));
    if nargin == 6
        S1=trimmean((1./(Xs.*A1)),10);
        S2=trimmean((1./(Xs.*A2)),10);
        title('$\frac{\left< C_1 \right>}{\left< C_1 \right>_C}$ and $\frac{\left< C_2 \right>}{\left< C_2 \right>_C}$','Interpreter','latex','FontSize',12)
    else
        title('$\left< C_1 \right>$ and $\left< C_2 \right>$','Interpreter','latex','FontSize',12)
    end
    %mean1=mean1/A1;
    %mean2=mean2/A2;
    
    Mu1(isnan(Mu1))=0;
    Mu2(isnan(Mu2))=0;
    Ys=Ys-trimmean((Mu1+Mu2)/2,10);
    EXP=.5
    Img=ColorChangeWhite(mean1.*S1,mean2.*S2,EXP);
    imshow(Img,'XData',Xs,'YData',Ys);
    hold on;axis on;
        plot(Xs(X1)+10^(1/EXP).*mean(mean1(:,(X1-Sixth):(X1+Sixth) ).*S1,2),Ys,'r-.','LineWidth',1.5);
        plot(Xs(X1)+10^(1/EXP).*mean(mean2(:,(X1-Sixth):(X1+Sixth) ).*S2,2),Ys,'b-.','LineWidth',1.5);

        plot(Xs(X2)+10^(1/EXP).*mean(mean1(:,(X2-Sixth):(X2+Sixth) ).*S1,2),Ys,'r-.','LineWidth',1.5);
        plot(Xs(X2)+10^(1/EXP).*mean(mean2(:,(X2-Sixth):(X2+Sixth) ).*S2,2),Ys,'b-.','LineWidth',1.5);

        plot(Xs(X3)+10^(1/EXP).*mean(mean1(:,(X3-Sixth):(X3+Sixth)).*S1 ,2),Ys,'r-.','LineWidth',1.5);
        plot(Xs(X3)+10^(1/EXP).*mean(mean2(:,(X3-Sixth):(X3+Sixth)).*S2 ,2),Ys,'b-.','LineWidth',1.5);
        
        plot(Xs,ones(1,length(Xs))*S/2,'k--','LineWidth',1.5);
        plot(Xs,-ones(1,length(Xs))*S/2,'k--','LineWidth',1.5);
    hold off;
    set(gca,'YDir', 'normal');axis([Xs(length(Xs)) Xs(1) -8 8]);
 

    Mean1P=mean(mean1.*S1,2);
    Mean2P=mean(mean2.*S2,2);
%
subaxis(2,2,2)
%load(['Vars/Eps' sprintf('%.3f', eps) '/RMSEe' MeanName]);
    
    Img=ColorChangeWhite(RMSE1.*S1,RMSE2.*S2,EXP);
    imshow(Img,'XData',Xs,'YData',Ys);
    hold on;axis on;
        plot(Xs(X1)+10^(1/EXP)/10.*mean(RMSE1(:,(X1-Sixth):(X1+Sixth) ).*S1,2),Ys,'r-.','LineWidth',1.5);
        plot(Xs(X1)+10^(1/EXP)/10.*mean(RMSE2(:,(X1-Sixth):(X1+Sixth) ).*S2,2),Ys,'b-.','LineWidth',1.5);

        plot(Xs(X2)+10^(1/EXP)/10.*mean(RMSE1(:,(X2-Sixth):(X2+Sixth) ).*S1,2),Ys,'r-.','LineWidth',1.5);
        plot(Xs(X2)+10^(1/EXP)/10.*mean(RMSE2(:,(X2-Sixth):(X2+Sixth) ).*S2,2),Ys,'b-.','LineWidth',1.5);

        plot(Xs(X3)+10^(1/EXP)/10.*mean(RMSE1(:,(X3-Sixth):(X3+Sixth) ).*S1,2),Ys,'r-.','LineWidth',1.5);
        plot(Xs(X3)+10^(1/EXP)/10.*mean(RMSE2(:,(X3-Sixth):(X3+Sixth) ).*S2,2),Ys,'b-.','LineWidth',1.5);
    hold off;
    set(gca,'YDir', 'normal');axis([Xs(length(Xs)) Xs(1) -8 8]);
    title('$\frac{\sigma_1}{\left< C_1 \right>_C}$ and $\frac{\sigma_2}{\left< C_2 \right>_C}$','Interpreter','latex','FontSize',12)

    RMSE1P=mean(RMSE1.*S1,2);
    RMSE2P=mean(RMSE2.*S2,2);
%
subaxis(2,2,3)
%load(['Vars/Eps' sprintf('%.3f', eps) '/CovE' MeanName]);
%    C1C2=fliplr(C1C2')/(A1*A2);
%    Cov=fliplr(Cov')/(A1*A2);
    %Rounds max up to nearest order of magnitude.
    Cmax=10^(ceil( log10( max(C1C2(:))*S1*S2 )));
    imagesc(Xs,Ys,C1C2.*S1.*S2);caxis([0 Cmax])
    set(gca,'YDir', 'normal');axis([Xs(length(Xs)) Xs(1) -8 8]);
    colormap(flipud(gray));
    cbfreeze(colorbar('location','South',...
             'YTick',...
             [0,Cmax/2,Cmax],...
             'YTickLabel',...
            {0,Cmax/2,Cmax }));
    freezeColors;
    hold on;
        plot(Xs(X1)+10/Cmax.*mean(C1C2(:,(X1-Sixth):(X1+Sixth) ),2),Ys,'k-.','LineWidth',1.5);

        plot(Xs(X2)+10/Cmax.*mean(C1C2(:,(X2-Sixth):(X2+Sixth) ),2),Ys,'k-.','LineWidth',1.5);

        plot(Xs(X3)+10/Cmax.*mean(C1C2(:,(X3-Sixth):(X3+Sixth) ),2),Ys,'k-.','LineWidth',1.5);
    hold off;
    
    
    title('$\left< C_1 C_2 \right>$','Interpreter','latex','FontSize',12)
    
    C1C2P=mean(C1C2*S1*S2,2);
    CovP=mean(Cov*S1*S2,2);
    
subaxis(2,2,4);
    Rho=real(Cov./(RMSE1.*RMSE2));
    Rho(isinf(Rho))=0;
    Rho(isnan(Rho))=0;
    imagesc(Xs,Ys,Rho);
        set(gca,'YDir', 'normal');axis([Xs(length(Xs)) Xs(1) -8 8]);

        colormap(HotCold(-1,1));caxis([-1 1]);colorbar('location','South')
    hold on;axis image;
        plot(Xs(X1)+10.*mean(Rho(:,(X1-Sixth):(X1+Sixth) ),2),Ys,'k-.','LineWidth',1.5);

        plot(Xs(X2)+10.*mean(Rho(:,(X2-Sixth):(X2+Sixth) ),2),Ys,'k-.','LineWidth',1.5);

        plot(Xs(X3)+10.*mean(Rho(:,(X3-Sixth):(X3+Sixth) ),2),Ys,'k-.','LineWidth',1.5);
    hold off;

    title('$\rho=\frac{\left< c_1^\prime c_2^\prime \right>}{\sigma_1 \sigma_2}$','Interpreter','latex','FontSize',12)

annotation(Figure1,'textbox',...
    [0 0.8 1 0.2],...
    'String',{TitleText},...
    'FitBoxToText','off',...
    'LineWidth',0,'EdgeColor','none',...
    'Interpreter','latex','FontSize',18,...
    'HorizontalAlignment','center');

FileName=[FileName 'Means.tif'];
print('-r500','-dtiff',FileName);

A1=S1;A2=S2;

save('Vars/MeanPlots','Mean1P','Mean2P','RMSE1P','RMSE2P','CovP','C1C2P','Xs','Ys','S1','S2');
end

