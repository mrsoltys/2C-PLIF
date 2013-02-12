%-------------------------------------------------------------------------%
%PreRun.m
%Last Update: 01/26/11

%PreRun.m runs through the directory of RawImgs and sorts the images by
%series names, and image numbers.  It also compairs the datenum stamp for
%discreprencys greater than 1.5 seconds.  PreRun.m is very sensitve to
%naming convention.  It accepts files named using metadata from
%BoulderImaging's system named as:
%SeriesName_Cam__SeriesNo_ImgNo.tif


%For a given directory: processes dark response, transformation, and
%background.  

%Needs: 'Direct'

%Saves: PreRunVars.mat: 'C1Dir', 'C2Dir', 'Size', 'TFORM', 'ImgStart', 
%                       'Corners'

%       C1Dark.tif
%       C2Dark.tif
%       C1Back.tif
%       C2Back.tif

% Note: Needs the Image Proccessing Toolbox installed. as well as the camera
% Calibration Toolbox for Matlab, available at: 
% http://www.vision.caltech.edu/bouguetj/calib_doc/

%-------------------------------------------------------------------------%

%Define AddCrop: Where add crop from [+L -R +T -B]

mkdir([Direct 'Vars']) 
DFBind=[0 0 0];

%% Step1, Get Directory Information for Camera 1 and 2
disp('Getting Directory Info');
    Dir=dir([Direct 'RawImgs/*.tif']);
    %C2Dir=dir([Direct 'RawImgs/*2_*.tif']);    
    
reply = input('Was this taken with the old Dalstar cameras? Y/N [N]: ', 's');
if isempty(reply)
    reply = 'N';
end
if reply=='Y'
    OldCams=true;
elseif reply=='y'
    OldCams=true;
else
    OldCams=false;
end

%% Step2, Load Image Numbers, Series Name, etc from StreamStor Title!
disp('Getting Series Info');
ind1=1;
ind2=1;

    for i=1:length(Dir)
        Name=Dir(i).name;
        
        j=1;
        br=0;
        while j<=length(Name) && br==0;
            if Name(j)~='_'     %We are looking for an _ which seperates the series name from the camera number
                j=j+1;
            elseif (Name(j+1)=='1' || Name(j+1)=='2') %If the next digit isn't the camera number, keep going.
                br=1;
            else
                j=j+1;
            end
        end
        if OldCams==0
            Dir(i).SerName=Name(1:(j-1));
            Dir(i).CamNo  =str2num(Name(j+1));
        else 
            Dir(i).SerName=[Name(1:(j-2)) Name((j+1):(j+4))];
            Dir(i).CamNo  =str2num(Name(j-1));
        end
        k=j+4; 
        while k<=length(Name) && Name(k)~='_'
            k=k+1;
        end
        if OldCams==0
            if Name(j+5)=='-' %%If you use the export function in quazar, the series number gets screwed
                Dir(i).SeriesNo=str2num(Name(j+4));
            elseif Name(j+6)=='-'
                Dir(i).SeriesNo=str2num(Name((j+4):(j+5)));
            else
                Dir(i).SeriesNo = str2num(Name((j+4):(k-1))); 
            end
        else
            Dir(i).SeriesNo = str2num(Name((j+1):(k-1))); 
        end
        
        Dir(i).ImgNo    = str2num(Name((k+1):(length(Name)-4)));
                    
        if Dir(i).CamNo==1
            C1Dir(ind1)     = Dir(i);
            ind1=ind1+1;
        else
            C2Dir(ind2)=Dir(i);
            ind2=ind2+1;
        end
    end
    
%% Sort by Series No
disp('Sorting Directorys');
    [dummy order]=sort([C1Dir(:).SeriesNo]);
    C1Dir=C1Dir(order);
    [dummy order]=sort([C2Dir(:).SeriesNo]);
    C2Dir=C2Dir(order);
    
Size=length(C1Dir);

%% Check ImgNo to see if any files need to be dropped
i=1;
SkippedFilesDir=[];
while i<=length(C1Dir)
    if C1Dir(i).ImgNo>C2Dir(i).ImgNo
        SkippedFilesDir=[SkippedFilesDir C1Dir(i)];
        C1Dir=[C1Dir(1:(i-1)) C1Dir((i+1):length(C1Dir))];
    elseif C1Dir(i).ImgNo<C2Dir(i).ImgNo
        SkippedFilesDir=[SkippedFilesDir C2Dir(i)];
        C2Dir=[C2Dir(1:(i-1)) C2Dir((i+1):length(C2Dir))];
    else
        i=i+1;
    end
end
%% Check DateNums
              %Need to detect if there is any mis-match with the datenum or
              %image numbers.  Note: Datenum's accuracy seems to be less
              %than 1 second, so the if satement only checks datenum
              %disreprancys >1.01 seconds
% i=1;j=1;
% SkippedFilesDir=[]
% while (i<=length(C1Dir) && j<=length(C2Dir) ) 
%     DateNumDiff=C1Dir(i).datenum-C2Dir(i).datenum;
% 	if(abs(DateNumDiff)>1.1690e-05)
%     	warning(['Warning: Image ' int2str(i) ':' C1Dir(i).name ' and ' C2Dir(i).name ' dont sync by']);
%         disp([num2str((C1Dir(i).datenum-C2Dir(i).datenum)*(24*60*60)) ' seconds']);
%         
%         % If there is a positive disreprancy, disreprancy, we need to skip an image
%         % from the C2 Dataset, otherwise we need to skip an image from the C1 Dataset
%         if DateNumDiff>0
%             SkippedFilesDir=[SkippedFilesDir C2Dir(j)];
%             C2Dir=[C2Dir(1:(j-1)) C2Dir((j+1):length(C2Dir))];
%         elseif DateNumDiff<0
%             SkippedFilesDir=[SkippedFilesDir C1Dir(i)];
%             C1Dir=[C1Dir(1:(i-1)) C1Dir((i+1):length(C1Dir))];
%         end
%     else
%         i=i+1;
%         j=j+1;
%     end
% end
% 
% Size=length(C1Dir);

%% Find where each set ends, and average the set.  This is usefull down the road for mean stats
disp('Average Each Set');
    Size=length(C1Dir);
    Set=0;
    i=0;
    while i~=(Size)
        i=i+1;
        if i==1 || C1Dir(i-1).SeriesNo~=C1Dir(i).SeriesNo %is it a new series?
            Set=Set+1;
            SetStart(Set)=i; 
            
             I1=double( imread([Direct 'RawImgs/' C1Dir(i).name]) );
             I2=double( imread([Direct 'RawImgs/' C2Dir(i).name]) );
                while ( i~=length(C1Dir) && C1Dir(i+1).SeriesNo==C1Dir(i).SeriesNo )
                    i=i+1;

                    I1=I1+double( imread([Direct 'RawImgs/' C1Dir(i).name]) );
                    I2=I2+double( imread([Direct 'RawImgs/' C2Dir(i).name]) );
                 %Display Progress
                    stopBar= progressbar((i-1)/(Size),5);
                    if (stopBar) break; end   
                end
                 
             I1=I1 ./ (i-SetStart(Set)+1);
             I2=I2 ./ (i-SetStart(Set)+1);
                  
             save([Direct 'Vars/Avg' C1Dir(i).SerName ],'-v7.3', 'I1', 'I2');
             disp([int2str(SetStart(Set)) ' : ' C1Dir(i).SerName]);
        end
    end
    

%% Find focus image
disp('Finding Focus Imgage')
    FocusInd=[];
    for i=1:length(SetStart)
        Foc=findstr('Focus',C1Dir(SetStart(i)).name);
        if  isempty(Foc)
            Foc=findstr('focus',C1Dir(SetStart(i)).name);
        end
        if  ~isempty(Foc)
            FocusInd=SetStart(i); break;
        end
    end
        
    
%% Load Focusing Image, Run Calib_Gui
disp('Loading Focusing Imgs');
    FocusImg1=im2double(imread([Direct 'RawImgs/' C1Dir(FocusInd).name]));
    FocusImg2=im2double(imread([Direct 'RawImgs/' C2Dir(FocusInd).name]));
    imwrite((FocusImg1-min(min(FocusImg1)))/mean(max(FocusImg1)), ['calib1.jpg']);
    imwrite((FocusImg2-min(min(FocusImg2)))/mean(max(FocusImg2)), ['calib2.jpg']);
    %We need to make sure x_1 and x_2 are accessiable
    [TFORM1 TFORM2 Cs Scale]=ImgNorm()
%         calib_gui;
%         uiwait(gcf);
%     input_pts=evalin('base','x_2')';
%     base_points=evalin('base','x_1')';
%     TFORM = cp2tform(input_pts,base_points, 'polynomial',3);
%     Corners(:,1)=x_1(:,1);s=size(x_1);Corners(:,2)=x_1(:,s(2));
%     Corners=int16(Corners);

%% Perform a check on the translation
disp('Checking Cameras')

 FocusImg1=im2double(imread([Direct 'RawImgs/' C1Dir(FocusInd).name]));
 FocusImg2=im2double(imread([Direct 'RawImgs/' C2Dir(FocusInd).name]));
Img(:,:,1)=imtransform( FocusImg1/max(max(FocusImg1)) ,...
                     TFORM1,...
                     'FillValues', 0,...
                     'XData', [Cs(1)+AddCrop(1) Cs(2)-AddCrop(2)],...
                     'YData', [Cs(3)+AddCrop(3) Cs(4)-AddCrop(4)]); 
                     %'XData', [Cs(1) Cs(2)],...
                     %'YData', [Cs(3) Cs(4)]) ;
Img(:,:,2)=imtransform( FocusImg2/max(max(FocusImg2)) ,...
                     TFORM2,...
                     'FillValues', 0,...
                     'XData', [Cs(1)+AddCrop(1) Cs(2)-AddCrop(2)],...
                     'YData', [Cs(3)+AddCrop(3) Cs(4)-AddCrop(4)]); 
                     %'XData', [Cs(1) Cs(2)],...
                     %'YData', [Cs(3) Cs(4)]) ;                
%     Cs=FindCorners(TFORM);
%     Cs=Cs+AddCrop';
%    
%     Img(:,:,1)=FocusImg1( Cs(3):Cs(4),Cs(1):Cs(2) )/max(max(FocusImg1));
%     Img(:,:,2)=imtransform( FocusImg2/max(max(FocusImg2)) ,...
%                     TFORM,...
%                     'FillValues', 0,...
%                     'XData', [Cs(1) Cs(2)],...
%                     'YData', [Cs(3) Cs(4)]) ;
     Img(:,:,3)=zeros(size(Img(:,:,1)));
    imshow(Img(:,:,1)-Img(:,:,2));colorbar;
    title('Do squares line up? If not, somethings wrong!');  
    
%% Translate Average Sets
disp('Performing Translations')
    for i=1:length(SetStart)
        load([Direct 'Vars/Avg' C1Dir(SetStart(i)).SerName ], 'I1', 'I2')
        I1=imtransform(I1,TFORM1,...
                'nearest',...
                'FillValues', 0,...
                     'XData', [Cs(1)+AddCrop(1) Cs(2)-AddCrop(2)],...
                     'YData', [Cs(3)+AddCrop(3) Cs(4)-AddCrop(4)]); 
                     %'XData', [Cs(1) Cs(2)],...
                     %'YData', [Cs(3) Cs(4)]) ;     
        I2=imtransform(I2,TFORM2,...
                'nearest',...
                'FillValues', 0,...
                     'XData', [Cs(1)+AddCrop(1) Cs(2)-AddCrop(2)],...
                     'YData', [Cs(3)+AddCrop(3) Cs(4)-AddCrop(4)]); 
                     %'XData', [Cs(1) Cs(2)],...
                     %'YData', [Cs(3) Cs(4)]) ;               
        save([Direct 'Vars/TransAvg' C1Dir(SetStart(i)).SerName ], 'I1', 'I2')
end
           

%% Save Vars to Disk!
disp('Saving Variables');
%save([Direct 'Vars/PreRunVars'], 'C1Dir', 'C2Dir', 'Size', 'TFORM', 'Corners', 'SetStart', 'Cs');
save([Direct 'Vars/PreRunVars'], 'C1Dir', 'C2Dir', 'SkippedFilesDir', 'Size', 'TFORM1', 'TFORM2', 'Scale', 'SetStart', 'Cs');
%% 
disp('Done!')
if length(C1Dir)~=length(C2Dir)
    warning('Warning: directorys are not the same length');
end

for i=1:(length(SetStart)-1)
    
    disp([int2str(SetStart(i)) ' , ' int2str(SetStart(i+1)-1) ' : ' C1Dir(SetStart(i)).SerName]);
end
    disp([int2str(SetStart(i+1)) ' , ' int2str(length(C1Dir)) ' : ' C1Dir(SetStart(i+1)).SerName]); 