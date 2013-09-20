%% 
% I want to do two things here:
% (1)     I'd like to find the VO using 1/C
% (2)     I'd like the 1/C profile to match between scalars so there is symmetry DS
% (3)     I'd like the Concentration @ the VO<=1 for both scalars
function JetVORescale(USstart, USstop, DSstart, DSstop, eps, Xshift,Expon, NAME)

    % Load US stuff
        mean2=[];

        USMeanName=[ sprintf('%05d', USstart) '-'  sprintf('%05d', USstop)];
            load(['Vars/Eps' sprintf('%.3f', eps) '/ProcMeansE' USMeanName]);
                USmean1=mean1;USmean2=mean2;                
                [USr, USc]=size(mean1);
           % load(['Vars/Eps' sprintf('%.3f', eps) '/CovE' USMeanName]);
            %    USC1C2=C1C2;USCov=Cov;
            %load(['Vars/Eps' sprintf('%.3f', eps) '/RMSEe' USMeanName]);
            %    USRMSE1=RMSE1;USRMSE2=RMSE2;

    % Load DS stats;
        DSMeanName=[ sprintf('%05d', DSstart) '-'  sprintf('%05d', DSstop)];
            load(['Vars/Eps' sprintf('%.3f', eps) '/ProcMeansE' DSMeanName]);
                DSmean1=mean1;DSmean2=mean2;                
                [DSr, DSc]=size(mean1);
           %load(['Vars/Eps' sprintf('%.3f', eps) '/CovE' DSMeanName]);
           %     DSC1C2=C1C2;DSCov=Cov;
           % load(['Vars/Eps' sprintf('%.3f', eps) '/RMSEe' DSMeanName]);
           %    DSRMSE1=RMSE1;DSRMSE2=RMSE2;
    % Preallocate for Speed
        Usigma1 = zeros(1,USc);   Usigma2 = zeros(1,USc);
        UMu1    = zeros(1,USc);   UMu2    = zeros(1,USc);
        USA1    = zeros(1,USc);   USA2    = zeros(1,USc);
        Dsigma1 = zeros(1,USc);   Dsigma2 = zeros(1,USc);
        DMu1    = zeros(1,USc);   DMu2    = zeros(1,USc);
        DSA1    = zeros(1,USc);   DSA2    = zeros(1,USc);
    % Run through Means, Fit Gaussians.
        for i=1:USc
            [Usigma1(i),UMu1(i),USA1(i)]=mygaussfit(1:USr ,USmean1(:,i));
            [Usigma2(i),UMu2(i),USA2(i)]=mygaussfit(1:USr ,USmean2(:,i));
        end
        for i=1:DSc
            [Dsigma1(i),DMu1(i),DSA1(i)]=mygaussfit(1:DSr ,DSmean1(:,i));
            [Dsigma2(i),DMu2(i),DSA2(i)]=mygaussfit(1:DSr ,DSmean2(:,i));
        end
        %figure(2);subplot(1,2,1);plot(1:USc,(UMu1+UMu2)./2,'k-');hold on;
        %subplot(1,2,2);plot(1:DSc,(DMu1+DMu2)./2,'k-');hold on;
% This is also the time to consider Rotating the images...    
    % Straignen based on centerline angle.
        USCL=(UMu1+UMu2)./2;
        [p1] = polyfit((USc-3):-1:1,USCL(2:(USc-2)),1);Ang1=-double(atan(p1(1))*180/pi());
            USmean1r=imrotate(USmean1,Ang1,'crop');
            USmean2r=imrotate(USmean2,Ang1,'crop');
        DSCL=(DMu1+DMu2)./2;
        [p2] = polyfit((DSc-3):-1:1,DSCL(2:(DSc-2)),1);Ang2=-double(atan(p2(1))*180/pi());
            DSmean1r=imrotate(DSmean1,Ang2,'crop');
            DSmean2r=imrotate(DSmean2,Ang2,'crop');
    % Run through Means, Fit Gaussians.
        for i=1:USc
            [Usigma1(i),UMu1(i),USA1(i)]=mygaussfit(1:USr ,USmean1r(:,i));
            [Usigma2(i),UMu2(i),USA2(i)]=mygaussfit(1:USr ,USmean2r(:,i));
        end
        for i=1:DSc
            [Dsigma1(i),DMu1(i),DSA1(i)]=mygaussfit(1:DSr ,DSmean1r(:,i));
            [Dsigma2(i),DMu2(i),DSA2(i)]=mygaussfit(1:DSr ,DSmean2r(:,i));
        end
%Find Centerlines
    UScent=trimmean((UMu1+UMu2)/2,10);
    DScent=trimmean((DMu1+DMu2)/2,10);
    
%If i wanted to automate Xshift calculation, here is the place. Do this by shifting sigma plots till they line up?        

%Note: need to rescale downstream stuff to match with the US stuff.
    DSscale1=trimmean(USA1( (1):(Xshift) ) ./ ...
                DSA1( (DSc-Xshift+1):(DSc) ) ,25);
    DSscale2=trimmean(USA2( (1):(Xshift) ) ./ ...
                DSA2( (DSc-Xshift+1):(DSc) ) ,25);
            
   % Put Regression stuff in matrix with Xvals, Sigma1s, Sigma2s
        %Note: Images are flippled LR, so the code has to run through
        %backwards
        RegStuff(1,:) = [USc:-1:1 (DSc:-1:1)+(USc-Xshift)];
        RegStuff(2,:) = [Usigma1 Dsigma1];
        RegStuff(3,:) = [Usigma2 Dsigma2];
        RegStuff(4,:) = [UMu1-UScent DMu1-DScent];
        RegStuff(5,:) = [UMu2-UScent DMu2-DScent];
        RegStuff(6,:) = [USA1 DSA1.*DSscale1];
        RegStuff(7,:) = [USA2 DSA2.*DSscale2];
        RegStuff=sortrows(RegStuff',1)';
        
L=length(RegStuff);


% IF you want to, you can image the means and std-devs on the image
% itself...
figure(1);clf;
subaxis(2,1,1);
    USXdat=[1,USc];USYdat=[1,USr]-UScent;
    imshow(ColorChangeWhite(fliplr(USmean1r)/max(USmean1r(:)),fliplr(USmean2r)/max(USmean2r(:))),'XData',USXdat,'YData',USYdat);hold on;
    DSXdat=[USc-Xshift+1,USc-Xshift+DSc];DSYdat=[1,DSr]-DScent;
    imshow(ColorChangeWhite(fliplr(DSmean1r)*DSscale1,fliplr(DSmean2r)*DSscale2),'XData',DSXdat,'YData',DSYdat);
        plot([0 2*USc],[0 0],'k-');
        plot(RegStuff(4,:),'k.');
        plot(RegStuff(5,:),'k.');
        plot(RegStuff(4,:)+RegStuff(2,:),'k.');
        plot(RegStuff(4,:)-RegStuff(2,:),'k.');
        plot(RegStuff(5,:)+RegStuff(3,:),'k.');
        plot(RegStuff(5,:)-RegStuff(3,:),'k.');hold off;
        axis([USXdat(1) DSXdat(2) USYdat(1) USYdat(2)]);

% (2) Match the 1/C profiles between scalars so there is symmetry DS
    midReg=(1./(RegStuff(6,:))+1./(RegStuff(7,:)))/2;
    %NewScale1=mean((1./RegStuff(6,i:L))./midReg(i:L));
    %NewScale2=mean((1./RegStuff(7,i:L))./midReg(i:L));

    %CLmax1=RegStuff(6,:)*NewScale1;
    %CLmax2=RegStuff(7,:)*NewScale2;
    %midReg=(1./CLmax1(:)+1./CLmax2(:))/2;

subaxis(2,1,2);
      % Plot Jet Spreading (Sigma) vs x values.    
        %plot(RegStuff(1,:),1./CLmax1(:),'r');hold on;
        %plot(RegStuff(1,:),1./CLmax2(:),'b')
        plot(RegStuff(1,:), midReg(:)  ,'g.');axis([1 length(midReg) 0 midReg(length(midReg))]);hold on;
    
% (1) Find VO using 1/C

        % Fit line to spreading data
        [po,So] = polyfit(RegStuff(1,:),midReg,1);
        %[p1,S1] = polyfit(RegStuff(1,:),1./CLmax1(1,:),1)
        %[p2,S2] = polyfit(RegStuff(1,:),1./CLmax2(1,:),1)
        %po=(p1+p2)./2;  
        
        % Calculate the errors
        [FitYs,delta] = polyval(po,RegStuff(1,:),So) ;
        OldVO=-po(2)/po(1);                                                % Virtual Origin is X-intercept
        
        plot(RegStuff(1,:),FitYs,'k-');
        plot(RegStuff(1,:),FitYs+delta,'k--');
        plot(RegStuff(1,:),FitYs-delta,'k--');
        
    
	% Loop through regression process.  Trim Data and refit untill VO isn't
	% changing much between loops. Note: This is a bit "handwavy" would be
	% better to go untill some definition of the linear region is met.
        error=1;
        
           while error>.01 
                % Find where line devates from linear regression.
                    if OldVO>1;
                        i=round(OldVO);
                    else
                        OldVO=find(midReg<(FitYs+delta),1,'first');
                    end
               
                %refit
                    [po,So] = polyfit(RegStuff(1,i:L),midReg(i:L),1);
                    [FitYs,delta] = polyval(po,RegStuff(1,:),So) ;
                    NewVO=-po(2)/po(1);
                                    
                error=abs(NewVO-OldVO);
                OldVO=NewVO;

                plot(RegStuff(1,:),FitYs,'k:');hold on;
                %[FitYs,delta] = polyval(po,RegStuff(1,:),So) ;
                %plot(RegStuff(1,:),FitYs+delta,'k--');
                %plot(RegStuff(1,:),FitYs-delta,'k--');
                %plot(RegStuff(1,:),midReg,'g');hold off;
                %error
                
                
           end
           
        VO=NewVO
        VOr=round(VO);
        
%Need to measure S (Distance between centers) at VO (+/-15 around VO?)
%load(['Vars/Eps' sprintf('%.3f', eps) '/VOetc' NAME],'S');
        %S=mean(abs(RegStuff(4,round(VO-15):round(VO+15))-RegStuff(5,round(VO-15):round(VO+15))));
        S=trimmean(abs(RegStuff(4,1:VOr)-RegStuff(5,1:VOr)),20)
        
%Make Setup Figure

        FigW=13.49414;
        FigH=21.08462*.4;

        set(0,'DefaultTextFontSize', 10)
        set(0,'DefaultTextFontname', 'Times New Roman')
        set(0,'DefaultAxesFontSize', 8)
        set(0,'DefaultAxesFontName','Times New Roman')


        Figure2=figure(2);clf;
            set(Figure2,'defaulttextinterpreter','latex')
            set(Figure2,'PaperUnits','centimeters','PaperSize',[FigW FigH],'PaperPosition',[0,0,FigW,FigH],...
            'Units','centimeters','Position',[1,9,FigW,FigH]);
    
        imshow(ColorChangeWhite(fliplr(USmean1r)/max(USmean1r(:)),fliplr(USmean2r)/max(USmean2r(:))),'XData',USXdat,'YData',USYdat);hold on;
        hold on;
            plot([1 2500],[S/2 S/2],'k--')
            plot([1 2500],[-S/2 -S/2],'k--')
            arrow([VOr/2,-S/2],[ VOr/2,S/2],'Ends','Both','Length',10)
            arrow([VOr,0],[VOr+100,0],'Length',10)
            arrow([VOr,0],[VOr,100],'Length',10)
            
            
            [figx,figy] = dsxy2figxy([VOr/2, VOr/2],[-S/2,S/2])
            annotation('doublearrow',figx,figy)
            [figx,figy] = dsxy2figxy([VOr, VOr+50],[0,0])
            annotation('arrow',figx,figy)
            [figx,figy] = dsxy2figxy([VOr, VOr],[0,50])
            annotation('arrow',figx,figy)
            [figx,figy] = dsxy2figxy([VOr, VOr+50],[0,0])
            annotation
%                    RegStuff(2,:) = [Usigma1 Dsigma1];
%               RegStuff(3,:) = [Usigma2 Dsigma2];

            %[po] = polyfit(RegStuff(1,VOr:L),RegStuff(2,VOr:L),1);
            %[FitYs] = polyval(po,RegStuff(1,VOr:L)) ;
            %plot(RegStuff(1,VOr:L),S/2+FitYs,'b:')
            %plot(RegStuff(1,VOr:L),S/2-FitYs,'b:')
            
            %[po] = polyfit(RegStuff(1,VOr:L),RegStuff(3,VOr:L),1);
            %[FitYs] = polyval(po,RegStuff(1,VOr:L)) ;
            %plot(RegStuff(1,VOr:L),-S/2+FitYs,'r:')
            %plot(RegStuff(1,VOr:L),-S/2-FitYs,'r:')
            
%Need to set S to 1 of 2 values.
load(['Vars/PreRunVars'],'Scale');
if S/Scale<2
    S=1.4*Scale;
else
    S=2.5*Scale;
end
%Rescale Files, find means
%% NOT DONE
% Need To Rescale X and Y data
    USXData=([USc 1]-VO)/S;
    USYData=(UScent-[1 USr])/S;
    DSXData=([USc-Xshift+DSc USc-Xshift]-VO)/S;
    DSYData=(DScent-[1 USr])/S;
    
% Rescale images based on potential core (US of the VO and 1/2 Std Devs
% away from the CL)
    Fmean1=fliplr(USmean1r);
        UpperBx1=trimmean(RegStuff(4,1:round(VO))+RegStuff(2,1:round(VO))/2,10);
        LowerBx1=trimmean(RegStuff(4,1:round(VO))-RegStuff(2,1:round(VO))/2,10);
        %imagesc(Fmean1(LowerBx1:UpperBx1,1:round(VO)))
        Fmean1=Fmean1(LowerBx1:UpperBx1,1:round(VO));
    USscale1=1/trimmean(Fmean1(:),10);
    
    Fmean2=fliplr(USmean2r);
        UpperBx2=trimmean(RegStuff(5,1:round(VO))+RegStuff(3,1:round(VO))/2,10);
        LowerBx2=trimmean(RegStuff(5,1:round(VO))-RegStuff(3,1:round(VO))/2,10);
        %imagesc(Fmean2(LowerBx2:UpperBx2,1:round(VO)))
        Fmean2=Fmean2(LowerBx2:UpperBx2,1:round(VO));
    USscale2=1/trimmean(Fmean2(:),10);
    
%Once rescaled, slightly adjust for symmetry DS
MeanReg=(RegStuff(6,:).*USscale1+RegStuff(7,:).*USscale2)/2;
Adjust1=trimmean(MeanReg./(RegStuff(6,:).*USscale1),10);
Adjust2=trimmean(MeanReg./(RegStuff(7,:).*USscale2),10);

USscale1.*Adjust1
USscale2.*Adjust2

RescaleProcessedImgs(USstart, USstop, USscale1.*Adjust1, USscale2.*Adjust2)
FindMeanE('',USstart, USstop,eps);
RescaleProcessedImgs(DSstart, DSstop, USscale1*DSscale1.*Adjust1, USscale2*DSscale2.*Adjust2)
FindMeanE('',DSstart, DSstop,eps);

USycent=UScent;
DSycent=DScent;
Yshift=round(USycent-DSycent);
CLshift=Yshift; %what?
save(['Vars/Eps' sprintf('%.3f', eps) '/VOetc' NAME],'VO', 'S', 'USXData','DSXData','USYData','DSYData','Ang1','Ang2', 'USycent','DSycent','Yshift','CLshift');

%FlipMean1=fliplr(USmean1);
%for i=2:1*VO
%    MidVec1(i)=mean(FlipMean1(round(RegStuff(4,i)-5):round(RegStuff(4,i)+5),i))
%end