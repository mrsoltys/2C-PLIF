function FindGradE(Direct, Start, Stop,eps)
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
Prefix=[Direct 'Vars/Eps' sprintf('%.3f', eps) '/GradImgs'];
mkdir(Prefix);

% clear B;
%         B(1,:)= [zeros(1,22) linspace(0,1,10) ones(1,22) linspace(1,.5,10)];
%         B(2,:)= [zeros(1,11) linspace(0,1,11) ones(1,20) linspace(1,0,11) zeros(1,11)];
%         B(3,:)= fliplr(B(1,:));
% 
% Figure1=figure(1);clf;
%     set(Figure1,'defaulttextinterpreter','latex')
%     set(Figure1,'PaperUnits','inches','PaperSize',[5.845*2 4.135*2],'PaperPosition',[0,0,5.845*2,4.135*2],...
%         'Units','inches','Position',[1,9,5.845*2,4.135*2]);
%     
% Figure2=figure(2);clf;
%     set(Figure2,'defaulttextinterpreter','latex')
%     set(Figure2,'PaperUnits','inches','PaperSize',[5.845*2 4.135*2],'PaperPosition',[0,0,5.845*2,4.135*2],...
%         'Units','inches','Position',[1,9,5.845*2,4.135*2]);
    
disp(['Finding gradients for ' int2str(Start) '-' int2str(Stop)]);    
load([Direct 'ProcImgs/Proc' sprintf('%05d', Start(1))],'C1','C2')   %Proc Mean
                                                          
EX1=zeros(size(C1));
EX2=zeros(size(C2));
EXsq1=EX1;
EXsq2=EX2;
C1C2=zeros(size(C1));

ind=1;
while ind<=length(Start)
    for i=Start(ind):Stop(ind)
        iStart=tic;
        [C1 C2]=ParLoad([Direct 'ProcImgs/Proc' sprintf('%05d', i)], eps);
        
        [Gx1, Gy1] = imgradientxy(C1);
        [Gx2, Gy2] = imgradientxy(C2);
        Div1 = single(divergence(Gx1, Gy1));
        Div2 = single(divergence(Gx2, Gy2));
        
        %save([Prefix '/Grad' sprintf('%05d', i)],'-v7.3','Gx1','Gy1','Gx2','Gy2','Div1','Div2');%,'C1C2');    
        save([Prefix '/Grad' sprintf('%05d', i)],'-v7.3','Div1','Div2');%,'C1C2');    
%         subaxis(2,3,1);
%             unfreezeColors;
%             imagesc(C1);
%             title('$\Phi_A$');
%             axis image;axis([1000 1200 400 600])
%         subaxis(2,3,2);
%             unfreezeColors;
%             imagesc(sqrt(Gx1.^2+Gy1.^2));
%             title('Magnitude of $\nabla\Phi_A$');
%             axis image;axis([1000 1200 400 600]);
%             caxis([0 1]);colormap(flipud(gray));freezeColors;
%         subaxis(2,3,3);
%             unfreezeColors;
%             imagesc(Div1);
%             title('$\nabla^2\Phi_A$');
%             axis image;axis([1000 1200 400 600]);
%             caxis([-.5 .5]);colormap(B'); freezeColors;
%         subaxis(2,3,4);
%             unfreezeColors;
%             imagesc(C2);
%             title('$\Phi_B$');
%             axis image;axis([1000 1200 400 600])
%         subaxis(2,3,5);
%             unfreezeColors;
%             imagesc(sqrt(Gx2.^2+Gy2.^2));
%             title('Magnitude of $\nabla\Phi_B$');
%             axis image;axis([1000 1200 400 600]);
%             caxis([0 1]);colormap(flipud(gray));freezeColors;
%         subaxis(2,3,6);
%             unfreezeColors;
%             imagesc(Div2);
%             title('$\nabla^2\Phi_B$');
%             axis image;axis([1000 1200 400 600]);
%             caxis([-.5 .5]);colormap(B'); colorbar('location','South');freezeColors;
%         figure(Figure2)        
%         subaxis(1,2,1);
%             unfreezeColors;
%             imagesc(C1.*C2);
%             title('$\Phi_A\Phi_B$');
%             axis image;axis([1000 1200 400 600]);
%             colormap(flipud(gray));freezeColors;
%         subaxis(1,2,2);
%             unfreezeColors;
%             imagesc(Div1.*Div2);
%             title('$\left(\nabla^2\Phi_A\right)\left(\nabla^2\Phi_B\right)$');
%             axis image;axis([1000 1200 400 600]);
%             caxis([-.25 .25]);colormap(B'); colorbar('location','South');freezeColors;
        
    end
    
    ind=ind+1;
end



%save([Prefix '/ProcMeansE' sprintf('%05d', Start(1)) '-' sprintf('%05d', Stop(length(Start)))], 'mean1', 'mean2', 'RMSE1', 'RMSE2', 'C1C2', 'Cov');   %Proc Mean
%FindRmsCovE(Direct, Start, Stop,eps);
end
