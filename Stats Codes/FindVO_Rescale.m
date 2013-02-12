function [VO S] = FindVO_Rescale(USstart, USstop, DSstart, DSstop, eps, Xshift,Expon, NAME)

    % Load US stuff
        mean2=[];

        USMeanName=[ sprintf('%05d', USstart) '-'  sprintf('%05d', USstop)];
            load(['Vars/Eps' sprintf('%.3f', eps) '/ProcMeansE' USMeanName]);
                USmean1=mean1;USmean2=mean2;
                [USr USc]=size(mean1);
                USRMSE1=RMSE1;USRMSE2=RMSE2;
            load(['Vars/Eps' sprintf('%.3f', eps) '/CovE' USMeanName]);
                USC1C2=C1C2;USCov=Cov;
            %load(['Vars/Eps' sprintf('%.3f', eps) '/RMSEe' USMeanName]);
                

    % Load DS stats;
        DSMeanName=[ sprintf('%05d', DSstart) '-'  sprintf('%05d', DSstop)];
            load(['Vars/Eps' sprintf('%.3f', eps) '/ProcMeansE' DSMeanName]);
                DSmean1=mean1;DSmean2=mean2;
                [DSr DSc]=size(mean1);
                DSRMSE1=RMSE1;DSRMSE2=RMSE2;
            load(['Vars/Eps' sprintf('%.3f', eps) '/CovE' DSMeanName]);
                DSC1C2=C1C2;DSCov=Cov;
            %load(['Vars/Eps' sprintf('%.3f', eps) '/RMSEe' DSMeanName]);
             
                
    % Run through Means, Fit Gaussians.
        for i=1:USc
            [Usigma1(i),UMu1(i),USA1(i)]=mygaussfit(1:USr ,USmean1(:,i));
            [Usigma2(i),UMu2(i),USA2(i)]=mygaussfit(1:USr ,USmean2(:,i));
        end
        for i=1:DSc
            [Dsigma1(i),DMu1(i),DSA1(i)]=mygaussfit(1:DSr ,DSmean1(:,i));
            [Dsigma2(i),DMu2(i),DSA2(i)]=mygaussfit(1:DSr ,DSmean2(:,i));
        end
        figure(2);subplot(1,2,1);plot(1:USc,(UMu1+UMu2)./2,'k-');hold on;
        subplot(1,2,2);plot(1:DSc,(DMu1+DMu2)./2,'k-');hold on;
% This is also the time to consider Rotating the images...    
% Fit line to centerline data
        USCL=(UMu1+UMu2)./2;
        [p1,S1] = polyfit((USc-3):-1:1,USCL(2:(USc-2)),1);Ang1=-double(atan(p1(1))*180/pi());
            USmean1r=imrotate(USmean1,Ang1,'crop');
            USmean2r=imrotate(USmean2,Ang1,'crop');
        DSCL=(DMu1+DMu2)./2;
        [p2,S2] = polyfit((DSc-3):-1:1,DSCL(2:(DSc-2)),1);Ang2=-double(atan(p2(1))*180/pi());
            DSmean1r=imrotate(DSmean1,Ang2,'crop');
            DSmean2r=imrotate(DSmean2,Ang2,'crop');
            
        for i=1:USc
            [Usigma1(i),UMu1(i),USA1(i)]=mygaussfit(1:USr ,USmean1r(:,i));
            [Usigma2(i),UMu2(i),USA2(i)]=mygaussfit(1:USr ,USmean2r(:,i));
        end
        for i=1:DSc
            [Dsigma1(i),DMu1(i),DSA1(i)]=mygaussfit(1:DSr ,DSmean1r(:,i));
            [Dsigma2(i),DMu2(i),DSA2(i)]=mygaussfit(1:DSr ,DSmean2r(:,i));
        end
        subplot(1,2,1);plot(1:USc,(UMu1+UMu2)./2,'k--');hold off;
        subplot(1,2,2);plot(1:DSc,(DMu1+DMu2)./2,'k--');hold off;
%If i wanted to automate Xshift calculation, here is the place. Do this by shifting sigma plots till they line up?        
        
   % Put Regression stuff in matrix with Xvals, Sigma1s, Sigma2s
        %Note: Images are flippled LR, so the code has to run through
        %backwards
        RegStuff(1,:) = [USc:-1:1 (DSc:-1:1)+(USc-Xshift)];
        RegStuff(2,:) = [Usigma1 Dsigma1];
        RegStuff(3,:) = [Usigma2 Dsigma2];
        RegStuff(4,:) = [UMu1 DMu1];
        RegStuff(5,:) = [UMu2 DMu2];
        RegStuff(6,:) = [USA1 DSA1];
        RegStuff(7,:) = [USA2 DSA2];
        RegStuff=sortrows(RegStuff',1)';
        
%Find VO            
   % Plot Jet Spreading (Sigma) vs x values.    
        clf
        figure(1);plot(RegStuff(1,:),RegStuff(2,:),'b');hold on;
        plot(RegStuff(1,:),RegStuff(3,:),'r')
        
    % Fit line to spreading data
        [p1,S1] = polyfit(RegStuff(1,:),RegStuff(2,:),1)
        [p2,S2] = polyfit(RegStuff(1,:),RegStuff(3,:),1)
        po=(p1+p2)./2;                                                     % Average both lines, their VO should be the same
        FitYs=po(1).*RegStuff(1,:)+po(2);
        OldVO=-po(2)/po(1);                                                % Virtual Origin is X-intercept
       
        plot(RegStuff(1,:),FitYs,'k');
    
	% Loop through regression process.  Trim Data and refit untill VO isn't
	% changing much between loops. Note: This is a bit "handwavy" would be
	% better to go untill some definition of the linear region is met.
        error=1
        L=length(RegStuff);
           while error>.01 
                % Find where line devates from linear regression.
                % Currently this is done by finding the point where the
                % line first intersects the average of the two widths
                i=1;
                while i<=L && (abs( ((RegStuff(2,i)+RegStuff(3,i))/2) - FitYs(i) ) > 1)      
                    i=i+1;
                end
                    
                %refit
                    [p1,S1] = polyfit(RegStuff(1,i:L),RegStuff(2,i:L),1);
                    [p2,S2] = polyfit(RegStuff(1,i:L),RegStuff(3,i:L),1);
                        po=(p1+p2)./2;
                    FitYs=po(1).*RegStuff(1,:)+po(2);
                    NewVO=-po(2)/po(1)
                
                error=abs(NewVO-OldVO);
                OldVO=NewVO;

                plot(RegStuff(1,:), ((RegStuff(2,:)+RegStuff(3,:))/2) - FitYs ,'g')
                % SSerr=sum( ( ( ( RegStuff(2,i:L)+RegStuff(3,i:L) )/2 ) - FitYs(i:L) ).^2 )
                % SStot=sum( ( ( ( RegStuff(2,i:L)+RegStuff(3,i:L) )/2 ) - mean( ( RegStuff(2,i:L)+RegStuff(3,i:L) )/2 ) ).^2 )
                % rsq=1-SSerr/SStot
                plot(RegStuff(1,:),FitYs,'k');

           end
           
VO=NewVO

% Find S: Note: S is calculated at +/- 10 pixels from VO. 
        if VO<11
            [sigma1,Mu1,A1]=mygaussfit(1:USr,mean(USmean1r(:,round(USc-20):USc),2));
            [sigma2,Mu2,A2]=mygaussfit(1:USr,mean(USmean2r(:,round(USc-20):USc),2));
        else
            [sigma1,Mu1,A1]=mygaussfit(1:USr,mean(USmean1r(:,round(USc-VO-10):round(USc-VO+10)),2));
            [sigma2,Mu2,A2]=mygaussfit(1:USr,mean(USmean2r(:,round(USc-VO-10):round(USc-VO+10)),2));
        end
% This is how i used to scale the images, but this is only the peak of a 
% gaussian fit 10 pixels left and right of the means. Why is that bad? I'm
% not sure, but the PDFs don't fall on 1 with this scaling, which is
% annoying. (more like .9).
%USscale1=A1;
%USscale2=A2;
% So now i'm going to do it based on a 10 x 10 pixel box around the mean
USscale1=mean(mean(USmean1(round(Mu1-10):round(Mu1+10),round(USc-VO-10):round(USc-VO+10))))
USscale2=mean(mean(USmean2(round(Mu2-10):round(Mu2+10),round(USc-VO-10):round(USc-VO+10))))
        
S=abs(Mu1-Mu2)-(sigma1+sigma2) %Note, S is now distance BETWEEN filaments, not C to C
CLshift=(sigma1+sigma2)/2; %Use this to get to jet CLs

% Find  y centerline
    [sigma1,Mu1,A1]=mygaussfit(1:USr,mean(USmean1r(:,round(1*USc/4):round(3*USc/4)),2));
    [sigma2,Mu2,A2]=mygaussfit(1:USr,mean(USmean2r(:,round(1*USc/4):round(3*USc/4)),2));
USycent=(Mu1+Mu2)/2;
    [sigma1,Mu1,A1]=mygaussfit(1:DSr,mean(DSmean1r(:,round(1*DSc/4):round(3*DSc/4)),2));
    [sigma2,Mu2,A2]=mygaussfit(1:DSr,mean(DSmean2r(:,round(1*DSc/4):round(3*DSc/4)),2));
DSycent=(Mu1+Mu2)/2;
Yshift=round(USycent-DSycent);

USXData=([USc 1]-VO)/S;
USYData=(USycent-[1 USr])/S;
DSXData=([USc-Xshift+DSc USc-Xshift]-VO)/S;
DSYData=(DSycent-[1 USr])/S;
    
% Rescale US images based on A1, A2
RescaleProcessedImgs(USstart, USstop, 1/USscale1, 1/USscale2)
FindMeanE('',USstart, USstop,eps);

% Rescale DS images

    % Calculate Scaling
    DSscale1=trimmean(USA1( (1):(Xshift) ) ./ ...
                DSA1( (DSc-Xshift+1):(DSc) ) ,25);
    DSscale2=trimmean(USA2( (1):(Xshift) ) ./ ...
                DSA2( (DSc-Xshift+1):(DSc) ) ,25);
    
RescaleProcessedImgs(DSstart, DSstop, DSscale1/USscale1, DSscale2/USscale2)
FindMeanE('',DSstart, DSstop,eps);

save(['Vars/Eps' sprintf('%.3f', eps) '/VOetc' NAME],'VO','S','USycent','DSycent','Yshift','USXData','USYData','DSXData','DSYData','CLshift','Ang1','Ang2');
    
    

