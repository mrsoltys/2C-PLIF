function Cs=FindCorners(TFORM, SIZE);
%-------------------------------------------------------------------------%

%FindCorners.m
%Last Update: 12/14/11 by MAS
%Written by MAS

%-------------------------------------------------------------------------%
%Find First Corner (Top Left)
Guess1=[1 1];
Ans=zeros(1,2);
while (abs(Ans(1)-1)>0.1 || abs(Ans(2)-1)>0.1);
    Ans=tforminv(TFORM,Guess1(1),Guess1(2));
    Guess1(1)=Guess1(1)-(Ans(1)-1);
    Guess1(2)=Guess1(2)-(Ans(2)-1);
end

%Find second corner (Bottom Left)
Guess2=[1 SIZE(1)];
Ans=zeros(1,2);
while (abs(Ans(1)-1)>0.1 || abs(Ans(2)-SIZE(1))>0.1)
    Ans=tforminv(TFORM,Guess2(1),Guess2(2));
    Guess2(1)=Guess2(1)-(Ans(1)-1);
    Guess2(2)=Guess2(2)-(Ans(2)-SIZE(1));
end

%Find Third corner (Bottom Right)
Guess3=[SIZE(2) SIZE(1)];
Ans=zeros(1,2);
while (abs(Ans(1)-SIZE(2))>0.1 || abs(Ans(2)-SIZE(1))>0.1)
    Ans=tforminv(TFORM,Guess3(1),Guess3(2));
    Guess3(1)=Guess3(1)-(Ans(1)-SIZE(2));
    Guess3(2)=Guess3(2)-(Ans(2)-SIZE(1));
end

%Find Fourth Corner (Top Right)
Guess4=[SIZE(2) 1];
Ans=zeros(1,2);
while (abs(Ans(1)-SIZE(2))>0.1 || abs(Ans(2)-1)>0.1)
    Ans=tforminv(TFORM,Guess4(1),Guess4(2));
    Guess4(1)=Guess4(1)-(Ans(1)-SIZE(2));
    Guess4(2)=Guess4(2)-(Ans(2)-1);
end


Cs(1)=max([Guess1(1) Guess2(1)]);
Cs(2)=min([Guess3(1) Guess4(1)]);
Cs(3)=max([Guess1(2) Guess4(2)]);
Cs(4)=min([Guess2(2) Guess3(2)]);
Cs=round(Cs);

%


% u = [1 1024 1024 1];
% v = [1024 1024 1 1];
% xs= u;
% ys= v;
% for i=1:4
%     xbool=false;
%     ybool=false;
%     while (xbool==false || ybool==false)
%         [x, y]=tforminv(TFORM,u(i),v(i));
%         if     round(x)<xs(i) && u(i)<1024;    u(i)=u(i)+xs(i)-x;
%         elseif round(x)>xs(i) && u(i)>1;       u(i)=u(i)+xs(i)-x;
%         else   xbool=true;
%         end
%         
%         if     round(y)<ys(i) && v(i)<1024;    v(i)=v(i)+ys(i)-y;
%         elseif round(y)>ys(i) && v(i)>1;       v(i)=v(i)+ys(i)-y;
%         else   ybool=true;
%         end
%     end
% end
% 
% %xmin xmax ymin ymax
% Cs=[ceil( max([u(1) u(4)]) );...
%     floor(   min(u(2:3))   );...
%     ceil(    max(v(3:4))   );...
%     floor(   min(v(1:2))   )]
