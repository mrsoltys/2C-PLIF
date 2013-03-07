 function RadCorr = RadCorr2D(Img1,Img2,Scale)

%function RadCorr2D(Img1,Img2)
    Xcorr=xcorr2(Img1,Img2);
    
    %set center
    [r c]=size(Xcorr);
    
    %% assign radius (Can I do this quicker/more efficent?)
    Xc=(1+c)/2;
    Yc=(1+r)/2;
    for i=1:1:r
        Rs(i,:)=sqrt( ((1:1:c)-Xc).^2+(i*ones(1,c)-Yc).^2);
    end
    
    imagesc(((1:c)-Xc),((1:r)-Yc),Xcorr);
    %% vectorize
        CorVec(:,1)=Rs(:);
        CorVec(:,2)=double(Xcorr(:));
    %% sort by radius
        CorVec=sortrows(CorVec);
        
    %% sum by radius
    i=1;
    Current=CorVec(i,1);
    Cnt=1;
    Sum=CorVec(i,2);
    index=1;
    
    for i=2:length(CorVec)
        if CorVec(i,1)==Current
            Sum=Sum+CorVec(i,2);
            Cnt=Cnt+1;
        else
            RadCorr(1,index)=Current;
            RadCorr(2,index)=Sum./Cnt;
            
            
            Current=CorVec(i,1);
            Cnt=1;
            Sum=CorVec(i,2);
            index=index+1;
        end
    end
    
    [Corrs Xs]   = AverageBins( RadCorr(2,:),RadCorr(1,:),20);
    
    %% Plot?
    Size=size(Img1);
    subplot(1,2,1);imshow(ColorChangeWhite(Img2,Img1),'YData',(1:Size(1))/Scale,'XData',(1:Size(2))/Scale)
    xlabel('x [cm]');ylabel('z [cm]');
    subplot(1,2,2);
    plot(Xs/Scale,Corrs,'-')
    xlabel('r [cm]');
    
    
    