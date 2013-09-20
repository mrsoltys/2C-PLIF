function [Conc]=bin_Particles(Xpos,Ypos,Ms,L,dx)
%-------------------------------------------------------------------------%
% PDF2d(C1, C2, nBins)
% Required Inputs:
%   Xpos:         1 x n vector of particles X locations.
%   Ypos:         1 x n vector of particles y locations.
%   Ms:           1 x n vector of particles masses
%
%   L:            The domain will reach from -L to L in both x and y
%   dx:           The domain will be broken into dx sized bits.
%  
% output:
%   Conc:     a (2L/dx+1) X (2L/dx+1) matrix with concentrations
%               
%-------------------------------------------------------------------------%

%Size of matrix
    Sz_x=int32(2*L/dx); %I thought these had
    Sz_y=int32(2*L/dx);

%Detrmine Bin Locations
    Xs=round(( Xpos+L)*L/dx )+1;Xs(Xs<1)=1;Xs(Xs>(1+2*L/dx))=(1+2*L/dx);
    Ys=round(( Ypos+L)*L/dx )+1;Ys(Ys<1)=1;Ys(Ys>(1+2*L/dx))=(1+2*L/dx);
                
%Add To hists
	Conc(:,:)=accumarray([Ys, Xs],Ms,[Sz_y Sz_x]);
    
end
