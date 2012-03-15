function ParTransProc(Direct,Start, Stop, BackStart, BackStop, AddCrop, Lambda)
%Make Directorys
mkdir([Direct 'ProcImgs']);
%mkdir([Direct 'ComboImgs']);
%mkdir([Direct 'PurpImgs']);

    if nargin == 6
        load([Direct 'Vars/Lambdas'],'Lambda1','Lambda2');
    else
        load([Direct 'Vars/' Lambda],'Lambda1','Lambda2');
    end

%Load Vars
load([Direct 'Vars/PreRunVars.mat'], 'C1Dir', 'C2Dir', 'SetStart',  'TFORM1','TFORM2', 'Size', 'Cs');

%Load Dark
    load([Direct 'Vars/TransAvgDark'], 'I1', 'I2');
    D1=I1; D2=I2;
        
%Load Lambda    

%load([Direct 'Vars/Lambdas' sprintf('%05d', Stop)],'Lambda1','Lambda2');
Lambda1=Lambda1;
Lambda2=Lambda2;

    load([Direct 'Vars/TransAvg' BackStart])
    B1a=I1; B2a=I2;
    
    load([Direct 'Vars/transAvg' BackStop])
    B1b=I1; B2b=I2;

Size=size(I1);
%% Start for to trans and crop each image

    Size=Size;
    C1Dir=C1Dir;
    C2Dir=C2Dir;
    TFORM1=TFORM1;
    TFORM2=TFORM2;

    %%Note, need to normalize the cropping by cs
    AddCrop(1)=Cs(1)+AddCrop(1);
    AddCrop(2)=Cs(2)-AddCrop(2);
    AddCrop(3)=Cs(3)+AddCrop(3);
    AddCrop(4)=Cs(4)-AddCrop(4);
disp(['Translating and Processing Imgs ' int2str(Start) '-' int2str(Stop)]);
    parfor i=Start:Stop
            
        Name1=[Direct 'RawImgs/' C1Dir(i).name];
        Name2=[Direct 'RawImgs/' C2Dir(i).name];
        
        %Calculate Background:
        B1=B1a*(Stop-i)/(Stop-Start) + B1b*(i-Start)/(Stop-Start);
        B2=B2a*(Stop-i)/(Stop-Start) + B2b*(i-Start)/(Stop-Start);
        
        [C1, C2] = ParTransCropImg(Direct, Name1, Name2, TFORM1, TFORM2, AddCrop, B1, B2, D1, D2, Lambda1, Lambda2, i)                     

        %Gather the maximum concnetnration from each column
        I1max(i,:)=max(C1); 
        I2max(i,:)=max(C2);
    end

    I1max=I1max(Start:Stop,:);
    I2max=I2max(Start:Stop,:);
    
    save([Direct 'Vars/ProcMaxs' sprintf('%05d', Stop)], 'I1max', 'I2max');