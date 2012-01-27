function Mean=FindMeanE(Direct, Start, Stop,eps)
disp(['Finding mean for ' int2str(Start) '-' int2str(Stop)]);

load([Direct 'ProcImgs/Proc' sprintf('%05d', Start(1))],'C1','C2')   %Proc Mean
                                                          
mean1=zeros(size(C1));
mean2=zeros(size(C2));

ind=1;
i=Start(ind);
while ind<=length(Start)
    load([Direct 'ProcImgs/Proc' sprintf('%05d', i)],'C1','C2')
    
    mean1=mean1+C1.*(C1>=eps);
    mean2=mean2+C2.*(C2>=eps);
    
    %Display Progress
%    stopBar= progressbar((i-Start+1)/(Stop-Start),5);
%       if (stopBar) break; end
    
    if i==Stop(ind)
        ind=ind+1;
        if ind<=length(Start)
            i=Start(ind);
        end
    else
        i=i+1;
    end
end

mean1=mean1./(sum(Stop-Start)+length(Start));
mean2=mean2./(sum(Stop-Start)+length(Start));

save([Direct 'Vars/ProcMeansE' sprintf('%05d', Start(1)) '-' sprintf('%05d', Stop(length(Start)))], 'mean1', 'mean2');   %Proc Mean

Mean=[mean1 mean2];
 