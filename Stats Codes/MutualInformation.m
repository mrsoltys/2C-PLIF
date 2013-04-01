function [MI,Hx,Hy,Hxy] = MutualInformation(Pxy)
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs:       JPDF    - a joint probabibilty matrix of X and Y

% Outputs:      Hx      - Entropy of X
%               Hy      - Entropy of Y
%               Hxy     - Joint Entropy of X and Y
%               MI      - Mutual Information between X and Y

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Sz=size(Pxy);

% Collapse P(X) and P(Y) from P(X,Y)
Px=sum(Pxy);
Py=sum(Pxy')';

%% Calculate Hx, Hy
% $H(x)=\sum p(x) log2(p(x))$ 
Hx=sum( Px.*log2(Px));
Hy=sum( Py.*log2(Py));

%% Calculate MI
% Make matricies of Px and Py
Px=repmat(Px, Sz(1), 1    );
Py=repmat(Py, 1    , Sz(2));

% $I(x;y)=\sum \sum p(x,y)log2(\frac{p(x,y)}{p(x)p(y)})$ 
MI=Pxy.*log2(Pxy./(Px.*Py));
% set NaNs to zero before summing
MI(isnan(MI))=0;
MI=sum(sum( MI )); %I think?

%% Calculate Hxy
Hxy=Hx+Hy-MI;

end