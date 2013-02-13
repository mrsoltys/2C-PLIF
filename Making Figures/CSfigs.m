function [VO CSxdat CSmean1 CSmean2 CSs CSrho CSc1c2 CScov] = CSfigs(USstart, USstop, DSstart, DSstop, eps, Xshift,Expon, NAME,Symbol,Pos)
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
                [DSr DSc]=size(mean1);
            %load(['Vars/Eps' sprintf('%.3f', eps) '/CovE' DSMeanName]);
                DSC1C2=imrotate(C1C2,Ang2,'crop');DSCov=imrotate(Cov,Ang2,'crop');
            %load(['Vars/Eps' sprintf('%.3f', eps) '/RMSEe' DSMeanName]);
                DSRMSE1=imrotate(RMSE1,Ang2,'crop');DSRMSE2=imrotate(RMSE2,Ang2,'crop');

        UScl=USycent
        DScl=DSycent
        
    % Find Rho
        USrho=USCov./(USRMSE1.*USRMSE2);
        DSrho=DSCov./(DSRMSE1.*DSRMSE2);

    % Find S
        USs=USCov./(USmean1.*USmean2);
        DSs=DSCov./(DSmean1.*DSmean2);
        
 % Would like to use X locations WITH UNITS
    XDatUS=linspace(USXData(1), USXData(2), USc)*S/Scale; 
    XDatDS=linspace(DSXData(1), DSXData(2), DSc)*S/Scale;
 % Would like to use UNITLESS Y dimensions
    YDatUS=linspace(USYData(1), USYData(2), USr); 
    YDatDS=linspace(DSYData(1), DSYData(2), DSr);
        
  Xpts=[7.5 15 22.5]
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
        if i==1
            Symbol='s';
        elseif i==2
            Symbol='^';
        elseif i==3
            Symbol='o';
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
                [mean1Bin BinYs]   = AverageBins( mean( USmean1(:,ceil(Col-BS/2):floor(Col+BS/2)) , 2 ) ,YDatUS,BS);
                [mean2Bin BinYs]   = AverageBins( mean( USmean2(:,ceil(Col-BS/2):floor(Col+BS/2)) , 2 ) ,YDatUS,BS);
                hold on;
                    plot(mean1Bin,BinYs,['b' Symbol],'MarkerSize',4);
                    plot(mean2Bin,BinYs,['r' Symbol],'MarkerSize',4);
                hold off;
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
                hold on;
                plot(mean1Bin,BinYs,['b' Symbol],'MarkerSize',4);
                plot(mean2Bin,BinYs,['r' Symbol],'MarkerSize',4);
                hold off;
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