function ParTrans(Direct, Start, Stop, AddCrop)
%-------------------------------------------------------------------------%
% ParTrans(Direct,Start, Stop, AddCrop)
%Inputs:
%   Required:
%       Direct is the Directory the images are stored in.
%       
%       Start, Stop is the range of image numbers that are to process
%
%       AddCrop is a vector of cropping parameters.  If no cropping is
%       desired, set to [0 0 0 0].  The cropping parameters are [? R ? ?]
%   
%   Additonal Reqiurments:
%       The function will look for the following files in the
%       'Direct/Vars/' folder that are needed for proper operation:

%       'Direct/Vars/PreRunVars.mat' should contain files defined 
%       previously by PreRun.m:
%           C1Dir and C2Dir, directory information for the RawImgs Folder
%           TFORM1 and TFORM2, image transformation matricies
%           Cs, the corners of the overlaping image of I1 and I2
%
%   Other Notes:
%       Must run Matlabpool Open in order for paralell procesing to
%       function.  Otherwise this will act like a normal for loop.  Don't
%       forget to run matlabpool close when you're all done to release
%       system resources.
%
%Output:
%   All Processed images are saved in a directory 'TransImgs/' as 
%   Trans[ImgNum] where ImgNum is 5 digit integer with leading zeros. 
%   Images are saved as .mat files containing matricies for C1 and C2.  The
%   matricies are saved as single precision values.  If the folder ProcImgs
%   does not exist, consider creating it using mkdir([Direct 'ProcImgs']);
%
%
%Last Update: 12/12/11 MAS
%Written by MAS
%-------------------------------------------------------------------------%

%Make Directorys
    mkdir([Direct 'TransImgs']);

%Load Vars
    load([Direct 'Vars/PreRunVars.mat'], 'C1Dir', 'C2Dir', 'SetStart', 'Size', 'TFORM1','TFORM2', 'Cs');

%Reintilize the loaded variables so parfor doesn't wig out
    Size=Size;
    C1Dir=C1Dir;
    C2Dir=C2Dir;
    TFORM1=TFORM1;
    TFORM2=TFORM2;
    %%Note, need to normalize the cropping by cs
    %%Note, need to normalize the cropping by cs
    AddCrop(1)=Cs(1)+AddCrop(1);
    AddCrop(2)=Cs(2)-AddCrop(2);
    AddCrop(3)=Cs(3)+AddCrop(3);
    AddCrop(4)=Cs(4)-AddCrop(4);

    disp(['Translating Imgs ' int2str(Start) '-' int2str(Stop)]);
%% Start parfor to trans and crop each image
    parfor i=Start:Stop
        
        %Do the Translation
        [I1,I2]=TransCropImg([Direct 'RawImgs/' C1Dir(i).name], [Direct 'RawImgs/' C2Dir(i).name],TFORM1, TFORM2,AddCrop);
        
        %save
        SaveImgPair(Direct,'TransImgs/Trans',i,I1,I2)
        
        %Image Scaling
        I1Scale(i)=max(max(I1));
        I2Scale(i)=max(max(I2));
     
    end

%Trim IScales
    I1Scale=I1Scale(Start:Stop); 
    I2Scale=I2Scale(Start:Stop); 

%SaveVars
    save([Direct 'Vars/Iscales' sprintf('%05d', Stop)], 'I1Scale', 'I2Scale');