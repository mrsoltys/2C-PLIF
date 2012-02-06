function [I1max I2max]=FindMaxs(Direct, Start, Stop)
disp(['Finding max for ' int2str(Start) '-' int2str(Stop)]);

for i=Start:Stop
    load([Direct 'ProcImgs/Proc' sprintf('%05d', i)],'C1','C2')   
    max1(i,:)=max(C1);
    max2(i,:)=max(C2);
    
    %Display Progress
    stopBar= progressbar((i-Start+1)/(Stop-Start),5);
       if (stopBar) break; end
end

I1max = max1(Start:Stop,:);
I2max = max2(Start:Stop,:);

save([Direct 'Vars/Istats' sprintf('%05d', Stop)], 'I1max', 'I2max');  
