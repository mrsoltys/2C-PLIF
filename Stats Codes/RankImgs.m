function [Rank]=RankImgs(Direct, Start, Stop,eps)
%--------------------------------------------------------------------------------%
% FindMeanE 
% Finds the mean of a series of processed images, filtered with some threhold value
% denoted by epsilon (eps).  For example, if data is scaled from 0-1 and eps is .01,
% All data below 0.01 will be set to zero. If no eps is defined, eps is set
% to -Inf
%
% To calculate the means of mulitple data ranges, set start and stop to vectors
% containing the ranges.  Example, to find the mean of images 1-10 and 35-70, call
% FindMeanE(Direct,[1 35],[10 70],eps)
%
% Direct is the directory path to find the means for.  If your current path is the
% correct Directory, set path to: ''
%
% Dependancies: 
% FindMeanE requires a directy of Processed Images located at ProcImgs/Proc****.m
%
% output:
% FindMeanE will return the mean in a matrix the same size and C1 and C2.
% the function will also output a file named
% [Direct 'Vars/ProcMeansE' sprintf('%05d', Start(1)) '-' sprintf('%05d', Stop(length(Start)))]
% containing matricies for mean1 and mean2.
%
% Updated 12/7/12 to support parallel processing
%--------------------------------------------------------------------------------%
    if nargin == 3
        eps = -Inf;
    end
Prefix=[Direct 'Vars/Eps' sprintf('%.3f', eps)];
mkdir(Prefix);


disp(['Finding mean for ' int2str(Start) '-' int2str(Stop)]);

load([Direct 'ProcImgs/Proc' sprintf('%05d', Start(1))],'C1','C2')   %Proc Mean
load([Prefix '/ProcMeansE' sprintf('%05d', Start(1)) '-' sprintf('%05d', Stop(length(Start)))], 'mean1', 'mean2');


C1C2=zeros(size(C1));
Rank=[];
ind=1;
while ind<=length(Start)
    for i=Start(ind):Stop(ind)
        [C1 C2]=ParLoad([Direct 'ProcImgs/Proc' sprintf('%05d', i)], eps);
        Cov=(C1-mean1).*(C2-mean2);
        C1C2=C1.*C2;
        
        Temp(i).ImgNo=i;
        Temp(i).C1C2tot=sum(C1C2(:));
        Temp(i).C1C2max=max(C1C2(:));
        Temp(i).C1C290 =prctile(C1C2(:),90);
        
        Temp(i).CovMean=mean(Cov(:));
        Temp(i).CovStd =std(Cov(:));
        Temp(i).MaxCov =max(Cov(:));
        Temp(i).MinCov =min(Cov(:));
        Temp(i).Cov90  =prctile(Cov(:),90);
    end
    Rank=[Rank Temp(Start(ind):Stop(ind))];
    ind=ind+1;
end


save([Prefix '/ImgRanks' sprintf('%05d', Start(1)) '-' sprintf('%05d', Stop(length(Start)))], 'Rank');   %Proc Mean
%FindRmsCovE(Direct, Start, Stop,eps);
end



% Xsq=zeros(Size);
% X  =zeros(Size);
% 
% %sigma=sqrt(E(X^2)-(E(X))^2)
% for i=Start:Stop
%     %Load Background
%     B=double(imread(['RawImgs/' C1Dir(i).name]));
%     % Add
%     X=X+B;    
%     Xsq=Xsq+B.^2;
% end;
% EXsq=Xsq/(Stop-Start+1);
% EX=X/(Stop-Start+1);
% 
% Mean=EX;
% StdDev=sqrt(EXsq-EX.^2);