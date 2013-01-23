%% STEP 1: Merge Mean Figs
% Load US stats
function JPDF2(USstart, USstop, DSstart,DSstop, eps, Expon, TitleTxt)
   
%   
set(0,'defaulttextinterpreter','latex')
NAME=TitleTxt
load(['Vars/Eps' sprintf('%.3f', eps) '/VOetc' NAME],'VO','S','USycent','DSycent','Yshift','USXData','USYData','DSXData','DSYData','CLshift','Ang1','Ang2');
% Load US stuff
    mean2=[];
    Ang1=0;Ang2=0;

    USMeanName=[ sprintf('%05d', USstart) '-'  sprintf('%05d', USstop)];
        load(['Vars/Eps' sprintf('%.3f', eps) '/ProcMeansE' USMeanName]);
            USmean1=mean1;USmean2=mean2;
            [USr USc]=size(mean1);
        load(['Vars/Eps' sprintf('%.3f', eps) '/CovE' USMeanName]);
            USC1C2=C1C2;USCov=Cov;
        load(['Vars/Eps' sprintf('%.3f', eps) '/RMSEe' USMeanName]);
            USRMSE1=RMSE1;USRMSE2=RMSE2;
            
% Load DS stats;
    DSMeanName=[ sprintf('%05d', DSstart) '-'  sprintf('%05d', DSstop)];
        load(['Vars/Eps' sprintf('%.3f', eps) '/ProcMeansE' DSMeanName]);
            DSmean1=mean1;DSmean2=mean2;
            [DSr DSc]=size(mean1);
        load(['Vars/Eps' sprintf('%.3f', eps) '/CovE' DSMeanName]);
            DSC1C2=C1C2;DSCov=Cov;
        load(['Vars/Eps' sprintf('%.3f', eps) '/RMSEe' DSMeanName]);
            DSRMSE1=RMSE1;DSRMSE2=RMSE2;

% Plot Means and <C1C2> with boxes at PDF location
    Figure1=figure(1);

    clf;

    subaxis(2,1,1,'Spacing', 0.02, 'Padding', 0.000, 'Margin', .02);
        hold on;
        imshow(ColorChangeWhite(DSmean1,DSmean2,.5),'XData',DSXData,'YData',DSYData);
        imshow(ColorChangeWhite(USmean1,USmean2,.5),'XData',USXData,'YData',USYData);
        set(gca,'YDir','normal');
        %axis([Xshift-DSc USc 1 DSr]);
        XMAX=floor(max(abs(DSXData)))
        YMAX=floor(min(abs(USYData)))
        axis image;axis([0 XMAX -YMAX YMAX]);
        title('$<C_1 >$ and $<C_2 >$')
        xlabel('$X/S$');
        ylabel('$Y/S$');hold off;
    subaxis(2,1,2,'Spacing', 0.02, 'Padding', 0.000, 'Margin', .02);
        hold on;
        imagesc(DSC1C2,'XData',DSXData,'YData',DSYData);
        imagesc(USC1C2,'XData',USXData,'YData',USYData);
        %axis([Xshift-DSc USc 1 DSr]);
        axis image;set(gca,'YDir','normal');axis([0 XMAX -YMAX YMAX]);
        colormap(flipud(gray));caxis([0 .01]);freezeColors;cbfreeze(colorbar('location','South'));
        title('$<C_1 C_2>$')
        xlabel('$X/S$');
        ylabel('$Y/S$');hold off;
        
        %(USmean1.*USmean2),'XData',USXData,'YData',USYData);
        
        
% % Instant Image
%  load('/Volumes/Flagstaff/TwoJet/041511/ProcImgs/Proc01500.mat');
%  USC1=C1;USC2=C2;
%  load('/Volumes/Flagstaff/TwoJet/041511/ProcImgs/Proc03000.mat');
%  DSC1=C1;DSC2=C2;
%  Fig2=figure(2);
% 
%     set(Fig2,'PaperUnits','inches','PaperSize',[16 10],'PaperPosition',[.5,.5,15,9]);clf;
% 
%         iptsetpref('ImshowAxesVisible','on');
%          imshow(ColorChangeWhite(DSC1,DSC2,.8),'XData',DSXData,'YData',DSYData);hold on;
%          imshow(ColorChangeWhite(USC1,USC2,.8),'XData',USXData,'YData',USYData);
%          plot([max(USXData) max(USXData)],[-YMAX YMAX],'k-','LineWidth',2);
%          hold off;
%          axis image;set(gca,'YDir','normal');axis([0 XMAX -YMAX YMAX]);
%          title({'$C_1 $ and $C_2$';''})
%          xlabel('$X/S$');
%          ylabel('$Y/S$');
%              set(findall(Fig2,'type','text'),'FontSize',16)
%              
% print('-dpdf','-r500',['Vars/Eps' sprintf('%.3f', eps) '/' TitleTxt '_Instant.pdf'])         
% %means;
% Fig2;clf;
%         
%         imshow(ColorChangeWhite(DSmean1,DSmean2,.8),'XData',DSXData,'YData',DSYData);hold on;
%         imshow(ColorChangeWhite(USmean1,USmean2,.8),'XData',USXData,'YData',USYData);hold off;
%         axis image;set(gca,'YDir','normal');axis([0 XMAX -YMAX YMAX]);
%         title({'$<C_1 >$ and $<C_2 >$';''})
%         xlabel('$X/S$');
%         ylabel('$Y/S$');hold off;
%         set(findall(Fig2,'type','text'),'FontSize',16)
%   print('-dpdf','-r500',['Vars/Eps' sprintf('%.3f', eps) '/' TitleTxt '_Means.pdf'])  
% % inst rxn
% Fig2;clf;
% imagesc(DSC1.*DSC2.*(DSC1>0.0099).*(DSC2>0.0099),'XData',DSXData,'YData',DSYData);hold on;
% imagesc(USC1.*USC2.*(USC1>0.0099).*(USC2>0.0099),'XData',USXData,'YData',USYData);
% plot([max(USXData) max(USXData)],[-YMAX YMAX],'k-','LineWidth',2);hold off;
% axis image;set(gca,'YDir','normal');axis([0 XMAX -YMAX YMAX]);
% colormap(flipud(gray));caxis([0 0.05])
%  title({'$C_1 \times C_2 $';''})
%         xlabel('$X/S$');
%         ylabel('$Y/S$');
% set(findall(Fig2,'type','text'),'FontSize',16)
% print('-dpdf','-r500',['Vars/Eps' sprintf('%.3f', eps) '/' TitleTxt '_InstantRXN.pdf']) 
% 
% %rxn
% Fig2;clf;        
%         imagesc(DSC1C2,'XData',DSXData,'YData',DSYData);hold on
%         imagesc(USC1C2,'XData',USXData,'YData',USYData);hold off;
%         %axis([Xshift-DSc USc 1 DSr]);
%         axis image;set(gca,'YDir','normal');axis([0 XMAX -YMAX YMAX]);
%         colormap(flipud(gray));caxis([0 .05]);
%         title({'$<C_1 C_2>$';''})
%         xlabel('$X/S$');
%         ylabel('$Y/S$');
%         set(findall(Fig2,'type','text'),'FontSize',16)
% print('-dpdf','-r500',['Vars/Eps' sprintf('%.3f', eps) '/' TitleTxt '_MeanRXN.pdf']) 
% 
% % RHO
%  Fig2;clf;
%          
%          hold on;
%          imagesc(DSCov./(DSRMSE1.*DSRMSE2),'XData',DSXData,'YData',DSYData);
%          imagesc(USCov./(USRMSE1.*USRMSE2),'XData',USXData,'YData',USYData);
%         %axis([Xshift-DSc USc 1 DSr]);
%         axis image;
%         axis([0 XMAX -6 6]);
%         set(gca,'YDir','normal');
%         clear B;
%             cbot=-1;
%             ctop=1;
%             mid=round(-cbot/(ctop-cbot)*64);
%             B(1,:)= [0:1/(mid-1):1 ones(1,(64-mid))];
%             B(2,:)= [0:1/(mid-1):1 1:-1/(64-mid-1):0];
%             B(3,:)= [ones(1,mid) 1:-1/(64-mid-1):0];
%             colormap(B')
%             caxis([cbot ctop]);
%         colorbar('location','West')
%                 xlabel('$X/S$');
%         ylabel('$Y/S$');hold off;
%         set(findall(Fig2,'type','text'),'FontSize',16)
%         title({'$\frac{<c_1^\prime c_2^\prime>}{<\sigma_1><\sigma_2>}$';''},'FontSize',24)
% 
%         print('-dpdf','-r500',['Vars/Eps' sprintf('%.3f', eps) '/' TitleTxt '_Rho.pdf'])    
%         
% %Instant Cov        
%  Fig2;clf;   clear B;
%         USc1prime=(USC1-USmean1);
%         USc2prime=(USC2-USmean2);
%         DSc1prime=(DSC1-DSmean1);
%         DSc2prime=(DSC2-DSmean2);
%         cbot=-0.1
%         ctop=0.1;
%         caxis([cbot ctop]);
%         	mid=round(-cbot/(ctop-cbot)*64);
%             B(1,:)= [0:1/(mid-1):1 ones(1,(64-mid))];
%             B(2,:)= [0:1/(mid-1):1 1:-1/(64-mid-1):0];
%             B(3,:)= [ones(1,mid) 1:-1/(64-mid-1):0];
%         imagesc(DSc1prime.*DSc2prime,'XData',DSXData,'YData',DSYData);hold on;
%         imagesc(USc1prime.*USc2prime,'XData',USXData,'YData',USYData);
%         plot([max(USXData) max(USXData)],[-YMAX YMAX],'k-','LineWidth',2);hold off;
%         axis image;set(gca,'YDir','normal');axis([0 XMAX -YMAX YMAX]);
%         
%              cbot=-0.01
%              ctop=0.01;
%              caxis([cbot ctop]);
%              mid=round(-cbot/(ctop-cbot)*64);
%              colormap(B')
%          colorbar('location','West')
%         
%         title({'$c_1^\prime c_2^\prime$';''})
%         xlabel('$X/S$');
%         ylabel('$Y/S$'); 
%         set(findall(Fig2,'type','text'),'FontSize',16)
%         print('-dpdf','-r500',['Vars/Eps' sprintf('%.3f', eps) '/' TitleTxt '_InstantCov.pdf'])  
%       
%         
% %Cov Quad Anaylsis 
%  set(Fig2,'PaperUnits','inches','PaperSize',[16 9],'PaperPosition',[.5,.5,15,8]);clf;    
% 	subaxis(2,2,1,'Spacing', 0.00, 'Padding', 0.000, 'Margin', .02);
%          imagesc(DSc1prime.*DSc2prime.*(DSc1prime<0).*(DSc2prime>0),'XData',DSXData,'YData',DSYData);hold on;
%          imagesc(USc1prime.*USc2prime.*(USc1prime<0).*(USc2prime>0),'XData',USXData,'YData',USYData);
%          plot([max(USXData) max(USXData)],[-YMAX YMAX],'k-','LineWidth',2);hold off;
%          set(gca,'YDir','normal');axis image;axis([0 XMAX -YMAX YMAX]);
%          colormap(B');caxis([cbot ctop]);
% 	subaxis(2,2,2,'Spacing', 0.00, 'Padding', 0.000, 'Margin', .02);
%          imagesc(DSc1prime.*DSc2prime.*(DSc1prime>0).*(DSc2prime>0),'XData',DSXData,'YData',DSYData);hold on;
%          imagesc(USc1prime.*USc2prime.*(USc1prime>0).*(USc2prime>0),'XData',USXData,'YData',USYData);
%          plot([max(USXData) max(USXData)],[-YMAX YMAX],'k-','LineWidth',2);hold off;
%          set(gca,'YDir','normal');axis image;axis([0 XMAX -YMAX YMAX]);
%          colormap(B');caxis([cbot ctop]);
% 	subaxis(2,2,3,'Spacing', 0.00, 'Padding', 0.000, 'Margin', .02);
%         imagesc(DSc1prime.*DSc2prime.*(DSc1prime<0).*(DSc2prime<0),'XData',DSXData,'YData',DSYData);hold on;
%         imagesc(USc1prime.*USc2prime.*(USc1prime<0).*(USc2prime<0),'XData',USXData,'YData',USYData);
%         plot([max(USXData) max(USXData)],[-YMAX YMAX],'k-','LineWidth',2);hold off;
%          set(gca,'YDir','normal');axis image;axis([0 XMAX -YMAX YMAX]);
%          colormap(B');caxis([cbot ctop]);
%     subaxis(2,2,4,'Spacing', 0.00, 'Padding', 0.000, 'Margin', .02);
%          imagesc(DSc1prime.*DSc2prime.*(DSc1prime>0).*(DSc2prime<0),'XData',DSXData,'YData',DSYData);hold on;
%          imagesc(USc1prime.*USc2prime.*(USc1prime>0).*(USc2prime<0),'XData',USXData,'YData',USYData);
%          plot([max(USXData) max(USXData)],[-YMAX YMAX],'k-','LineWidth',2);hold off;
%          set(gca,'YDir','normal');axis image;axis([0 XMAX -YMAX YMAX]);
%          colormap(B');caxis([cbot ctop]);
%           set(findall(Fig2,'type','text'),'FontSize',16)
%           print('-dpdf','-r500',['Vars/Eps' sprintf('%.3f', eps) '/' TitleTxt '_Quad.pdf'])  
%     
% 
% % try this     
% 
% vidObj = VideoWriter('Prog.avi'); vidObj.FrameRate=1; open(vidObj);
% for i=1490:1505
%  load(['/Volumes/Flagstaff/TwoJet/041511/ProcImgs/Proc' sprintf('%05d', i) '.mat'])
%     c1prime=(C1-USmean1);
%     c2prime=(C2-USmean2);
%     Fig6=figure(6);
%     set(Fig6,'PaperPositionMode','auto');clf;
%     subplot(2,1,1)
%          hold on;
%          imshow(ColorChangeWhite(C1,C2,.8),'XData',USXData,'YData',USYData);
%          axis image;set(gca,'YDir','normal');axis([0 floor(max(abs(USXData))) -YMAX YMAX]);
%          title('$C_1 $ and $C_2$')
%          xlabel('$X/S$');
%          ylabel('$Y/S$');hold off;     
%     subplot(2,1,2)
%          hold on;
%          imagesc(c1prime.*c2prime.*(c1prime>0).*(c2prime>0),'XData',USXData,'YData',USYData);
%          colormap(B');caxis([-.01 .01]);
%          axis image;set(gca,'YDir','normal');axis([0 floor(max(abs(USXData))) -YMAX YMAX]);
%     f = getframe(Fig6); writeVideo(vidObj,f);
% end
% close(vidObj);
%Next we need to define our box locations:
    Box=[15 15];        % Box size (Real)
    BoxN=Box/S;         % Box Size (Norm)
    
    % Create vectors relating Normailzed coordnates to pixel indicies
    XDatUS=linspace(USXData(1), USXData(2), USc); 
    XDatDS=linspace(DSXData(1), DSXData(2), DSc);
    YDatUS=linspace(USYData(1), USYData(2), USr); 
    YDatDS=linspace(DSYData(1), DSYData(2), DSr);

    %Note, Y points will fall at -sigma, -.5, 0, .5, simga
        UStop=find(YDatUS < 0.5,1,'first')-CLshift;
        USmid=find(YDatUS < 0,1,'first');
        USbot=find(YDatUS <-.5,1,'first')+CLshift;
    
        DStop=find(YDatDS < 0.5,1,'first')-CLshift;
        DSmid=find(YDatDS < 0,1,'first');
        DSbot=find(YDatDS <-.5,1,'first')+CLshift;
    
  
    %X pts, for new coordnate system in plots, will have to convert for DS image     
    Xpts=0:3:60 % Note: The index of XData closest to the points is the easiest conversion, Need some way oto distinguish between upstream and downstreamfo
  % Initialize PDF point matricies
        USptsL=find(Xpts>((USXData(1)+DSXData(2))/2),1,'first')-1;
        DSptsL=find(Xpts>DSXData(1),1,'first')-1;
        
        Xpts=Xpts(1:DSptsL);
        
        %This would work better if i completely reformated it to have a
        %"struct" format based on rows and column, giving real pixel data
        %as well as normalized, statstics, and JPDF....
        
        PDFs=struct([]);
        PDFptsUS=zeros(5,USptsL,2);
        PDFptsDS=zeros(5,length(Xpts)-USptsL,2);

    for i=1:length(Xpts)
        if i<=USptsL
            % Find the real pixel of the X point
            if USXData(2) > Xpts(i) % Need Check to see if the VO is on the screen.
                USXpts(i)=floor(USc-Box(1)/2);
            else
                USXpts(i)=find(XDatUS < Xpts(i),1,'first');
            end
            %Find the gaussian
            [sigma1,Mu1,A1]=mygaussfit(1:USr,mean( USmean1(:,(round(USXpts(i)-Box(1)/2)) : (round(USXpts(i)+Box(1)/2))) ,2));
            [sigma2,Mu2,A2]=mygaussfit(1:USr,mean( USmean2(:,(round(USXpts(i)-Box(1)/2)) : (round(USXpts(i)+Box(1)/2))) ,2));
            Sig=(sigma1+sigma2)/2 ;
            Hgh=min(Mu1,Mu2)-Sig;
            Low=max(Mu1,Mu2)+Sig;
            
            PDFs(1,i).Loc=1; PDFs(1,i).Xpix=USXpts(i); PDFs(1,i).Ypix=round(Hgh);   PDFs(1,i).Xnorm=Xpts(i); PDFs(1,i).Ynorm=YDatUS(PDFs(1,i).Ypix);
            PDFs(2,i).Loc=1; PDFs(2,i).Xpix=USXpts(i); PDFs(2,i).Ypix=round(UStop); PDFs(2,i).Xnorm=Xpts(i); PDFs(2,i).Ynorm=YDatUS(PDFs(2,i).Ypix);
            PDFs(3,i).Loc=1; PDFs(3,i).Xpix=USXpts(i); PDFs(3,i).Ypix=round(USmid); PDFs(3,i).Xnorm=Xpts(i); PDFs(3,i).Ynorm=YDatUS(PDFs(3,i).Ypix);
            PDFs(4,i).Loc=1; PDFs(4,i).Xpix=USXpts(i); PDFs(4,i).Ypix=round(USbot); PDFs(4,i).Xnorm=Xpts(i); PDFs(4,i).Ynorm=YDatUS(PDFs(4,i).Ypix);
            PDFs(5,i).Loc=1; PDFs(5,i).Xpix=USXpts(i); PDFs(5,i).Ypix=round(Low);   PDFs(5,i).Xnorm=Xpts(i); PDFs(5,i).Ynorm=YDatUS(PDFs(5,i).Ypix);              
        else
            %j=i-USptsL;
            DSXpts(i)=find(XDatDS < Xpts(i),1,'first');
            [sigma1,Mu1,A1]=mygaussfit(1:DSr,mean( DSmean1(:,round((DSXpts(i)-Box(1)/2)) : round((DSXpts(i)+Box(1)/2))) ,2));
            [sigma2,Mu2,A2]=mygaussfit(1:DSr,mean( DSmean2(:,round((DSXpts(i)-Box(1)/2)) : round((DSXpts(i)+Box(1)/2))) ,2));
            Sig=(sigma1+sigma2)/2 ;
            Hgh=min(Mu1,Mu2)-Sig;
            Low=max(Mu1,Mu2)+Sig;
            
            PDFs(1,i).Loc=2; PDFs(1,i).Xpix=DSXpts(i); PDFs(1,i).Ypix=round(Hgh);   PDFs(1,i).Xnorm=Xpts(i); PDFs(1,i).Ynorm=YDatDS(PDFs(1,i).Ypix);
            PDFs(2,i).Loc=2; PDFs(2,i).Xpix=DSXpts(i); PDFs(2,i).Ypix=round(DStop); PDFs(2,i).Xnorm=Xpts(i); PDFs(2,i).Ynorm=YDatDS(PDFs(2,i).Ypix);
            PDFs(3,i).Loc=2; PDFs(3,i).Xpix=DSXpts(i); PDFs(3,i).Ypix=round(DSmid); PDFs(3,i).Xnorm=Xpts(i); PDFs(3,i).Ynorm=YDatDS(PDFs(3,i).Ypix);
            PDFs(4,i).Loc=2; PDFs(4,i).Xpix=DSXpts(i); PDFs(4,i).Ypix=round(DSbot); PDFs(4,i).Xnorm=Xpts(i); PDFs(4,i).Ynorm=YDatDS(PDFs(4,i).Ypix);
            PDFs(5,i).Loc=2; PDFs(5,i).Xpix=DSXpts(i); PDFs(5,i).Ypix=round(Low);   PDFs(5,i).Xnorm=Xpts(i); PDFs(5,i).Ynorm=YDatDS(PDFs(5,i).Ypix);
        end
        %Draw Rectangles                                  
        for Y=1:5
            Xpt=PDFs(Y,i).Xnorm;
            Ypt=PDFs(Y,i).Ynorm;
            %Can Delete                Ypt=YDatUS(PDFptsUS(Y,i,2));
          %  subaxis(2,1,1,'Spacing', 0.02, 'Padding', 0.000, 'Margin', .02);
                rectangle('Position',[(Xpt-BoxN(1)/2),Ypt-BoxN(2)/2,BoxN(1),BoxN(2)]);
          %  subaxis(2,1,2,'Spacing', 0.02, 'Padding', 0.000, 'Margin', .02);
          %      rectangle('Position',[(Xpt-BoxN(1)/2),Ypt-BoxN(2)/2,BoxN(1),BoxN(2)]);
       end
    end
    
        
    set(gcf,'PaperOrientation','landscape',...
            'PaperUnits','normalized',...
            'PaperType','tabloid',...
            'PaperPosition', [0 0 1 1]);
    [n,d] = rat(Expon);        
    print('-dpdf','-r500',['Vars/Eps' sprintf('%.3f', eps) '/' TitleTxt '_Locator_' num2str(n) '|' num2str(d) '.pdf'])
%% Now we need to find the actual PDFs  Need to format PDF2d to accomindate a matrix of X, Y pts (Should i consider 

   [JPDFs]=PDF2d('',[USstart DSstart],[USstop DSstop],PDFs,Box,eps);
  
%% STEP 3: Plot that shoot.
PDFsize=length(JPDFs(1).JPDF);
Figure2=figure(2);
clf;
set(Figure2,'defaulttextinterpreter','latex')
    set(gcf,'Position', get(0,'Screensize'),... %Maximize Figure
            'PaperOrientation','landscape',...
            'PaperUnits','normalized',...
            'PaperType','tabloid',...
            'PaperPosition', [0 0 1 1]);

Boxb(2)=floor(Box(2)/2);
Boxb(1)=floor(Box(1)/2);

[Ys Xs]=size(JPDFs);  

Contours=[.0001 .00021 .00046 .001 .0021 .0046 .01];
    for X=1:Xs
        for Y=1:3;
            subaxis(3,Xs,X+(Y-1)*Xs,'Spacing', 0.0, 'Padding', 0.000, 'Margin', .02);
            if Y==1
                JPDF=(JPDFs(Y,X).JPDF+JPDFs(5,X).JPDF')/2;
            elseif Y==2
                JPDF=(JPDFs(Y,X).JPDF+JPDFs(4,X).JPDF')/2;
            else
                JPDF=(JPDFs(Y,X).JPDF);
            end

            contourf( log(JPDF),log(Contours));hold on;
                axis([1 PDFsize 1 PDFsize]);axis square;
                set(gca,    'XTick',PDFsize*linspace(0,1,11).^Expon,...
                            'XTickLabel',linspace(0,1,11),...
                            'YTick',PDFsize*linspace(0,1,11).^Expon,...
                            'YTickLabel',linspace(0,1,11));
                
            hold off;
        end
    end
    
    colormap(flipud(hot));
    axes('Position', [0.045 0.05 0.9 0.9], 'Visible', 'off');
                %Set bottom of colorbar another half tick down:
                cbot=3*log(Contours(1))/2-log(Contours(2))/2;
                ctop=log(Contours(length(Contours)));
    
                caxis([cbot ctop]);
    c=colorbar ('FontSize',12,'YTick',log(Contours),'YTickLabel',Contours);


    print('-dpdf','-r500',['Vars/Eps' sprintf('%.3f', eps) '/' TitleTxt '_PDF_' num2str(n) '|' num2str(d) '.pdf'])

