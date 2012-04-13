function FindRmsCovE(Direct, Start, Stop,eps)
%--------------------------------------------------------------------------------%
% FindRmsCovE
% Finds the Root Mean Square Error, Covariance <c1c2>, and Reaction Product <C1C2> 
% of a series of processed images, filtered with some threhold value
% denoted by epsilon (eps).  For example, if data is scaled from 0-1 and eps is .01,
% All data below 0.01 will be set to zero.  if no eps is defined, eps is
% set to -Inf
%
% To calculate the stats of mulitple data ranges, set start and stop to vectors
% containing the ranges.  Example, to find the stats of images 1-10 and 35-70, call
% FindRmsCovE(Direct,[1 35],[10 70],eps)
%
% Direct is the directory path to find the stats for.  If your current path is the
% correct Directory, set path to: ''
%
% Dependancies: 
% FindRmsCovE requires a directy of Processed Images located at ProcImgs/Proc****.m
% FindRmsCovE requires that the means already have been claculated, and stored in a file
% named as: 
% [Direct 'Vars/ProcMeansE'  sprintf('%05d', Start(1)) '-' sprintf('%05d', Stop(length(Start)))]
%
% Output:
% Wil save two files, one named 
% [Direct 'Vars/CovE' sprintf('%05d', Start(1)) '-' sprintf('%05d', Stop(length(Start)))]
% containing <C1C2> and <c1c2> and another named
% [Direct 'Vars/RMSEe' sprintf('%05d', Start(1)) '-' sprintf('%05d', Stop(length(Start)))]
% containing the variances for each.

%--------------------------------------------------------------------------------%
    if nargin == 3
        eps = -Inf;
    end

Prefix=[Direct 'Vars/Eps' sprintf('%.3f', eps)];

disp(['Finding <c1c2> for ' int2str(Start) '-' int2str(Stop)]);

load([Prefix '/ProcMeansE'  sprintf('%05d', Start(1)) '-' sprintf('%05d', Stop(length(Start)))], 'mean1', 'mean2');

Cov=zeros(size(mean1));
C1C2=Cov;
RMSE1=Cov;
RMSE2=Cov;


ind=1;
i=Start(ind);
while ind<=length(Start)
    load([Direct 'ProcImgs/Proc' sprintf('%05d', i)],'C1','C2');
        C1(C1<=eps)=0;
        C2(C2<=eps)=0;

    RMSE1=RMSE1+(C1-mean1).^2;
    RMSE2=RMSE2+(C2-mean2).^2;
    C1C2=C1C2+C1.*C2;
    Cov=Cov+(C1-mean1).*(C2-mean2);
        
    if i==Stop(ind)
        ind=ind+1;
        if ind<=length(Start)
            i=Start(ind);
        end
    else
        i=i+1;
    end
end


C1C2=C1C2./(sum(Stop-Start)+length(Start));
Cov=Cov./(sum(Stop-Start)+length(Start));
RMSE1=sqrt(RMSE1./(sum(Stop-Start)+length(Start)));
RMSE2=sqrt(RMSE2./(sum(Stop-Start)+length(Start)));

save([Prefix '/CovE'  sprintf('%05d', Start(1)) '-' sprintf('%05d', Stop(length(Start)))], 'Cov', 'C1C2');
save([Prefix '/RMSEe' sprintf('%05d', Start(1)) '-' sprintf('%05d', Stop(length(Start)))], 'RMSE1', 'RMSE2');
end