function []=MakeMovieE(Direct,Start,Stop,MovieName, FPS,eps,Cr)
%Cr [L R T B]
load([Direct 'Vars/PreRunVars.mat'], 'ImgStart', 'SetStop');
if nargin == 1, Start=ImgStart; Stop=SetStop(1); 
elseif nargin == 6, Cr=[0 0 0 0]; end
load([Direct 'ProcImgs/Proc' sprintf('%05d', Start)],'C1','C2');
Size=size(C1);
L=1+Cr(1);
R=Size(2)-Cr(2);
T=1+Cr(3);
B=Size(1)-Cr(4);
% create the AVI file object, set fps, compression, etc.
    aviFileName = [MovieName];
    aviobj = VideoWriter(aviFileName);
    aviobj.FrameRate=FPS;
    open(aviobj);
    
    for i=Start:Stop
        %Load Image and Scale
        load([Direct 'ProcImgs/Proc' sprintf('%05d', i)],'C1','C2');
        C1=C1(T:B,L:R);
        C2=C2(T:B,L:R);
        %Set <eps to 0 and >1 to 1
        C1(C1<eps)=0;C2(C2<eps)=0;
        C1(C1>1)=1;C2(C2>1)=1;
        
        %Color Change
        Img=ColorChangeWhite(C1,C2,.75);
%         Img(:,:,1)=C1.*(C1>eps).*(C1<=1)+double(C1>1);
%         Img(:,:,2)=zeros(size(C1));
%         Img(:,:,3)=C2.*(C2>eps).*(C2<=1)+double(C2>1);
        
        Img=double(Img);
        Img(Img<0)=0;
        Img(isnan(Img))=0;
        f = im2frame(Img); 
        
        writeVideo(aviobj,f);
        %Display Progress
            stopBar= progressbar((i-Start+1)/(Stop-Start+1),5);
            if (stopBar) break; end
    end
    
    % close the avi movie object
     close(aviobj);
end
    
