function [Map]=HotCold(cbot,ctop)

if nargin == 0
     B(1,:)= [zeros(1,22) linspace(0,1,10) ones(1,22) linspace(1,.5,10)];
     B(2,:)= [zeros(1,11) linspace(0,1,11) ones(1,20) linspace(1,0,11) zeros(1,11)];
     B(3,:)= fliplr(B(1,:));
elseif nargin == 1
     mid=cbot;
     Sxths=zeros(1,6);
          Sxths(1)=round(1/3*mid);
          Sxths(2)=Sxths(1);
          Sxths(3)=mid-Sxths(1)-Sxths(2);
          Sxths(6)=round(1/3*(64-mid));
          Sxths(5)=Sxths(6);
          Sxths(4)=64-sum(Sxths);
          
     B(1,:)= [zeros(1,Sxths(1)+Sxths(2)) linspace(0,1,Sxths(3)) ones(1,Sxths(4)+Sxths(5)) linspace(1,.5,Sxths(6))]
     B(2,:)= [zeros(1,Sxths(1)) linspace(0,1,Sxths(2)) ones(1,Sxths(3)+Sxths(4)) linspace(1,0,Sxths(5)) zeros(1,Sxths(6))]
     B(3,:)= [linspace(.5,1,Sxths(1)) ones(1,Sxths(2)+Sxths(3)) linspace(1,0,Sxths(4)) zeros(1,Sxths(5)+Sxths(6))];
    
else
     mid=double(round((cbot/(cbot-ctop))*63+1));
     Sxths=zeros(1,6);
          Sxths(1)=round(1/3*mid);
          Sxths(2)=Sxths(1);
          Sxths(3)=mid-Sxths(1)-Sxths(2);
          Sxths(6)=round(1/3*(64-mid));
          Sxths(5)=Sxths(6);
          Sxths(4)=64-sum(Sxths);
          
     B(1,:)= [zeros(1,Sxths(1)+Sxths(2)) linspace(0,1,Sxths(3)) ones(1,Sxths(4)+Sxths(5)) linspace(1,.5,Sxths(6))]
     B(2,:)= [zeros(1,Sxths(1)) linspace(0,1,Sxths(2)) ones(1,Sxths(3)+Sxths(4)) linspace(1,0,Sxths(5)) zeros(1,Sxths(6))]
     B(3,:)= [linspace(.5,1,Sxths(1)) ones(1,Sxths(2)+Sxths(3)) linspace(1,0,Sxths(4)) zeros(1,Sxths(5)+Sxths(6))];
     
end

Map=B';
end