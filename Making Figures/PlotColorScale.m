function PlotColorScale(Exp)

Xs=(0:.005:1).^(1/Exp);
    for i=1:length(Xs)
         Red(i,:)=Xs;
    end
    Blue=flipud(Red');
    Rtemp=Red;
    Red((Blue+Red)>1)=0;
    Blue((Blue+Rtemp)>1)=0;
    ColorMapImg=ColorChangeWhite(Red, Blue, 1);
%subaxis(1,1,1,'Spacing', 0, 'Margin', .1)
    imshow(ColorChangeWhite(Red, Blue, Exp),'XData',Xs,'YData',fliplr(Xs));
    xLabH=xlabel('$\Phi_B$');
    yLabH=ylabel('$\Phi_A$','Rotation',0);
    set(yLabH,'Position',[-.4, .35, 1])
    axis square;
    set(gca,'YDir','normal',...
            'XAxisLocation','bottom',... 
            'YAxisLocation','left',... 
         'XTick',(0:.5:1).^Exp,'XTickLabel',0:.5:1,...
         'YTick',(0:.5:1).^Exp,'YTickLabel',0:.5:1);
     
  %  set(yLabH,'Position',get(yLabH,'Position') - [0 .1 0]);
         %  'XTick',[],'YTick',[]);
 %   title(['$\Phi^{' sprintf('%0.2f',Exp) '}$'],'FontSize',14);     
 
%  
%  figure,hist(random('Normal',0,1,1,1000),30)
% 
% set(gca,'Visible','off') 
% axes('Position',get(gca,'Position'),... 
% 'XAxisLocation','bottom',... 
% 'YAxisLocation','left',... 
% 'Color','none',... 
% 'XTickLabel',get(gca,'XTickLabel'),... 
% 'YTickLabel',get(gca,'YTickLabel'),... 
% 'XColor','k','YColor','k',... 
% 'LineWidth',2,... 
% 'TickDir','out');