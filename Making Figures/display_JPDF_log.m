function display_JPDF_log(JPDF, Centers)
%-------------------------------------------------------------------------%
% display_JPDF(JPDF)
% Required Inputs:
%   JPDF:       a nBins X nBins matrix with JPDF over entire domain. 
%               probabilities are normalized such that sum(JPDF(:))=1.
%   Centers:    a nBins long matrix describing the centers of the JPDF
%               
%-------------------------------------------------------------------------%
unfreezeColors;
colormap(flipud(hot));

Xax=Centers;
Yax=Xax;

%Want Contours at 99, 95, 90 85 80 70%
	Precents=[.80 .60 .40 .20];
        
%Make CDF(ish)thing
	ThreshPDF=JPDF; 
    ProbFunc=0:.00001:.9999;
    CDF=zeros(1,length(ProbFunc));
    for Cnt=1:length(ProbFunc)
        ThreshPDF(ThreshPDF<ProbFunc(Cnt))=0;CDF(Cnt)=sum(ThreshPDF(:));
    end
    %plot(ProbFunc,CDF,'*');axis([0 .01 0 1])

    Contours=[];
    ContLabel={};
    for P=1:length(Precents)
        Index=find(CDF<Precents(P), 1, 'first');
        Contours(P)=ProbFunc(Index);
        ContLabel{P}=num2str(ProbFunc(Index),'%.4f');
    end
    
     %cbot=log10(Contours(1));
     cbot=3*log10(Contours(1))/2-log10(Contours(2))/2;
     ctop=log10(Contours(length(Contours)));
            
%This gets rid of that outer annoying line.
    JPDF(JPDF<Contours(1))=0;
            
%Now Plot the thing!
    % Contour Plot of PDF
	contourf(Xax,Yax, log10(JPDF),log10(Contours));%hold on; %What IS Xax and Yax?
    %imagesc([Xax(1) Xax(length(Xax))],[Yax(1) Yax(length(Xax))], log10(JPDF));

    caxis([cbot ctop]);
    % Means
	%plot([Mean2 Mean2].^Exp,[0 1],'b'); %What IS Mean1 and Mean2?
	%plot([0 1],[Mean1 Mean1].^Exp,'b');hold off;
    %Graph Properties
    %axis([0 1 0 1]);
    axis square;
    set(gca,'YDir','normal');%colorbar('FontSize',10,'Location','East')
    %set(gca,    'XTick',[],'YTick',[]);%PDFsize*linspace(0,1,11).^Expon,...
                            %'XTickLabel',linspace(0,1,11),...
                            %'YTick',PDFsize*linspace(0,1,11).^Expon,...
                            %'YTickLabel',linspace(0,1,11));
	%Colorbar
   % hc=colorbar('FontSize',10,'Location','East','YTick',log(Contours),'YTickLabel',ContLabel);
   % cPos=get(hc,'Position');
   % set(hc,'Position',[cPos(1)+cPos(3)/2,cPos(2),cPos(3)/2,cPos(4)])
    freezeColors;
end