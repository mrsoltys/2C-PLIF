function ParProc(Direct,Start, Stop, BackStart, BackStop)
%Make Directorys
mkdir([Direct 'ProcImgs']);
%mkdir([Direct 'ComboImgs']);
%mkdir([Direct 'PurpImgs']);

%Load Vars
load([Direct 'Vars/PreRunVars.mat'], 'C1Dir', 'C2Dir', 'SetStart', 'Size');

%Load Dark
    load([Direct 'Vars/TransAvgDark'], 'I1', 'I2');
    D1=I1; D2=I2;
        
%Load Lambda    
    load([Direct 'Vars/Lambdas'],'Lambda1','Lambda2');
Lambda1=Lambda1;
Lambda2=Lambda2;

disp(['Processing Imgs ' int2str(Start) '-' int2str(Stop)]);
    load([Direct 'Vars/TransAvg' BackStart])
    B1a=I1; B2a=I2;
    
    load([Direct 'Vars/transAvg' BackStop])
    B1b=I1; B2b=I2;

Size=size(I1);
%% Start for to trans and crop each image

    Size=Size;
    C1Dir=C1Dir;
    C2Dir=C2Dir;
    b1=1;b2=1;

parfor i=Start:Stop
        %Calculate Background:
        B1=B1a*(Stop-i)/(Stop-Start) + B1b*(i-Start)/(Stop-Start);
        B2=B2a*(Stop-i)/(Stop-Start) + B2b*(i-Start)/(Stop-Start);
                
        [C1 C2]=ParProcImg(Direct,i, b1, b2, B1, B2, D1, D2, Lambda1, Lambda2)
        
        I1max(i,:)=max(C1);
        I2max(i,:)=max(C2);
    end

    I1max=I1max(Start:Stop,:);
    I2max=I2max(Start:Stop,:);
    
save([Direct 'Vars/Istats' sprintf('%05d', Stop)], 'I1max', 'I2max');