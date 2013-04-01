
function plotPDFs(USstart, USstop, DSstart,DSstop, eps, Exp, TitleTxt)
   
% %   
% set(0,'defaulttextinterpreter','latex')
% NAME=TitleTxt
% load(['Vars/Eps' sprintf('%.3f', eps) '/VOetc' NAME],'VO','S','USycent','DSycent','Yshift','USXData','USYData','DSXData','DSYData','CLshift','Ang1','Ang2');
% load('Vars/PreRunVars','Scale');
% % Load US stuff
%     mean2=[];
% 
%     USMeanName=[ sprintf('%05d', USstart) '-'  sprintf('%05d', USstop)];
%         load(['Vars/Eps' sprintf('%.3f', eps) '/ProcMeansE' USMeanName]);
%             USmean1=mean1;USmean2=mean2;
%             [USr USc]=size(mean1);
%        % load(['Vars/Eps' sprintf('%.3f', eps) '/CovE' USMeanName]);
%             USC1C2=C1C2;USCov=Cov;
%        % load(['Vars/Eps' sprintf('%.3f', eps) '/RMSEe' USMeanName]);
%             USRMSE1=RMSE1;USRMSE2=RMSE2;
%             
% % Load DS stats;
%     DSMeanName=[ sprintf('%05d', DSstart) '-'  sprintf('%05d', DSstop)];
%         load(['Vars/Eps' sprintf('%.3f', eps) '/ProcMeansE' DSMeanName]);
%             DSmean1=mean1;DSmean2=mean2;
%             [DSr DSc]=size(mean1);
%        % load(['Vars/Eps' sprintf('%.3f', eps) '/CovE' DSMeanName]);
%             DSC1C2=C1C2;DSCov=Cov;
%        % load(['Vars/Eps' sprintf('%.3f', eps) '/RMSEe' DSMeanName]);
%             DSRMSE1=RMSE1;DSRMSE2=RMSE2;
% 
% % Plot Means and <C1C2> with boxes at PDF location
%     Figure1=figure(1);
% 
%     clf;
% 
%     subaxis(2,1,1,'Spacing', 0.02, 'Padding', 0.000, 'Margin', .02);
%         hold on;
%         imshow(ColorChangeWhite(DSmean1,DSmean2,.5),'XData',DSXData,'YData',DSYData);
%         imshow(ColorChangeWhite(USmean1,USmean2,.5),'XData',USXData,'YData',USYData);
%         set(gca,'YDir','normal');
%         %axis([Xshift-DSc USc 1 DSr]);
%         XMAX=floor(max(abs(DSXData)))
%         YMAX=floor(min(abs(USYData)))
%         axis image;axis([0 XMAX -YMAX YMAX]);
%         title('$<C_1 >$ and $<C_2 >$')
%         xlabel('$X/S$');
%         ylabel('$Y/S$');hold off;
%     subaxis(2,1,2,'Spacing', 0.02, 'Padding', 0.000, 'Margin', .02);
%         hold on;
%         imagesc(DSC1C2,'XData',DSXData,'YData',DSYData);
%         imagesc(USC1C2,'XData',USXData,'YData',USYData);
%         %axis([Xshift-DSc USc 1 DSr]);
%         axis image;set(gca,'YDir','normal');axis([0 XMAX -YMAX YMAX]);
%         colormap(flipud(gray));caxis([0 .01]);freezeColors;cbfreeze(colorbar('location','South'));
%         title('$<C_1 C_2>$')
%         xlabel('$X/S$');
%         ylabel('$Y/S$');hold off;
%         
%         %(USmean1.*USmean2),'XData',USXData,'YData',USYData);
%         
%        
% %%
% %Next we need to define our box locations:
%     Box=[15 15];        % Box size (Real)
%     BoxN=Box/S;         % Box Size (Norm)
%     
%     % Create vectors relating Normailzed coordnates to pixel indicies
%     XDatUS=linspace(USXData(1), USXData(2), USc); 
%     XDatDS=linspace(DSXData(1), DSXData(2), DSc);
%     YDatUS=linspace(USYData(1), USYData(2), USr); 
%     YDatDS=linspace(DSYData(1), DSYData(2), DSr);
% 
%     %Note, Y points will fall at -sigma, -.5, 0, .5, simga
%         UShgh=find(YDatUS < 1.0,1,'first');
%         UStop=find(YDatUS < 0.5,1,'first');
%         USmid=find(YDatUS < 0.0,1,'first');
%         USbot=find(YDatUS <-0.5,1,'first');
%         USlow=find(YDatUS <-1.0,1,'first');
%     
%         DShgh=find(YDatDS < 1.0,1,'first');
%         DStop=find(YDatDS < 0.5,1,'first');
%         DSmid=find(YDatDS < 0.0,1,'first');
%         DSbot=find(YDatDS <-0.5,1,'first');
%         DSlow=find(YDatDS <-1.0,1,'first');
%     
%   
%     %X pts, for new coordnate system in plots, will have to convert for DS image   
%    % Xpts=[4 12 20 28]*Scale/S
%    if S/Scale<2
%        Xpts=[5 10 20];
%    else
%        Xpts=[2.5 5 10];
%    end
%    % Xpts=0:3:60 % Note: The index of XData closest to the points is the easiest conversion, Need some way oto distinguish between upstream and downstreamfo
%   % Initialize PDF point matricies
%         USptsL=find(Xpts>((USXData(1)+DSXData(2))/2),1,'first')-1;
%         DSptsL=find(Xpts>DSXData(1),1,'first')-1;
%         if(isempty(DSptsL))
%             DSptsL=length(Xpts);
%         end
%         Xpts=Xpts(1:DSptsL);
%         
%         %This would work better if i completely reformated it to have a
%         %"struct" format based on rows and column, giving real pixel data
%         %as well as normalized, statstics, and JPDF....
%         
%         PDFs=struct([]);
%         PDFptsUS=zeros(5,USptsL,2);
%         PDFptsDS=zeros(5,length(Xpts)-USptsL,2);
% 
%     for i=1:length(Xpts)
%         if i<=USptsL
%             % Find the real pixel of the X point
%                 if USXData(2) > Xpts(i) % Need Check to see if the VO is on the screen.
%                     USXpts(i)=floor(USc-Box(1)/2);
%                 else
%                     USXpts(i)=find(XDatUS < Xpts(i),1,'first');
%                 end
%             %Find the gaussian
% %                 [sigma1,Mu1,A1]=mygaussfit(1:USr,mean( USmean1(:,(round(USXpts(i)-Box(1)/2)) : (round(USXpts(i)+Box(1)/2))) ,2));
% %                 [sigma2,Mu2,A2]=mygaussfit(1:USr,mean( USmean2(:,(round(USXpts(i)-Box(1)/2)) : (round(USXpts(i)+Box(1)/2))) ,2));
% %                 Sig=(sigma1+sigma2)/2 ;
% %                 Hgh=min(Mu1,Mu2)-Sig;
% %                 Low=max(Mu1,Mu2)+Sig;
%             Hgh=UShgh;
%             Low=USlow;
%             
%             %Note: Since the images arn't being rotated, we need to adjust
%             %the pixel for the rotation:
%             
%             %Note Loc tells which Img we're in (1 for US, etc)
%                 [r c]=PxlRotate(Hgh,USXpts(i),size(USmean1),Ang1);
%                 PDFs(1,i).Loc=1; PDFs(1,i).Xpix=round(c); PDFs(1,i).Ypix=round(r);   PDFs(1,i).Xnorm=Xpts(i); PDFs(1,i).Ynorm=YDatUS(PDFs(1,i).Ypix);
%                 [r c]=PxlRotate(UStop,USXpts(i),size(USmean1),Ang1);
%                 PDFs(2,i).Loc=1; PDFs(2,i).Xpix=round(c); PDFs(2,i).Ypix=round(r); PDFs(2,i).Xnorm=Xpts(i); PDFs(2,i).Ynorm=YDatUS(PDFs(2,i).Ypix);
%                 [r c]=PxlRotate(USmid,USXpts(i),size(USmean1),Ang1);
%                 PDFs(3,i).Loc=1; PDFs(3,i).Xpix=round(c); PDFs(3,i).Ypix=round(r); PDFs(3,i).Xnorm=Xpts(i); PDFs(3,i).Ynorm=YDatUS(PDFs(3,i).Ypix);
%                 [r c]=PxlRotate(USbot,USXpts(i),size(USmean1),Ang1);
%                 PDFs(4,i).Loc=1; PDFs(4,i).Xpix=round(c); PDFs(4,i).Ypix=round(r); PDFs(4,i).Xnorm=Xpts(i); PDFs(4,i).Ynorm=YDatUS(PDFs(4,i).Ypix);
%                 [r c]=PxlRotate(Low,USXpts(i),size(USmean1),Ang1);
%                 PDFs(5,i).Loc=1; PDFs(5,i).Xpix=round(c); PDFs(5,i).Ypix=round(r);   PDFs(5,i).Xnorm=Xpts(i); PDFs(5,i).Ynorm=YDatUS(PDFs(5,i).Ypix);              
%         else
%             % Find the real pixel of the X point
%                 DSXpts(i)=find(XDatDS < Xpts(i),1,'first');
%             %Find the gaussian                
% %                 [sigma1,Mu1,A1]=mygaussfit(1:DSr,mean( DSmean1(:,round((DSXpts(i)-Box(1)/2)) : round((DSXpts(i)+Box(1)/2))) ,2));
% %                 [sigma2,Mu2,A2]=mygaussfit(1:DSr,mean( DSmean2(:,round((DSXpts(i)-Box(1)/2)) : round((DSXpts(i)+Box(1)/2))) ,2));
% %                 Sig=(sigma1+sigma2)/2 ;
% %                 Hgh=min(Mu1,Mu2)-Sig;
% %                 Low=max(Mu1,Mu2)+Sig;
%                     Hgh=DShgh;
%                     Low=DSlow;
%             %Note Loc tells which Img we're in (1 for US, etc)
%                 [r c]=PxlRotate(Hgh,DSXpts(i),size(DSmean1),Ang2);
%                 PDFs(1,i).Loc=2; PDFs(1,i).Xpix=round(c); PDFs(1,i).Ypix=round(r);   PDFs(1,i).Xnorm=Xpts(i); PDFs(1,i).Ynorm=YDatDS(PDFs(1,i).Ypix);
%                 [r c]=PxlRotate(DStop,DSXpts(i),size(DSmean1),Ang2);
%                 PDFs(2,i).Loc=2; PDFs(2,i).Xpix=round(c); PDFs(2,i).Ypix=round(r); PDFs(2,i).Xnorm=Xpts(i); PDFs(2,i).Ynorm=YDatDS(PDFs(2,i).Ypix);
%                 [r c]=PxlRotate(DSmid,DSXpts(i),size(DSmean1),Ang2);
%                 PDFs(3,i).Loc=2; PDFs(3,i).Xpix=round(c); PDFs(3,i).Ypix=round(r); PDFs(3,i).Xnorm=Xpts(i); PDFs(3,i).Ynorm=YDatDS(PDFs(3,i).Ypix);
%                 [r c]=PxlRotate(DSbot,DSXpts(i),size(DSmean1),Ang2);
%                 PDFs(4,i).Loc=2; PDFs(4,i).Xpix=round(c); PDFs(4,i).Ypix=round(r); PDFs(4,i).Xnorm=Xpts(i); PDFs(4,i).Ynorm=YDatDS(PDFs(4,i).Ypix);
%                 [r c]=PxlRotate(Low,DSXpts(i),size(DSmean1),Ang2);
%                 PDFs(5,i).Loc=2; PDFs(5,i).Xpix=round(c); PDFs(5,i).Ypix=round(r);   PDFs(5,i).Xnorm=Xpts(i); PDFs(5,i).Ynorm=YDatDS(PDFs(5,i).Ypix);
%         end
%         %Draw Rectangles                                  
%         for Y=1:5
%             Xpt=PDFs(Y,i).Xnorm;
%             Ypt=PDFs(Y,i).Ynorm;
%             %Can Delete                Ypt=YDatUS(PDFptsUS(Y,i,2));
%           %  subaxis(2,1,1,'Spacing', 0.02, 'Padding', 0.000, 'Margin', .02);
%                 rectangle('Position',[(Xpt-BoxN(1)/2),Ypt-BoxN(2)/2,BoxN(1),BoxN(2)]);
%           %  subaxis(2,1,2,'Spacing', 0.02, 'Padding', 0.000, 'Margin', .02);
%           %      rectangle('Position',[(Xpt-BoxN(1)/2),Ypt-BoxN(2)/2,BoxN(1),BoxN(2)]);
%        end
%     end
%     
%         
%     set(gcf,'PaperOrientation','landscape',...
%             'PaperUnits','normalized',...
%             'PaperType','tabloid',...
%             'PaperPosition', [0 0 1 1]);
%     [n,d] = rat(Expon);        
    %print('-dpdf','-r500',['Vars/Eps' sprintf('%.3f', eps) '/' TitleTxt '_Locator_' num2str(n) '|' num2str(d) '.pdf'])
%% Now we need to find the actual PDFs  Need to format PDF2d to accomindate a matrix of X, Y pts (Should i consider 

  % [JPDFs]=PDF2d('',[USstart DSstart],[USstop DSstop],PDFs,Box,eps);
   load(['Vars/Eps' sprintf('%.3f', eps) '/PDF2d' sprintf('%05d', USstart) '-' sprintf('%05d', DSstop)], 'JPDFs');   %Proc Mean
  
%% STEP 3: Plot that shoot.
PDFsize=length(JPDFs(1).JPDF);
Figure2=figure(2);
clf;colormap(flipud(hot));%colormap(flipud(gray.^.75));
[Ys Xs]=size(JPDFs); 
MG=0.04;
PD=0.015;
Width=8.5;
GraphSize=Width.*(1-2*MG-(Xs-1)*PD)/Xs;
Height=GraphSize*ceil(Ys/2)/(1-2*MG-(ceil(Ys/2)-1)*PD);
%Width=(Xs*GraphSize)/(1-(2+Xs)*MG);
set(Figure2,'defaulttextinterpreter','latex')
    set(Figure2,'PaperUnits','inches','PaperSize',[Width Height],'PaperPosition',[0,0,Width,Height],...
        'Units','inches','Position',[1 4,Width,Height]);
   % set(gcf,'Position', get(0,'Screensize'),... %Maximize Figure
   %         'PaperOrientation','landscape',...
   %         'PaperUnits','normalized',...
   %         'PaperType','tabloid',...
   %         'PaperPosition', [0 0 1 1]);

%Boxb(2)=floor(Box(2)/2);
%Boxb(1)=floor(Box(1)/2);
 

% Contours=[.001 .002 .005 .01 .02]; 
% for P=1:length(Contours)
%     ContLabel{P}=num2str(Contours(P),'%.4f');
% end

%cbot=3*log(Contours(1))/2-log(Contours(2))/2;
%        ctop=log(Contours(length(Contours)));
        
%Exp=.75;        
Xax=linspace(0,1,PDFsize).^Exp;
Yax=linspace(0,1,PDFsize).^Exp;

    for X=1:Xs
        for Y=1:3;
            if Y==1
                JPDF=(JPDFs(Y,X).JPDF+JPDFs(5,X).JPDF')/2;
                Mean1=(JPDFs(Y,X).Mean1+JPDFs(5,X).Mean2)/2;
                Mean2=(JPDFs(Y,X).Mean2+JPDFs(5,X).Mean1)/2;
            elseif Y==2
                JPDF=(JPDFs(Y,X).JPDF+JPDFs(4,X).JPDF')/2;
                Mean1=(JPDFs(Y,X).Mean1+JPDFs(4,X).Mean2)/2;
                Mean2=(JPDFs(Y,X).Mean2+JPDFs(4,X).Mean1)/2;
            else
                JPDF=(JPDFs(Y,X).JPDF);
                Mean1=JPDFs(Y,X).Mean1;
                Mean2=JPDFs(Y,X).Mean2;
            end
            
            %Want Contours at 99, 95, 90 85 80 70%
            Precents=[.80 .60 .40 .20];
            %Make CDF(ish)thing
            ThreshPDF=JPDF; 
            CDF=[];
            ProbFunc=[0:.0001:.9999];
            for Cnt=1:length(ProbFunc)
                ThreshPDF(ThreshPDF<ProbFunc(Cnt))=0;CDF(Cnt)=sum(ThreshPDF(:));
            end
            %plot(ProbFunc,CDF,'*')
            
            Contours=[];
            ContLabel={};
            for P=1:length(Precents)
                Index=find(CDF<Precents(P), 1, 'first');
                Contours(P)=ProbFunc(Index);
                ContLabel{P}=num2str(ProbFunc(Index),'%.4f');
            end
             cbot=log(Contours(1));
             ctop=log(Contours(length(Contours)));
            
            %This gets rid of that outer annoying line.
            JPDF(JPDF<Contours(1))=0;
            subaxis(ceil(Ys/2),Xs,X,Y,'Spacing', 0, 'Padding', PD, 'Margin', MG);
           % subaxis(3*6,Xs*6,X*6-4,Y*6-5,5,5,'Spacing', 0, 'Padding', 0,'PaddingRight',MG,'PaddingTop',MG, 'Margin', 2*MG,'MarginRight',MG);
                contourf(Xax,Yax, log(JPDF),log(Contours));hold on;
                    plot([Mean2 Mean2].^Exp,[0 1],'b');
                    plot([0 1],[Mean1 Mean1].^Exp,'b');hold off;
                    axis([0 1 0 1]);axis square;
                    %cbot=3*log(Contours(1))/2-log(Contours(2))/2;
                    caxis([cbot ctop]);
                    %set(gca,    'XTick',[],'YTick',[]);%PDFsize*linspace(0,1,11).^Expon,...
                            %'XTickLabel',linspace(0,1,11),...
                            %'YTick',PDFsize*linspace(0,1,11).^Expon,...
                            %'YTickLabel',linspace(0,1,11));
                    hc=colorbar('FontSize',10,'Location','East','YTick',log(Contours),'YTickLabel',ContLabel);
                    cPos=get(hc,'Position');
                    set(hc,'Position',[cPos(1)+cPos(3)/2,cPos(2),cPos(3)/2,cPos(4)])
            if Y==1;title(['$x^*=$' num2str(JPDFs(Y,X).Xnorm)]);end
            Max1=ceil(max(sum(JPDF))*10)/10;
            Max2=ceil(max(sum(JPDF'))*10)/10;
            MAX=max(Max1,Max2);
           % subaxis(3*6,Xs*6,X*6-4,Y*6,5,1,'Spacing', 0,'Padding', MG,'PaddingTop',0,'PaddingLeft',0);
           %     plot(Xax,sum(JPDF),'k');hold on;
           %     plot([Mean2 Mean2].^Exp,[0 1],'b');hold off;
           %     axis([0 1 0 Max1]);

                if Y==3;
                    xlabel('$\Phi_2$');
                    set(gca,'XTick',linspace(0,1,6).^Exp,...
                        'XTickLabel',linspace(0,1,6));%,...
                        %'YAxisLocation','left','YScale','linear',...
                        %'YTick',[]);
                        %'YTick',MAX);
                else set(gca,'XTick',[]);%,'YTick',[]);
                end;
                
           % subaxis(3*6,Xs*6,X*6-5,Y*6-5,1,5,'Spacing', 0,'Padding', MG,'PaddingRight',0,'PaddingBottom',0);
           %     plot(sum(JPDF'),Yax,'k');hold on;
           %     plot([0 1],[Mean1 Mean1].^Exp,'b');hold off;
                 
                if X==1;
                    ylabel('$\Phi_1$');
                    set(gca,'YTick',linspace(0,1,6).^Exp,...
                        'YTickLabel',linspace(0,1,6));%,...
                        %'XTick',MAX,'XTickLabel',[]);axis([0 Max2 0 1]);
                else set(gca,'YTick',[]);%,'XTick',[]);
                end
                
        end
    end
    
   % colormap(flipud(gray));
   % axes('Position', [2*MG 3*MG 1-4*MG 1-6*MG], 'Visible', 'off');
                %Set bottom of colorbar another half tick down:
   %             cbot=3*log(Contours(1))/2-log(Contours(2))/2;
   %             ctop=log(Contours(length(Contours)));
    
   %             caxis([cbot ctop]);
   % c=colorbar ('FontSize',12,'YTick',log(Contours),'YTickLabel',Contours);


    print('-dpdf','-r500',['Vars/Eps' sprintf('%.3f', eps) '/' TitleTxt '_PDF_many.pdf'])