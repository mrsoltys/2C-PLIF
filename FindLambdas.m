function [ Lambda1, Lambda2 ] = FindLambdas(Direct, Start, Stop, BackStart, BackStop)

disp(['Finding Lambda Using Imgs ' int2str(Start) '-' int2str(Stop)]);

%Initialize empty Lambdas Vector
    Lambdas1=[];
    Lambdas2=[];
    L1ind=1;
    L2ind=1;    
    Thresh=.99; %Thresh has been everywhere between .96 and .99

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
        
    % Calc Background for image i
        B1=B1a*(Stop-i)/(Stop-Start) + B1b*(i-Start)/(Stop-Start);
        B2=B2a*(Stop-i)/(Stop-Start) + B2b*(i-Start)/(Stop-Start);
        
    % Find Threshold values for each image
        % Histogram with 200 Bins
        [n,xout]=hist(I1(:),100);
        LowThresh1 =0;
        % Find Thresh(th) percentile (.98 or .99 works well)
        for j=1:length(n)
            Perc = sum(n(1:j))/sum(n);
            if     (Perc>Thresh && LowThresh1==0) 
                LowThresh1=xout(j);
                break;
            end
        end

        %repeat for image 2
        [n,xout]=hist(I2(:),100);
        LowThresh2 =0;
        for j=1:length(n)
            Perc = sum(n(1:j))/sum(n);
            if     (Perc>Thresh && LowThresh2==0)
                LowThresh2=xout(j);
                break;
            end
        end    
        
        %Make filter matrix that is 1 ev
        filter1=double(I1>LowThresh1)./((I1>LowThresh1)~=0);     
        filter2=double(I2>LowThresh2)./((I2>LowThresh2)~=0);   
            %Note: I should make it so if the filters both contain 1's in
            %the same pixel (overlap?) it removes those points (sets to
            %nans)
        Overlap=filter1.*filter2;
        filter1(Overlap==1)=NaN;
        filter2(Overlap==1)=NaN;
    %% Find Lambda1         
        if( mean2(I1)< (mean2(B1)+2*std2(B1)) )
            % if the image is a blank (the mean < +2 std dev of
            % the back mean) then skip it and set the Lambda to zero
            L1=NaN;
        else % The image is not a blank
              
                %First calculate with Lambda1=0
               
                L1(1)=0;
                C2=(I2-B2)./...
                   (B2-D2).*...
                   filter1;
                [n xout]=hist(C2(:),200);
                C2m(1)=(sum(n.*xout) / sum(n));%^2;  %Get the mean of the current PDF.  Trying to center mean at zero
                
                %calculate with Lambda1=0.01
                L1(2)=.01;
                C2=(I2-B2-L1(2)*(I1-B1))./...
                   (B2-D2-L1(2)*(B1-D1)).*...
                   filter1;
                [n xout]=hist(C2(:),200);
                C2m(2)=(sum(n.*xout) / sum(n) );%^2;
                
                %%calculate with Lambda1=-0.01
                L1(3)=-.01;  
                C2=(I2-B2-L1(3)*(I1-B1))./...
                   (B2-D2-L1(3)*(B1-D1)).*...
                   filter1;
                [n xout]=hist(C2(:),200);
                C2m(3)=(sum(n.*xout) / sum(n));%^2;
                
            % Set Index for While Loop    
            j=3;
           
            %loop while the sse is greater than some acceptable value, but
            %no more than 30 iterations
            while(abs(C2m(j))>.001 && j<30)
                %Increment
                    j=j+1;
                %Interpolate next guess
                    Reg=polyfit(L1,C2m,1);
                    L1(j)=-Reg(2)/Reg(1);
                    
                %Evaluate performance                
                    C2=(I2-B2-L1(j)*(I1-B1))./...
                       (B2-D2-L1(j)*(B1-D1)).*...
                       filter1;
                    [n xout]=hist(C2(:),200);
                    C2m(j)=(sum(n.*xout) / sum(n));%^2;
                    %plot(L1,C2m,'*');
            end

            L1=L1(j);
        end

  %% Find Lambda2
        
        if( ( mean2(I2) > (mean2(B2)-std2(B2)) ) && ( mean2(I2)< (mean2(B2)+std2(B2)) ) )
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
                [n xout]=hist(C1(:),200);
                C1m(1)=sum(n.*xout)/sum(n);
                
             L2(2)=.01;
                C1=(I1-B1-L2(2)*(I2-B2))./...
                   (B1-D1-L2(2)*(B2-D2)).*...
                   filter2;
                [n xout]=hist(C1(:),200);
                C1m(2)=(sum(n.*xout) / sum(n) );%^2;
                
                L2(3)=-.01;                
                C1=(I1-B1-L2(3)*(I2-B2))./...
                   (B1-D1-L2(3)*(B2-D2)).*...
                   filter2;
                [n xout]=hist(C1(:),200);
                C1m(3)=(sum(n.*xout) / sum(n) );%^2;
                
            % Set Index for While Loop    
            j=3;
            while(abs(C1m(j))>.001 && j<30)
                %Increment
                    j=j+1;
                %Interpolate next guess
                    Reg=polyfit(L2,C1m,1);
                    L2(j)=-Reg(2)/Reg(1);
                    
                %Evaluate performance                
                    C1=(I1-B1-L2(j)*(I2-B2))./...
                       (B1-D1-L2(j)*(B2-D2)).*...
                       filter2;
                    [n xout]=hist(C1(:),200);
                    C1m(j)=(sum(n.*xout) / sum(n));%^2;
                    %plot(L2,C1m,'*');
            end
            L2=L2(j);

        end
        %% Save how many Lambda values were found for this image
         if isfinite(L1)
            Lambdas1(L1ind) = L1;
            L1ind=L1ind+1;
         end
        if isfinite(L2)
            Lambdas2(L2ind) = L2;
            L2ind=L2ind+1;
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
