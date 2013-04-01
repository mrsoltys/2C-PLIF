function [ Lambda1, Lambda2 ] = FindLambdaSSE(Direct, Start, Stop, BackStart, BackStop)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%[ Lambda1, Lambda2 ] = FindLambdaSSE(Direct, Start, Stop, BackStart, BackStop)
%
% Updated 12/01/12 to lower the threshold used in calculating lambda
%
disp(['Finding Lambda Using Imgs ' int2str(Start) '-' int2str(Stop)]);

%Initialize empty Lambdas Vector
    Lambdas1=[];
    Lambdas2=[];
    NanCorr1=0;
    NanCorr2=0;    
    Thresh=.999; %Thresh has been everywhere between .96 and .99

% Load Background Images
    load([Direct 'Vars/TransAvg' BackStart])
        B1a=I1; B2a=I2;
    load([Direct 'Vars/transAvg' BackStop])
        B1b=I1; B2b=I2;

% Load Dark Response
    load([Direct 'Vars/TransAvgDark'], 'I1', 'I2');
        D1=I1; D2=I2;

%% Find Lambda for Each Individual Image

for i=Start:Stop
    %Initialize empty Lambda Vectors    
        L1=[]; L2=[]; C2m=[]; C1m=[];
    
    % Load Imgs
        load([Direct 'TransImgs/Trans'  sprintf('%05d', i)],'I1','I2');

    % Convert to Double
        I1=double( I1 );
        I2=double( I2 );
%         subaxis(1,2,1);
%             imagesc(I1);axis image;title('Camera1');colorbar('Location','SouthOutside');
%         subaxis(1,2,2);
%             imagesc(I2);axis image;title('Camera2');colorbar('Location','SouthOutside');            
%         pause;
    % Calc Background for image i
        B1=B1a*(Stop-i)/(Stop-Start) + B1b*(i-Start)/(Stop-Start);
        B2=B2a*(Stop-i)/(Stop-Start) + B2b*(i-Start)/(Stop-Start);
        
    % Find Threshold values for each image
        % Histogram with 200 Bins
        [n,xout]=hist(I1(:),200);
        HiThresh1 =0;
        % Find Thresh(th) percentile (99.9th)
        for j=1:length(n)
            Perc = sum(n(1:j))/sum(n);
            if     (Perc>Thresh && HiThresh1==0) 
                HiThresh1=xout(j);
                break;
            end
        end

        %repeat for image 2
        [n,xout]=hist(I2(:),200);
        HiThresh2 =0;
        for j=1:length(n)
            Perc = sum(n(1:j))/sum(n);
            if     (Perc>Thresh && HiThresh2==0)
                HiThresh2=xout(j);
                break;
            end
        end    
        
        %Low Threshold should fall somewhere between the noise in the
        %background (Mean+3.290527?) = 99.9% outside of noise and the 99.9%
        %of maximum in the image. For now, I'll put it halfway between, but
        %it might be better somewhere closer to the noise than the maximum.
        LowThresh1=(3*(mean2(B1)+3.3*std2(B1))+HiThresh1)/4;
        LowThresh2=(3*(mean2(B2)+3.3*std2(B2))+HiThresh2)/4;
        
        %Make filter matrix that is 1 everywhere that I1>LowThresh and NaN
        %everywhere else.
        filter1=double(I1>LowThresh1)./((I1>LowThresh1)~=0).*double(I1<HiThresh1)./((I1<HiThresh1)~=0);     
        filter2=double(I2>LowThresh2)./((I2>LowThresh2)~=0).*double(I2<HiThresh2)./((I2<HiThresh2)~=0);  
%         subaxis(1,2,1);
%             imagesc(filter1);axis image;title('filter1');colorbar('Location','SouthOutside');
%         subaxis(1,2,2);
%             imagesc(filter2);axis image;title('filter2');colorbar('Location','SouthOutside');            
%         pause;

        %Note: I should make it so if the filters both contain 1's in
            %the same pixel (overlap?) it removes those points (sets to
            %nans)
       % Overlap=double(( (filter1+filter2)>0 )==0 )./...
       %         double(( (filter1+filter2)>0 )==0 );
       % filter1=filter1.*Overlap;
       % filter2=filter2.*Overlap;

%% Find Lambda1.  Check to see if this is a picture from Camera1 or Camera 2 
%    by comparing the image to the mean? Is there a better way to do this?         
       % if( ( mean2(I1) > (mean2(B1)-3*std2(B1)) ) && ( mean2(I1)< (mean2(B1)+3*std2(B1)) ) )
        if( ( (mean2(I1)+.5*std2(I1)) > (mean2(B1)-3*std2(B1)) ) && ( (mean2(I1)+.5*std2(I1))< (mean2(B1)+3*std2(B1)) ) )
            % if the image is a blank (the mean  +- 2 std dev of
            % the back mean) then skip it and set the Lambda to zero
            L1=NaN;
        else
            % The image is not a blank
%                 Cb2=(B2-B2)./...
%                     (B2-D2).*...
%                     filter1;

                %First calculate with Lambda1=0
                L1(1)=0;
                C2=(I2-B2)./...
                    (B2-D2).*...
                    filter1;
                C2(isnan(C2))=0; %get rid of NaNs
                C2m(1)=sum(sum(C2.^2));
                %[n xout]=hist(C2(:),100);
                %C2m(1)=(sum(n.*xout) / sum(n))^2;
                
                %calculate with Lambda1=0.01
                L1(2)=.001;
                C2=(I2-B2-L1(2)*(I1-B1))./...
                   (B2-D2-L1(2)*(B1-D1)).*...
                   filter1;
                C2(isnan(C2))=0; %get rid of NaNs
                C2m(2)=sum(sum(C2.^2));
%                 [n xout]=hist(C2(:),100);
%                 C2m(2)=(sum(n.*xout) / sum(n) )^2;
                
                %%calculate with Lambda1=-0.01
                L1(3)=-.001;  
                C2=(I2-B2-L1(3)*(I1-B1))./...
                   (B2-D2-L1(3)*(B1-D1)).*...
                   filter1;
                C2(isnan(C2))=0; %get rid of NaNs
                C2m(3)=sum(sum(C2.^2));
%                 [n xout]=hist(C2(:),100);
%                 C2m(3)=(sum(n.*xout) / sum(n))^2;
                
            % Set Index for While Loop    
            j=3;
           
            %loop while the sse is greater than some acceptable value, but
            %no more than 30 iterations
            while(abs(L1(j)-L1(j-1))>(1e-6) && j<30)
                %Increment
                    j=j+1;
                %Interpolate next guess
                    Reg=polyfit(L1,C2m,2);
                        %         Reg(1)*x^2+Reg(2)*x+Reg(3)
                        %d/dx = 2*Reg(1)*x  + Reg(2) = 0
                    L1(j)=(-Reg(2)/(2*Reg(1)));
                    
                %Evaluate performance                
                    C2=(I2-B2-L1(j)*(I1-B1))./...
                       (B2-D2-L1(j)*(B1-D1)).*...
                       filter1;
                C2(isnan(C2))=0; %get rid of NaNs
                C2m(j)=sum(sum(C2.^2));
%                     [n xout]=hist(C2(:),100);
%                     C2m(j)=(sum(n.*xout) / sum(n))^2;
            %        plot(L1,C2m,'*');hold on;
            %        plot(L1,polyval(Reg,L1),'k*');hold off;
            end

            L1=L1(j);
        end

  %% Find Lambda2
        
        %if( ( mean2(I2) > (mean2(B2)-3*std2(B2)) ) && ( mean2(I2)< (mean2(B2)+3*std2(B2)) ) )
        if( ( (mean2(I2)+.5*std2(I2)) > (mean2(B2)-3*std2(B2)) ) && ( (mean2(I2)+.5*std2(I2))< (mean2(B2)+3*std2(B2)) ) )
            % if the image is a blank (the mean  +- 2 std dev of
            % the back mean) then skip it and set the Lambda to zero
            L2=NaN;
        else
            % The image is not a blank
            % Find Lambda 0 value
                L2(1)=0;
                C1=(I1-B1)./...
                    (B1-D1).*...
                    filter2;
                C1(isnan(C1))=0; %get rid of NaNs
                C1m(1)=sum(sum(C1.^2));
                [n xout]=hist(C1(:),100);
                C1m(2)=(sum(n.*xout) / sum(n) )^2;
                
             L2(2)=.001;
                C1=(I1-B1-L2(2)*(I2-B2))./...
                   (B1-D1-L2(2)*(B2-D2)).*...
                   filter2;
                C1(isnan(C1))=0; %get rid of NaNs
                C1m(2)=sum(sum(C1.^2));
%                 [n xout]=hist(C1(:),100);
%                 C1m(2)=(sum(n.*xout) / sum(n) )^2;
                
                L2(3)=-.001;                
                C1=(I1-B1-L2(3)*(I2-B2))./...
                   (B1-D1-L2(3)*(B2-D2)).*...
                   filter2;
                C1(isnan(C1))=0; %get rid of NaNs
                C1m(3)=sum(sum(C1.^2));
               
%                 [n xout]=hist(C1(:),100);
%                 C1m(2)=(sum(n.*xout) / sum(n) )^2;
                

            % Set Index for While Loop    
            j=3;
            while(abs(L2(j)-L2(j-1))>(1e-6) && j<30)
                %Increment
                    j=j+1;
                %Interpolate next guess
                    Reg=polyfit(L2,C1m,2);
                    L2(j)=(-Reg(2)/(2*Reg(1)));
                    
                %Evaluate performance                
                    C1=(I1-B1-L2(j)*(I2-B2))./...
                       (B1-D1-L2(j)*(B2-D2)).*...
                       filter2;
                C1(isnan(C1))=0; %get rid of NaNs
                C1m(j)=sum(sum(C1.^2));
%               [n xout]=hist(C1(:),100);
%               C1m(2)=(sum(n.*xout) / sum(n) )^2;
                   % plot(L2,C1m,'*')
            end
            L2=L2(j);

        end
        %% Save how many Lambda values were found for this image
         if isfinite(L1)
            Lambdas1(i-Start+1-NanCorr1) = L1;
         else
            NanCorr1=NanCorr1+1;
         end
        if isfinite(L2)
            Lambdas2(i-Start+1-NanCorr2) = L2;
         else
            NanCorr2=NanCorr2+1;
         end
            
        
        %Display Progress
            %stopBar= 
            progressbar((i-Start+1)/(Stop-Start+1),5);
            %if (stopBar) break; end

end
Lambda1=trimmean(Lambdas1,20)
Lambda2=trimmean(Lambdas2,20)

save([Direct 'Vars/Lambdas' sprintf('%05d', Stop)],'-v7.3','Lambda1','Lambda2','Lambdas1','Lambdas2');
%save([Direct 'Vars/Iscales' sprintf('%05d', Stop)], 'I1Scale', 'I2Scale');

            
%% Check
%    subplot(2,2,1);imagesc(I1-B1);axis image;caxis([0 1000]);
%    subplot(2,2,3);imagesc(I2-B2);axis image;caxis([0 1000]);
%    subplot(2,2,2);imagesc((I1-B1-Mu2*(I2-B2)));axis image;caxis([0 1000]);
%    subplot(2,2,4);imagesc((I2-B2-Mu1*(I1-B1)));axis image;caxis([0 1000]);
