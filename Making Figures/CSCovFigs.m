function [VO CSxdat CSmean1 CSmean2 CSs CSrho CSc1c2 CScov] = CSCovFigs(USstart, USstop, DSstart, DSstop, eps, Xshift,Expon, NAME,Symbol,Pos)

BS=30
load(['Vars/Eps' sprintf('%.3f', eps) '/VOetc' NAME],'VO','S','USycent','DSycent','Yshift','USXData','USYData','DSXData','DSYData','Ang1','Ang2');
load(['Vars/PreRunVars'],'Scale');
    USXData=real(USXData);
    DSXData=real(DSXData);
    % Load US stuff
        mean2=[];

        USMeanName=[ sprintf('%05d', USstart) '-'  sprintf('%05d', USstop)];
            load(['Vars/Eps' sprintf('%.3f', eps) '/ProcMeansE' USMeanName]);
                USmean1=imrotate(mean1,Ang1,'crop');USmean2=imrotate(mean2,Ang1,'crop');
                [USr USc]=size(mean1);
            %load(['Vars/Eps' sprintf('%.3f', eps) '/CovE' USMeanName]);
                USC1C2=imrotate(C1C2,Ang1,'crop');USCov=imrotate(Cov,Ang1,'crop');
            %load(['Vars/Eps' sprintf('%.3f', eps) '/RMSEe' USMeanName]);
                USRMSE1=imrotate(RMSE1,Ang1,'crop');USRMSE2=imrotate(RMSE2,Ang1,'crop');
        
    % Load DS stats;
        DSMeanName=[ sprintf('%05d', DSstart) '-'  sprintf('%05d', DSstop)];
            load(['Vars/Eps' sprintf('%.3f', eps) '/ProcMeansE' DSMeanName]);
                DSmean1=imrotate(mean1,Ang2,'crop');DSmean2=imrotate(mean2,Ang2,'crop');
                [DSr, DSc]=size(mean1);
            %load(['Vars/Eps' sprintf('%.3f', eps) '/CovE' DSMeanName]);
                DSC1C2=imrotate(C1C2,Ang2,'crop');DSCov=imrotate(Cov,Ang2,'crop');
            %load(['Vars/Eps' sprintf('%.3f', eps) '/RMSEe' DSMeanName]);
                DSRMSE1=imrotate(RMSE1,Ang2,'crop');DSRMSE2=imrotate(RMSE2,Ang2,'crop');

        UScl=USycent;
        DScl=DSycent;
        
 % Would like to use X locations 
    XDatUS=linspace(USXData(1), USXData(2), USc);%*S/Scale; 
    XDatDS=linspace(DSXData(1), DSXData(2), DSc);%*S/Scale;
 % Would like to use UNITLESS Y dimensions
    YDatUS=linspace(USYData(1), USYData(2), USr); 
    YDatDS=linspace(DSYData(1), DSYData(2), DSr);
        
  if S/Scale<2
      Xpts=[2.5 5 10 20];
  else
      Xpts=[2.5 5 10];
  end

        USptsL=find(Xpts>((XDatUS(1)+XDatDS(DSc))/2),1,'first')-1;
        DSptsL=find(Xpts>XDatDS(1),1,'first')-1;
        if(isempty(USptsL));
            USptsL=length(Xpts);
            DSptsL=length(Xpts);
        elseif(isempty(DSptsL));
            DSptsL=length(Xpts);
        end;
        Xpts=Xpts(1:DSptsL);

    for i=1:length(Xpts)
       %subaxis(rows,cols,cellx,celly,spanx,spany[,settings]) 
       if i==1
            subaxis(1,18,1,1,6,1,'Margin',.01,'MarginLeft',.06,'MarginBottom',.07,'MarginTop',.055,'Padding',0.01,'Spacing',0)
            axis([-.013 .022 -3 3]);
            set(gca,'XTick',[-.01, 0, .01],'XTickLabel',{'-0.01';'0';'0.01'});
            title('$x=2.5$')
       elseif i==2
           subaxis(1,18,7,1,5,1,'Margin',.01,'MarginLeft',.06,'MarginBottom',.07,'MarginTop',.05,'Padding',0.01,'Spacing',0)
           axis([-.013*5/6 .022*5/6 -3 3]);
           set(gca,'XTick',[-.01, 0, .01],'XTickLabel',{'-0.01';'0';'0.01'});
           title('$x=5$')
       elseif i==3
           subaxis(1,18,12,1,4,1,'Margin',.01,'MarginLeft',.06,'MarginBottom',.07,'MarginTop',.05,'Padding',0.01,'Spacing',0)
           axis([-.013*4/6 .022*4/6 -3 3]);
           set(gca,'XTick',[0, .01],'XTickLabel',{'0';'0.01'});
           title('$x=10$')
       else
           subaxis(1,18,16,1,3,1,'Margin',.01,'MarginLeft',.06,'MarginBottom',.07,'MarginTop',.05,'Padding',0.01,'Spacing',0)
           axis([-.013*3/6 .022*3/6 -3 3]);
           set(gca,'XTick',[0, .01],'XTickLabel',{'0';'0.01'});
           title('$x=20$')
       end
        if i<=USptsL
            % Find the real pixel of the X point
            if USXData(2) > Xpts(i) % Need Check to see if the VO is on the screen.
                Col=floor(USc-Box(1)/2);
            else
                Col=find(XDatUS < Xpts(i),1,'first');
            end
            %Find the gaussian

            % Bin means 
                Mean1t = mean( USmean1(:,ceil(Col-BS/2):floor(Col+BS/2)) , 2 );
                Mean2t = mean( USmean2(:,ceil(Col-BS/2):floor(Col+BS/2)) , 2 );
                [mean1Bin, BinYs]   = AverageBins( Mean1t ,YDatUS,BS);
                [mean2Bin, BinYs]   = AverageBins( Mean2t ,YDatUS,BS);
                
                hold on;
                    [sigma1,mu1,A1]=mygaussfit(YDatUS,Mean1t,.1);
                    [sigma2,mu2,A2]=mygaussfit(YDatUS,Mean2t,.1);
                    GaussFit1=A1 * exp( -(YDatUS-mu1).^2 ./ (2*sigma1^2) );
                    GaussFit2=A2 * exp( -(YDatUS-mu2).^2 ./ (2*sigma2^2) );
                    
                    plot(GaussFit1.*GaussFit2,YDatUS,'-','Color', [.7,.7,.7]); 
                    
                    MuPlot  = plot(mean1Bin.*mean2Bin,BinYs,'s','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',4);
                hold off;
                CSmean1(i,:)=mean1Bin;
                CSmean2(i,:)=mean2Bin;
                CSys(i,:)   =BinYs;
                       
            % Bin C1C2, Cov
                c1c2t = mean( USC1C2(:,ceil(Col-BS/2):floor(Col+BS/2)) , 2 );
                covt = mean( USCov(:,ceil(Col-BS/2):floor(Col+BS/2)) , 2 );
                [c1c2Bin, BinYs]   = AverageBins( c1c2t ,YDatUS,BS);
                [covBin, BinYs]   = AverageBins( covt ,YDatUS,BS);
                hold on;
                    [sigma12,mu12,A12]=mygaussfit(YDatUS,c1c2t,.1);
                    GaussFit12=A12 * exp( -(YDatUS-mu12).^2 ./ (2*sigma12^2) );
                    
                    plot(GaussFit12,YDatUS,'-','Color', [.7,.7,.7]); 
                    plot(GaussFit12-GaussFit1.*GaussFit2,YDatUS,'-','Color', [.7,.7,.7]); 
                    
                    c1c2Plot= plot(c1c2Bin,BinYs,'o','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',4);
                    CovPlot = plot(covBin,BinYs,'^','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',4);
                hold off;
                CSc1c2(i,:)=c1c2Bin;    
                CScov(i,:)=covBin;    
                        
        else
            Col=find(XDatDS < Xpts(i),1,'first');
            
                       % Bin means 
                Mean1t = mean( DSmean1(:,ceil(Col-BS/2):floor(Col+BS/2)) , 2 );
                Mean2t = mean( DSmean2(:,ceil(Col-BS/2):floor(Col+BS/2)) , 2 );
                [mean1Bin, BinYs]   = AverageBins( Mean1t ,YDatDS,BS);
                [mean2Bin, BinYs]   = AverageBins( Mean2t ,YDatDS,BS);
                
                hold on;
                    [sigma1,mu1,A1]=mygaussfit(YDatDS,Mean1t,.1);
                    [sigma2,mu2,A2]=mygaussfit(YDatDS,Mean2t,.1);
                    GaussFit1=A1 * exp( -(YDatDS-mu1).^2 ./ (2*sigma1^2) );
                    GaussFit2=A2 * exp( -(YDatDS-mu2).^2 ./ (2*sigma2^2) );
                    
                    plot(GaussFit1.*GaussFit2,YDatDS,'-','Color', [.7,.7,.7]); 
                    
                    MuPlot  = plot(mean1Bin.*mean2Bin,BinYs,'s','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',4);
                hold off;
                CSmean1(i,:)=mean1Bin;
                CSmean2(i,:)=mean2Bin;
                CSys(i,:)   =BinYs;
                       
            % Bin C1C2, Cov
                c1c2t = mean( DSC1C2(:,ceil(Col-BS/2):floor(Col+BS/2)) , 2 );
                covt = mean( DSCov(:,ceil(Col-BS/2):floor(Col+BS/2)) , 2 );
                [c1c2Bin, BinYs]   = AverageBins( c1c2t ,YDatDS,BS);
                [covBin, BinYs]   = AverageBins( covt ,YDatDS,BS);
                hold on;
                    [sigma12,mu12,A12]=mygaussfit(YDatDS,c1c2t,.1);
                    GaussFit12=A12 * exp( -(YDatDS-mu12).^2 ./ (2*sigma12^2) );
                    
                    plot(GaussFit12,YDatDS,'-','Color', [.7,.7,.7]); 
                    plot(GaussFit12-GaussFit1.*GaussFit2,YDatDS,'-','Color', [.7,.7,.7]); 
                    
                    c1c2Plot= plot(c1c2Bin,BinYs,'o','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',4);
                    CovPlot = plot(covBin,BinYs,'^','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',4);
                hold off;
                CSc1c2(i,:)=c1c2Bin;    
                CScov(i,:)=covBin;  
            
        end
        if i==1
           ylabel('$z$');
           Leg=legend([c1c2Plot, MuPlot, CovPlot],'$\left<\Phi_A \Phi_B\right>$','$\left<\Phi_A\right>\left<\Phi_B\right>$','$\left<\phi_A^\prime \phi_B^\prime\right>$','Location','NorthEast');
           set(Leg,'Position',[0.175, 0.66, 0.2168, 0.2626])
           set(Leg,'Box','off');
           ch = get(Leg, 'Children');
           textCh = ch(strcmp(get(ch, 'Type'), 'text'));
           for iText = 1:numel(textCh)
                set(textCh(iText), 'Position', get(textCh(iText), 'Position') + [-0.1 0 0])
            end
        else
           set(gca,'YTickLabel',[]);
        end
        
        if i==1
            text(-.15,1.04,'a','Units','Normalized')
        elseif i==2
            text(-.075,1.04,'b','Units','Normalized')
        elseif i==3
            text(-.075,1.04,'c','Units','Normalized')
        else
            text(-.075,1.04,'d','Units','Normalized')
        end
        
        hold on;
        plot([0 0],[-10 10],'k-');
        
    end
    
        
        
            
    