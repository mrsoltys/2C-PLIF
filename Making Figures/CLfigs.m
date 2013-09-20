function [VO CLxdat CLmean1 CLmean2 CLrms1 CLrms2 CLc1c2 CLcov CLs CLrho ] = CLfigs(USstart, USstop, DSstart, DSstop, eps, Xshift,Expon, NAME)
BS=30;
load(['Vars/Eps' sprintf('%.3f', eps) '/VOetc' NAME],'VO','S','USycent','DSycent','Yshift','USXData','USYData','DSXData','DSYData','Ang1','Ang2');
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
        [USrhoBin USxs] = AverageBins(mean(USrho(ceil(UScl-BS/2):floor(UScl+BS/2),:)),linspace(USXData(1),USXData(2),USc),BS);
        [DSrhoBin DSxs] = AverageBins(mean(DSrho(ceil(DScl-BS/2):floor(DScl+BS/2),:)),linspace(DSXData(1),DSXData(2),DSc),BS);
        CLrho  = [USrhoBin DSrhoBin];
        CLxdat = [USxs DSxs];
        
    % Find S
        USs=USCov./(USmean1.*USmean2);
        DSs=DSCov./(DSmean1.*DSmean2);
        [USsBin USxs]   = AverageBins(mean(  USs(ceil(UScl-BS/2):floor(UScl+BS/2),:)),linspace(USXData(1),USXData(2),USc),BS);
        [DSsBin DSxs]   = AverageBins(mean(  DSs(ceil(DScl-BS/2):floor(DScl+BS/2),:)),linspace(DSXData(1),DSXData(2),DSc),BS);
        CLs  = [USsBin DSsBin];
        
    % Bin means 
        [USmean1Bin USxs]   = AverageBins(mean(  USmean1(ceil(UScl-BS/2):floor(UScl+BS/2),:)),linspace(USXData(1),USXData(2),USc),BS);
        [DSmean1Bin DSxs]   = AverageBins(mean(  DSmean1(ceil(DScl-BS/2):floor(DScl+BS/2),:)),linspace(DSXData(1),DSXData(2),DSc),BS);
        [USmean2Bin USxs]   = AverageBins(mean(  USmean2(ceil(UScl-BS/2):floor(UScl+BS/2),:)),linspace(USXData(1),USXData(2),USc),BS);
        [DSmean2Bin DSxs]   = AverageBins(mean(  DSmean2(ceil(DScl-BS/2):floor(DScl+BS/2),:)),linspace(DSXData(1),DSXData(2),DSc),BS);
        [USmeanc1c2Bin USxs]= AverageBins(mean(  USmean1(ceil(UScl-BS/2):floor(UScl+BS/2),:).*...
                                                 USmean2(ceil(UScl-BS/2):floor(UScl+BS/2),:)),linspace(USXData(1),USXData(2),USc),BS);
        [DSmeanc1c2Bin DSxs]= AverageBins(mean(  DSmean1(ceil(DScl-BS/2):floor(DScl+BS/2),:).*...
                                                 DSmean2(ceil(DScl-BS/2):floor(DScl+BS/2),:)),linspace(DSXData(1),DSXData(2),DSc),BS);
        CLmean1   =[USmean1Bin DSmean1Bin];
        CLmean2   =[USmean2Bin DSmean2Bin];
        CLmeanC1C2=[USmeanc1c2Bin DSmeanc1c2Bin];
        
     % Bin rms
        [USRMSE1Bin USxs]   = AverageBins(mean(  USRMSE1(ceil(UScl-BS/2):floor(UScl+BS/2),:)),linspace(USXData(1),USXData(2),USc),BS);
        [DSRMSE1Bin DSxs]   = AverageBins(mean(  DSRMSE1(ceil(DScl-BS/2):floor(DScl+BS/2),:)),linspace(DSXData(1),DSXData(2),DSc),BS);
        [USRMSE2Bin USxs]   = AverageBins(mean(  USRMSE2(ceil(UScl-BS/2):floor(UScl+BS/2),:)),linspace(USXData(1),USXData(2),USc),BS);
        [DSRMSE2Bin DSxs]   = AverageBins(mean(  DSRMSE2(ceil(DScl-BS/2):floor(DScl+BS/2),:)),linspace(DSXData(1),DSXData(2),DSc),BS);
        CLrms1=[USRMSE1Bin DSRMSE1Bin];
        CLrms2=[USRMSE2Bin DSRMSE2Bin];
        
    % Bin C1C2, Cov
        [USc1c2Bin USxs]    = AverageBins(mean(  USC1C2(ceil(UScl-BS/2):floor(UScl+BS/2),:)),linspace(USXData(1),USXData(2),USc),BS);
        [DSc1c2Bin DSxs]    = AverageBins(mean(  DSC1C2(ceil(DScl-BS/2):floor(DScl+BS/2),:)),linspace(DSXData(1),DSXData(2),DSc),BS);
        [USCovBin USxs]     = AverageBins(mean(  USCov(ceil(UScl-BS/2):floor(UScl+BS/2),:)),linspace(USXData(1),USXData(2),USc),BS);
        [DSCovBin DSxs]     = AverageBins(mean(  DSCov(ceil(DScl-BS/2):floor(DScl+BS/2),:)),linspace(DSXData(1),DSXData(2),DSc),BS);
        
        CLc1c2=[USc1c2Bin DSc1c2Bin];
        CLcov=[USCovBin DSCovBin];
        
    % Bin Integrated C1C2, Cov
        [USc1c2Bin USxs]   = AverageBins(sum( USC1C2 ),linspace(USXData(1),USXData(2),USc),BS);
        [DSc1c2Bin DSxs]   = AverageBins(sum( DSC1C2 ),linspace(DSXData(1),DSXData(2),DSc),BS);
        [USCovBin USxs]   = AverageBins(sum( USCov ),linspace(USXData(1),USXData(2),USc),BS);
        [DSCovBin DSxs]   = AverageBins(sum( DSCov ),linspace(DSXData(1),DSXData(2),DSc),BS);
        [USmeanc1c2Bin USxs]   = AverageBins(sum( USmean1.*USmean2 ),linspace(USXData(1),USXData(2),USc),BS);
        [DSmeanc1c2Bin DSxs]   = AverageBins(sum( DSmean1.*DSmean2 ),linspace(DSXData(1),DSXData(2),DSc),BS);
        [DSmeanc1c2Bin DSxs]   = AverageBins(sum( DSmean1.*DSmean2 ),linspace(DSXData(1),DSXData(2),DSc),BS);
        INTc1c2=[USc1c2Bin DSc1c2Bin];
        INTcov=[USCovBin DSCovBin];
        INTmeanc1c2=[USmeanc1c2Bin DSmeanc1c2Bin];
        
    % Normalize the reaction similar to S, Cov, then integrate and bin:
        % Find Rho
        USc1c2rho=USC1C2./(USRMSE1.*USRMSE2);
        DSc1c2rho=DSC1C2./(DSRMSE1.*DSRMSE2);
        USc1c2S=USC1C2./(USmean1.*USmean2);
        DSc1c2S=DSC1C2./(DSmean1.*DSmean2);
        
        [USc1c2rhoBin USxs]   = AverageBins(sum( USc1c2rho ),linspace(USXData(1),USXData(2),USc),BS);
        [DSc1c2rhoBin DSxs]   = AverageBins(sum( DSc1c2rho ),linspace(DSXData(1),DSXData(2),DSc),BS);
        [USc1c2SBin USxs]   = AverageBins(sum( USc1c2S ),linspace(USXData(1),USXData(2),USc),BS);
        [DSc1c2SBin DSxs]   = AverageBins(sum( DSc1c2S ),linspace(DSXData(1),DSXData(2),DSc),BS);
        INTc1c2rho=[USc1c2rhoBin DSc1c2rhoBin];
        INTc1c2s=[USc1c2SBin DSc1c2SBin];
        
    % plot
    figure(2)
  %  subplot(2,2,1);hold on;
  %      plot(CLxdat,CLmean1,'b');
  %      plot(CLxdat,CLmean2,'r');
  %      hold off;
  %      axis([0 20 0 .2])
  %  subplot(2,2,2)
  %      plot(linspace(USXData(1),USXData(2),USc),USC1C2(round(UScl),:),'k-');hold on;
  %      plot(linspace(USXData(1),USXData(2),USc),USmean1(round(UScl),:).*USmean2(round(UScl),:),'k--');
  %      plot(linspace(USXData(1),USXData(2),USc),USCov(round(UScl),:),'k:');hold off;
  %      axis([0 20 -.02 .02])
%     subplot(2,1,2);hold on;
%         plot(CLxdat,INTc1c2,'ko');
%         plot(CLxdat,INTcov,'k^');
%         plot(CLxdat,INTmeanc1c2,'ks');
%         plot([0 30],[0 0],'k-');
%         %%plot(CLxdat,INTmeanc1c2+INTcov-INTc1c2,'ko');
%         axis([0 30 min(INTcov) max([INTmeanc1c2 INTc1c2])]);hold off;
%     subplot(2,1,1);
%         plot(CLxdat,CLmean1,'bo');hold on;
%         plot(CLxdat,CLmean2,'ro');hold off;
        
   % subplot(2,1,2)
   %     plot(CLxdat,CLs,'ko');
   %     axis([0 30 -1 1]);hold off;
        
    save(['Vars/Eps' sprintf('%.3f', eps) '/BinnedCLStats' NAME],'VO','CLxdat','CLmean1','CLmean2','CLmeanC1C2','CLrms1','CLrms2','CLs','CLrho','CLc1c2','CLcov', 'INTc1c2', 'INTcov', 'INTc1c2rho', 'INTc1c2s');