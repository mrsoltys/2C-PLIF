function MikesProgressBar(Count,Length,Handle )
%function MikesPogressBar(Count,Length,Handle )
% Must call tic; before calling MikesProgressBar:
% e.g.:
% h = waitbar(0,'Please wait...');tic;
% for
%    tic;MikesProgressBar(i,Length,h)
% end
% delete(h);

t=toc;
%Count=t/toc(iStart);
Perc=Count/Length;
Trem=t/Perc-t;
Hrs=floor(Trem/3600);
Min=floor((Trem-Hrs*3600)/60);
waitbar(Perc,Handle,[sprintf('%0.1f',Perc*100) '\%, '...
    sprintf('%03.0f',Hrs) ':'...
    sprintf('%02.0f',Min) ':'...
    sprintf('%02.0f',rem(Trem,60)) ' remaining']);

end

