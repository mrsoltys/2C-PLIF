function Mean=FindMeanE(Direct, Start, Stop,eps)
%--------------------------------------------------------------------------------%
% FindMeanE 
% Finds the mean of a series of processed images, filtered with some threhold value
% denoted by epsilon (eps).  For example, if data is scaled from 0-1 and eps is .01,
% All data below 0.01 will be set to zero.
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
%--------------------------------------------------------------------------------%
disp(['Finding mean for ' int2str(Start) '-' int2str(Stop)]);

load([Direct 'ProcImgs/Proc' sprintf('%05d', Start(1))],'C1','C2')   %Proc Mean
                                                          
mean1=zeros(size(C1));
mean2=zeros(size(C2));

ind=1;
i=Start(ind);
while ind<=length(Start)
    load([Direct 'ProcImgs/Proc' sprintf('%05d', i)],'C1','C2')
    
    mean1=mean1+C1.*(C1>=eps);
    mean2=mean2+C2.*(C2>=eps);
    
    %Display Progress
%    stopBar= progressbar((i-Start+1)/(Stop-Start),5);
%       if (stopBar) break; end
    
    if i==Stop(ind)
        ind=ind+1;
        if ind<=length(Start)
            i=Start(ind);
        end
    else
        i=i+1;
    end
end

mean1=mean1./(sum(Stop-Start)+length(Start));
mean2=mean2./(sum(Stop-Start)+length(Start));

save([Direct 'Vars/ProcMeansE' sprintf('%05d', Start(1)) '-' sprintf('%05d', Stop(length(Start)))], 'mean1', 'mean2');   %Proc Mean

Mean=[mean1 mean2];
 