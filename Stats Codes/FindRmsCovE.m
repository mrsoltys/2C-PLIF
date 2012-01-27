function FindRmsCovE(Direct, Start, Stop,eps)
disp(['Finding <c1c2> for ' int2str(Start) '-' int2str(Stop)]);

load([Direct 'Vars/ProcMeansE'  sprintf('%05d', Start(1)) '-' sprintf('%05d', Stop(length(Start)))], 'mean1', 'mean2');

Cov=zeros(size(mean1));
C1C2=Cov;
RMSE1=Cov;
RMSE2=Cov;


ind=1;
i=Start(ind);
while ind<=length(Start)
    load([Direct 'ProcImgs/Proc' sprintf('%05d', i)],'C1','C2');
        C1=C1.*(C1>=eps);
        C2=C2.*(C2>=eps);

    RMSE1=RMSE1+(C1-mean1).^2;
    RMSE2=RMSE2+(C2-mean2).^2;
    C1C2=C1C2+C1.*C2;
    Cov=Cov+(C1-mean1).*(C2-mean2);
        
    if i==Stop(ind)
        ind=ind+1;
        if ind<=length(Start)
            i=Start(ind);
        end
    else
        i=i+1;
    end
end


C1C2=C1C2./(sum(Stop-Start)+length(Start));
Cov=Cov./(sum(Stop-Start)+length(Start));
RMSE1=sqrt(RMSE1./(sum(Stop-Start)+length(Start)));
RMSE2=sqrt(RMSE2./(sum(Stop-Start)+length(Start)));

save([Direct 'Vars/CovE' sprintf('%05d', Start(1)) '-' sprintf('%05d', Stop(length(Start)))], 'Cov', 'C1C2');
save([Direct 'Vars/RMSEe' sprintf('%05d', Start(1)) '-' sprintf('%05d', Stop(length(Start)))], 'RMSE1', 'RMSE2');
end