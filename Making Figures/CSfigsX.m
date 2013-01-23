function [VO CSxdat CSmean1 CSmean2 CSs CSrho CSc1c2 CScov] = CSfigs(USstart, USstop, DSstart, DSstop, eps, Xshift,Expon, NAME)
BS=10
load(['Vars/Eps' sprintf('%.3f', eps) '/VOetc' NAME],'VO','S','USycent','DSycent','Yshift','USXData','USYData','DSXData','DSYData');
    % Load US stuff
        mean2=[];

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
        
     %Find Rho
        USrho=USCov./(USRMSE1.*USRMSE2);        
        DSrho=DSCov./(DSRMSE1.*DSRMSE2);        
    % Find S
        USs=USCov./(USmean1.*USmean2);
        DSs=DSCov./(DSmean1.*DSmean2);
        
 % Create vectors relating Normailzed coordnates to pixel indicies
    XDatUS=linspace(USXData(1), USXData(2), USc); 
    XDatDS=linspace(DSXData(1), DSXData(2), DSc);
    YDatUS=linspace(USYData(1), USYData(2), USr); 
    YDatDS=linspace(DSYData(1), DSYData(2), DSr);
        
  Xpts=0:3:12 % Note: The index of XData closest to the points is the easiest conversion, Need some way oto distinguish between upstream and downstreamfo
  % Initialize PDF point matricies
        if Xpts(length(Xpts))<((USXData(1)+DSXData(2))/2)
            USptsL=length(Xpts);
        else
            USptsL=find(Xpts>((USXData(1)+DSXData(2))/2),1,'first')-1;
        end
        PDFptsUS=zeros(5,USptsL,2);
        PDFptsDS=zeros(5,length(Xpts)-USptsL,2);

    for i=1:length(Xpts)
        if i<=USptsL
            % Find the real pixel of the X point
            if USXData(2) > Xpts(i) % Need Check to see if the VO is on the screen.
                Col=floor(USc-BS/2);
            else
                Col=find(XDatUS < Xpts(i),1,'first');
            end
            %Find the gaussian

            % Bin means 
                [mean1Bin BinYs]   = AverageBins( mean( USmean1(:,ceil(Col-BS/2):floor(Col+BS/2)) , 2 ) ,YDatUS,BS);
                [mean2Bin BinYs]   = AverageBins( mean( USmean2(:,ceil(Col-BS/2):floor(Col+BS/2)) , 2 ) ,YDatUS,BS);
                CSmean1(i,:)=mean1Bin;
                CSmean2(i,:)=mean2Bin;
                CSys(i,:)   =BinYs;
                
            % Bin rms 
                [RMSE1Bin BinYs]   = AverageBins( mean( USRMSE1(:,ceil(Col-BS/2):floor(Col+BS/2)) , 2 ) ,YDatUS,BS);
                [RMSE2Bin BinYs]   = AverageBins( mean( USRMSE2(:,ceil(Col-BS/2):floor(Col+BS/2)) , 2 ) ,YDatUS,BS);
                CSrms1(i,:)=RMSE1Bin;
                CSrms2(i,:)=RMSE2Bin;

            % Bin Rho
                [rhoBin BinYs]   = AverageBins( mean( USrho(:,ceil(Col-BS/2):floor(Col+BS/2)) , 2 ) ,YDatUS,BS);
                CSrho(i,:)=rhoBin;
            % Bin S
                [sBin BinYs]   = AverageBins( mean( USs(:,ceil(Col-BS/2):floor(Col+BS/2)) , 2 ) ,YDatUS,BS);
                CSs(i,:)=sBin;              
            % Bin C1C2, Cov
                [c1c2Bin BinYs]   = AverageBins( mean( USC1C2(:,ceil(Col-BS/2):floor(Col+BS/2)) , 2 ) ,YDatUS,BS);
                [covBin BinYs]   = AverageBins( mean( USCov(:,ceil(Col-BS/2):floor(Col+BS/2)) , 2 ) ,YDatUS,BS);
                CSc1c2(i,:)=c1c2Bin;    
                CScov(i,:)=covBin;    
                        
        else
            Col=find(XDatDS < Xpts(i),1,'first');
            
             % Bin means 
                [mean1Bin BinYs]   = AverageBins( mean( DSmean1(:,ceil(Col-BS/2):floor(Col+BS/2)) , 2 ) ,YDatDS,BS);
                [mean2Bin BinYs]   = AverageBins( mean( DSmean2(:,ceil(Col-BS/2):floor(Col+BS/2)) , 2 ) ,YDatDS,BS);
                CSmean1(i,:)=mean1Bin;
                CSmean2(i,:)=mean2Bin;
                CSys(i,:)   =BinYs;

            % Bin rms 
                [RMSE1Bin BinYs]   = AverageBins( mean( USRMSE1(:,ceil(Col-BS/2):floor(Col+BS/2)) , 2 ) ,YDatUS,BS);
                [RMSE2Bin BinYs]   = AverageBins( mean( USRMSE2(:,ceil(Col-BS/2):floor(Col+BS/2)) , 2 ) ,YDatUS,BS);
                CSrms1(i,:)=RMSE1Bin;
                CSrms2(i,:)=RMSE2Bin;

            % Bin Rho
                [rhoBin BinYs]   = AverageBins( mean( DSrho(:,ceil(Col-BS/2):floor(Col+BS/2)) , 2 ) ,YDatDS,BS);
                CSrho(i,:)=rhoBin;
            % Bin S
                [sBin BinYs]   = AverageBins( mean( DSs(:,ceil(Col-BS/2):floor(Col+BS/2)) , 2 ) ,YDatDS,BS);
                CSs(i,:)=sBin;              
            % Bin C1C2, Cov
                [c1c2Bin BinYs]   = AverageBins( mean( DSC1C2(:,ceil(Col-BS/2):floor(Col+BS/2)) , 2 ) ,YDatDS,BS);
                [covBin BinYs]   = AverageBins( mean( DSCov(:,ceil(Col-BS/2):floor(Col+BS/2)) , 2 ) ,YDatDS,BS);
                CSc1c2(i,:)=c1c2Bin;    
                CScov(i,:)=covBin;    
            
        end
    end
            
    save(['Vars/Eps' sprintf('%.3f', eps) '/BinnedCSStats' NAME],'CSys','CSmean1','CSmean2','CSrms1','CSrms2','CSs','CSrho','CSc1c2','CScov');