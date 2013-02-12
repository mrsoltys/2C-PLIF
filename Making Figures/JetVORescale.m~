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
                USRMSE1=RMSE1;USRMSE2=RMSE2;
                [USr USc]=size(mean1);
            load(['Vars/Eps' sprintf('%.3f', eps) '/CovE' USMeanName]);
                USC1C2=C1C2;USCov=Cov;
            %load(['Vars/Eps' sprintf('%.3f', eps) '/RMSEe' USMeanName]);
                

    % Load DS stats;
        DSMeanName=[ sprintf('%05d', DSstart) '-'  sprintf('%05d', DSstop)];
            load(['Vars/Eps' sprintf('%.3f', eps) '/ProcMeansE' DSMeanName]);
                DSmean1=mean1;DSmean2=mean2;
                DSRMSE1=RMSE1;DSRMSE2=RMSE2;
                [DSr DSc]=size(mean1);
            load(['Vars/Eps' sprintf('%.3f', eps) '/CovE' DSMeanName]);
                DSC1C2=C1C2;DSCov=Cov;
          %  load(['Vars/Eps' sprintf('%.3f', eps) '/RMSEe' DSMeanName]);
               
                
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
%Find Centerlines
    UScent=trimmean((UMu1+UMu2)/2,10)
    DScent=trimmean((DMu1+DMu2)/2,10)
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
        
L=length(RegStuff);

% (2) Match the 1/C profiles between scalars so there is symmetry DS
    midReg=(1./RegStuff(6,:)+1./RegStuff(7,:))/2;
    NewScale1=mean((1./RegStuff(6,i:L))./midReg(i:L));
    NewScale2=mean((1./RegStuff(7,i:L))./midReg(i:L));

    CLmax1=RegStuff(6,:)*NewScale1;
    CLmax2=RegStuff(7,:)*NewScale2;
    midReg=(1./CLmax1(:)+1./CLmax2(:))/2;

% (1) Find VO using 1/C
   % Plot Jet Spreading (Sigma) vs x values.    
        figure(1);clf;plot(RegStuff(1,:),1./CLmax1(:),'r');hold on;
        plot(RegStuff(1,:),1./CLmax2(:),'b')
        plot(RegStuff(1,:), midReg(:)  ,'g')
        
    % Fit line to spreading data
        [p1,S1] = polyfit(RegStuff(1,:),1./CLmax1(1,:),1)
        [p2,S2] = polyfit(RegStuff(1,:),1./CLmax2(1,:),1)
        po=(p1+p2)./2;                                                     % Average both lines, their VO should be the same
        FitYs=po(1).*RegStuff(1,:)+po(2);
        OldVO=-po(2)/po(1);                                                % Virtual Origin is X-intercept
       
        plot(RegStuff(1,:),FitYs,'k');
    
	% Loop through regression process.  Trim Data and refit untill VO isn't
	% changing much between loops. Note: This is a bit "handwavy" would be
	% better to go untill some definition of the linear region is met.
        error=1
        
           while error>.01 
                % Find where line devates from linear regression.
                % Currently this is done by finding the point where the
                % line first intersects the average of the two widths

                i=1;
                while i<=L && (abs( midReg(i) - FitYs(i) )./midReg(i) > .5)      
                    i=i+1;
                end
                i ;   

                %Rescale (3) I'd like the Concentration @ the VO ~=1 for both scalars
                if OldVO>=6
                    NewScale=mean(midReg( round(OldVO-5):round(OldVO+5)))
                else
                    NewScale=mean(midReg( 1:6))
                end
                CLmax1(:)=CLmax1(:)*NewScale;
                CLmax2(:)=CLmax2(:)*NewScale;
                midReg=(1./CLmax1(:)+1./CLmax2(:))/2;
                
                %refit
                    [p1,S1] = polyfit(RegStuff(1,i:L),1./CLmax1(i:L),1);
                    [p2,S2] = polyfit(RegStuff(1,i:L),1./CLmax2(i:L),1);
                        po=(p1+p2)./2;
                    FitYs=po(1).*RegStuff(1,:)+po(2);
                    NewVO=-po(2)/po(1)
                
                error=abs(NewVO-OldVO);
                OldVO=NewVO;

                %plot(RegStuff(1,:),FitYs,'k');
                

           end
           
        VO=NewVO
        
%Rescale Files, find means
%% NOT DONE
% Need To Rescale X data (Note, for now not changing S or Y data
load(['Vars/Eps' sprintf('%.3f', eps) '/VOetc' NAME],'S');
USXData=([USc 1]-VO)/S;
USYData=(UScent-[1 USr])/S;
DSXData=([USc-Xshift+DSc USc-Xshift]-VO)/S;
DSYData=(DScent-[1 USr])/S;
    
% Rescale US images based on A1, A2
Scale1=mean(CLmax1./RegStuff(6,:));
Scale2=mean(CLmax2./RegStuff(7,:));
RescaleProcessedImgs(USstart, USstop, Scale1, Scale2)
FindMeanE('',USstart, USstop,eps);
RescaleProcessedImgs(DSstart, DSstop, Scale1, Scale2)
FindMeanE('',DSstart, DSstop,eps);

save(['Vars/Eps' sprintf('%.3f', eps) '/VOetc' NAME],'VO', 'USXData','DSXData','USYData','DSYData','-append');