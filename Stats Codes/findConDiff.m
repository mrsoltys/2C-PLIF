function [ConDiffs]=findConDiff(Direct, Start, Stop, JPDFs, Box, eps)
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

[Ys,Xs]=size(JPDFs);
ConDiffs=struct([]);

[~,Cs]=size(JPDFs(1,1).JPDF);
Centers=linspace(0,1,Cs); %%These are really EDGES.
dBin=Centers(2);

%initialize stuff
for X=1:Xs
    for Y=1:Ys
        ConDiffs(Y,X).CD1=zeros(length(Centers), length(Centers));
        ConDiffs(Y,X).CD2=zeros(length(Centers), length(Centers));
        ConDiffs(Y,X).jpdf=zeros(length(Centers), length(Centers));
    end
end

%For Progress Bar
Length=sum(Stop-Start)+length(Start)-1;
Count=0;
WaitBar = waitbar(0,'Initializing waitbar...');
tic;

%Loop
ind=1;
i=Start(ind);
while ind<=length(Start)
    %Load Img and Gradient
    load([Direct 'ProcImgs/Proc' sprintf('%05d', i)],'C1','C2');
    load([Direct 'Vars/Eps' sprintf('%.3f', eps) '/GradImgs/Grad' sprintf('%05d', i) '.mat'],'Div1','Div2');

    %Run through X and Y locations
    for X=1:Xs
        for Y=1:Ys
            
            %if the current location falls in this image, then bin to hist.
            if(JPDFs(Y,X).Loc==ind) % check to make sure we're in the right image              
                %Define Box that JPDF is defined for
                l=uint16(JPDFs(Y,X).Xpix-floor(Box(2)/2));
                r=uint16(JPDFs(Y,X).Xpix+floor(Box(2)/2));
                b=uint16(JPDFs(Y,X).Ypix-floor(Box(1)/2));
                t=uint16(JPDFs(Y,X).Ypix+floor(Box(1)/2));
                
                %Define Each Box
                C1s=C1(b:t,l:r);C1s(C1s<eps)=0;C1s=C1s(:);
                C2s=C2(b:t,l:r);C2s(C2s<eps)=0;C2s=C2s(:);

                Div1s=Div1(b:t,l:r);Div1s=Div1s(:);
                Div2s=Div2(b:t,l:r);Div2s=Div2s(:);
                    
                %Detrmine Bin Locations
                Xbins=round( C1s/dBin )+1;Xbins(Xbins<1)=1;Xbins(Xbins>(Cs))=(Cs);
                Ybins=round( C2s/dBin )+1;Ybins(Ybins<1)=1;Ybins(Ybins>(Cs))=(Cs);
                
                %Add To hists
                Div1Hist(:,:)=accumarray([Ybins, Xbins],Div1s,[Cs Cs]);
                Div2Hist(:,:)=accumarray([Ybins, Xbins],Div2s,[Cs Cs]);
                jpdfHist(:,:)=accumarray([Ybins, Xbins],ones(size(Div1s)),[Cs Cs]);

                ConDiffs(Y,X).CD1 =ConDiffs(Y,X).CD1 +Div1Hist;
                ConDiffs(Y,X).CD2 =ConDiffs(Y,X).CD2 +Div2Hist;
                ConDiffs(Y,X).jpdf=ConDiffs(Y,X).jpdf+jpdfHist;
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

%Normalize Conditional Diffuisons based on Counts
for X=1:Xs
    for Y=1:Ys
        ConDiffs(Y,X).CD1=ConDiffs(Y,X).CD1 ./ ConDiffs(Y,X).jpdf;
        ConDiffs(Y,X).CD2=ConDiffs(Y,X).CD2 ./ ConDiffs(Y,X).jpdf;
        ConDiffs(Y,X).jpdf=ConDiffs(Y,X).jpdf ./ sum(ConDiffs(Y,X).jpdf(:));
    end
end

%Save Variables
save(['Vars/Eps' sprintf('%.3f', eps) '/ConDiff' sprintf('%05d', Start(1)) '-' sprintf('%05d', Stop(length(Start)))], 'ConDiffs');  
