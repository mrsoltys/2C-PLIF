function [JPDFs]=PDF2d(Direct, Start, Stop, JPDFs, Box, eps)
%--------------------------------------------------------------------------------%
% Note Box is [r c]
%
% PDF2d(Direct, Start, Stop, JPDFs, Box, eps, exp)
% Inputs:
%   Direct is the directory path to find the means for.  If your current path is the
%       correct Directory, set path to: ''
%   Start is the image number to start calculating PDF for
%   Stop is the image number to stop calculating PDF for
%   JPDFs is a NxM struct with the required fields:
%       Xpix and Ypix refering to the pixel coordnate each JPDF should be
%       calculated for.
%       Loc with location 1 for 'US' or 2 for 'DS,' etc.
%   eps - noise filter, default is set to -Inf
%
%
% output:
% FindMeanE will return the struct JPDFs with a 101x101 matrix containing 
% the JPDF of C1 adn C2
% the function will also output a file named
% "Direct/Vars/Eps0.N/PDF2dStart-Stop_exp_n|d" containing the JPDFs

 
% NOTE code prob should be modified so if only 1 Start and Stop is given,
% it doesn't look at location
%--------------------------------------------------------------------------------%
    if nargin == 5
        eps = -Inf;
    end

% Start Matlabpool
%matlabpool open

% Initilize Centers.  This also sets the length of the PDF
[Cs, Cs]=size(JPDFs(1,1).JPDF)
Centers=linspace(0,1,Cs);
%Centers=0:.01:1;
    Cs(1)={Centers};
    Cs(2)={Centers};

% Get size of the XYpts matrix    
[Ys Xs]=size(JPDFs);    

% Initilize N. first two dimentions are a PDF for a single x and Y point.
% The second 2 dimentions will specify the X and Y point for that PDF.


disp(['Finding 2D PDF for ' int2str(Start) '-' int2str(Stop)]);
load([Direct 'ProcImgs/Proc' sprintf('%05d', Start(1))],'C1','C2')   %Proc Mean


%% Start by running through each JPDF and initalizing it
ind=1;
while ind<=length(Start)
    Str=Start(ind);Stp=Stop(ind);
    %Load Means
        load([Direct 'Vars/Eps' sprintf('%.3f', eps) '/ProcMeansE' sprintf('%05d', Start(ind)) '-' sprintf('%05d', Stop(ind))], 'mean1', 'mean2', 'RMSE1', 'RMSE2', 'Cov', 'C1C2');   
        Mean1=mean1; Mean2=mean2;
    %Load RMS
    %    load([Direct 'Vars/Eps' sprintf('%.3f', eps) '/RMSEe' sprintf('%05d', Start(ind)) '-' sprintf('%05d', Stop(ind))], );   
    %load Other Stats?
    %    load([Direct 'Vars/Eps' sprintf('%.3f', eps) '/CovE' sprintf('%05d', Start(ind)) '-' sprintf('%05d', Stop(ind))], );   
    for X=1:Xs
        for Y=1:Ys
            if(JPDFs(Y,X).Loc==ind) % check to make sure we're in the right image
                % How many Counts will PDF have? 
                
                JPDFs(Y,X).JPDF=zeros(length(Centers), length(Centers));
                
            end
        end
    end
    ind=ind+1;
end


%% For Progress Bar
Length=sum(Stop-Start)+length(Start)-1;
Count=0;
WaitBar = waitbar(0,'Initializing waitbar...');
tic;

%% Now Run through Each image, make approprate histograms, and add them to each JPDF
ind=1;
i=Start(ind);
while ind<=length(Start)
    for X=1:Xs
        for Y=1:Ys
            if(JPDFs(Y,X).Loc==ind) % check to make sure we're in the right image              
                load([Direct 'ProcImgs/Proc' sprintf('%05d', i)],'C1','C2')

                %Define Box that JPDF is defined for
                l=JPDFs(Y,X).Xpix-floor(Box(2)/2);
                r=JPDFs(Y,X).Xpix+floor(Box(2)/2);
                b=JPDFs(Y,X).Ypix-floor(Box(1)/2);
                t=JPDFs(Y,X).Ypix+floor(Box(1)/2);
                
                %Define Each Box
                C1s=C1(b:t,l:r);C1s(C1s<eps)=0;
                C2s=C2(b:t,l:r);C2s(C2s<eps)=0;
                
                %Detrmine Bin Locations
                C1s=round(C1s.*119)+1;C1s(C1s>120)=120;C1s(C1s<1)=1;
                C2s=round(C2s.*119)+1;C2s(C2s>120)=120;C2s(C2s<1)=1;
                
                %Add Too hists
                Hist(:,:)1=accumarray(Div1s(:), [C1s(:),C2s(:)]);
                Hist(:,:)2=accumarray(Div2s(:), [C1s(:),C2s(:)]);
                
                %For each pixel we need to get C1, C2 and map it to the PDF
                %space (binning). Then for that value, we need to add the
                %scalar X and Y components to the running mean.
                
                %A = accumarray(subs, val)

                % create histogram for each Box and add it to the JPDF
                JPDFs(Y,X).Div1=JPDFs(Y,X).Div1+Hist1;
                JPDFs(Y,X).Div2=JPDFs(Y,X).Div2+Hist2;
            end
        end
    end
    
    Count=Count+1;
    MikesPogressBar(Count,Length,WaitBar)
    
    if i==Stop(ind)
        ind=ind+1;
        if ind<=length(Start)
            i=Start(ind);
        end
    else
        i=i+1;
    end
end

close(WaitBar);

%Normalize by total counts to get a PDF
for X=1:Xs
	for Y=1:Ys
        JPDFs(Y,X).JPDF=JPDFs(Y,X).JPDF./JPDFs(Y,X).Ncounts;
    end
end

save([Direct 'Vars/Eps' sprintf('%.3f', eps) '/PDF2d' sprintf('%05d', Start(1)) '-' sprintf('%05d', Stop(length(Start)))], 'JPDFs');   %Proc Mean

% stop matlabpool
%matlabpool close
 