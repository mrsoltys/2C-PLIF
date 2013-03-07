Start=7058;Stop=7158;
%Start=9517;Stop=9616;

B=imread(['RawImgs/' C1Dir(Start).name]);
Size=size(B);
Xsq=zeros(Size);
X  =zeros(Size);

%sigma=sqrt(E(X^2)-(E(X))^2)
for i=Start:Stop
    %Load Background
    B=double(imread(['RawImgs/' C1Dir(i).name]));
    % Add
    X=X+B;    
    Xsq=Xsq+B.^2;
end;
EXsq=Xsq/(Stop-Start+1);
EX=X/(Stop-Start+1);

Mean=EX;
StdDev=sqrt(EXsq-EX.^2);

subplot(2,2,1);imagesc(Mean);colorbar('South');
subplot(2,2,2);imagesc(StdDev);colorbar('South');
subplot(2,2,3);imagesc(StdDev./Mean);colorbar('South');