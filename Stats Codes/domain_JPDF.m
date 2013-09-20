function [JPDF, Centers]=domain_JPDF(C1,C2,nBins)
%-------------------------------------------------------------------------%
% domain_JPDF(C1, C2, nBins)
% Required Inputs:
%   C1 & C2:    Matricies of C1 and C2 concentrations(not particles).  
%               The matricies are normalized so that the max concentration
%               is 1 and the minimum concentration is zero. (concentrations
%               outside this range will be binned into 1 and zero).  The 
%               matricies must be the same size.
% Optional Inputs:
%   nBins:      how many discrete bins you'd like in your JPDF.  
%               If no nBins is specified, the default is 100.
%  
% output:
%   JPDF:       a nBins X nBins matrix with JPDF over entire domain. 
%               probabilities are normalized such that sum(JPDF(:))=1.
%   Centers:    A vector of length nBins that describes the locations of X
%               and Y.
%               
%-------------------------------------------------------------------------%

% If function is called as domain_JPDF(C1,C2), set nBins=100;
    if nargin == 2
        nBins = 100;
    end

% Find size of matricies
    [Rows Cols]=size(C1);

%Find Maximum
    Max=max(max(C1(:)),max(C2(:)));
    if Max>1
        Max=1;
    end
    
% Initialize centers
    Centers=linspace(0,Max,nBins);
    Cs(1)={Centers};
    Cs(2)={Centers};

% Find JPDF
    JPDF(:,:)=hist3([C1(:),C2(:)],Cs);
    
% Should we get rid of the delta function at the origin (remove all points
% where C1=0 and C2=0)?
    JPDF(1,1)=0;

% Normalize by total counts to get Probabilities
    JPDF=JPDF./sum(JPDF(:));

end