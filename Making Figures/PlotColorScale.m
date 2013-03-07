function PlotColorScale(Exp)
Exp=1
Xs=(0:.005:1).^(1/Exp);
    for i=1:length(Xs)
         Red(i,:)=Xs;
    end
    Blue=flipud(Red');
    Rtemp=Red;
    Red((Blue+Red)>1)=0;
    Blue((Blue+Rtemp)>1)=0;
    ColorMapImg=ColorChangeWhite(Red, Blue, 1);
subaxis(1,1,1,'Spacing', 0, 'Margin', .1)
    imshow(ColorChangeWhite(Red, Blue, Exp),'XData',Xs,'YData',fliplr(Xs));
    xlabel('$\Phi_1$');%,'FontSize',14)
    ylabel('$\Phi_2$');%,'FontSize',14)
    axis square;
    set(gca,'YDir','normal',...
            'XTick',(0:.2:1).^Exp,...
            'XTickLabel',linspace(0,1,6),...
            'YTick',(0:.2:1).^Exp,...
            'YTickLabel',linspace(0,1,6));
    title(['$\Phi^{' sprintf('%0.2f',Exp) '}$'],'FontSize',14);        