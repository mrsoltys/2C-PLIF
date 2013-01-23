function [mean1 mean2]=FindMeanE(Direct, Start, Stop,eps)
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
                                                          
Mean1=zeros(size(C1));
Mean2=zeros(size(C2));

ind=1;
while ind<=length(Start)
    parfor i=Start(ind):Stop(ind)
        [C1 C2]=ParLoad([Direct 'ProcImgs/Proc' sprintf('%05d', i)], eps)
        
        Mean1=Mean1+C1;
        Mean2=Mean2+C2;
    end
    
    %Display Progress
%    stopBar= progressbar((i-Start+1)/(Stop-Start),5);
%       if (stopBar) break; end
    
    ind=ind+1;
end

mean1=Mean1./(sum(Stop-Start)+length(Start));
mean2=Mean2./(sum(Stop-Start)+length(Start));

save([Prefix '/ProcMeansE' sprintf('%05d', Start(1)) '-' sprintf('%05d', Stop(length(Start)))], 'mean1', 'mean2');   %Proc Mean
FindRmsCovE(Direct, Start, Stop,eps);
end