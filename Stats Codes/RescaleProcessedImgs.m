function RescaleProcessedImgs(Start, Stop, sc1, sc2)
%--------------------------------------------------------------------------------%

%--------------------------------------------------------------------------------%


disp(['Rescaling ' int2str(Start) '-' int2str(Stop)]);

ind=1;
i=Start(ind);
while ind<=length(Start)
    load(['ProcImgs/Proc' sprintf('%05d', i)],'C1','C2','b1','b2')   %Proc Mean
    
    C1=C1*sc1;
    C2=C2*sc2;
    
    b1=b1*sc1;b2=b2*sc2;
    save(['ProcImgs/Proc' sprintf('%05d', i)],'C1','C2','b1','b2')   %Proc Mean
    
    if i==Stop(ind)
        ind=ind+1;
        if ind<=length(Start)
            i=Start(ind);
        end
    else
        i=i+1;
    end
end
