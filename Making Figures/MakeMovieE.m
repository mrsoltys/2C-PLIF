function []=MakeMovieE(Direct,Start,Stop,MovieName, FPS,eps)

load([Direct 'Vars/PreRunVars.mat'], 'ImgStart', 'SetStop');
if nargin == 1, Start=ImgStart; Stop=SetStop(1); end
load([Direct 'Vars/Istats'  sprintf('%05d', Stop)],'I1max','I2max');
    Sc1=trimmean(max(I1max),.25);
    Sc2=trimmean(max(I2max),.25);


% create the AVI file object, set fps, compression, etc.
    aviFileName = [MovieName];
    aviobj = VideoWriter(aviFileName);
    aviobj.FrameRate=FPS;
    open(aviobj);
    
    for i=Start:Stop
        %Load Image and Scale
        load([Direct 'ProcImgs/Proc' sprintf('%05d', i)],'C1','C2');
        C1=C1./Sc1;
        C2=C2./Sc2;
        %Set <eps to 0 and >1 to 1
        C1s=C1.*(C1>eps).*(C1<=1)+double(C1>1);
        C2s=C2.*(C2>eps).*(C2<=1)+double(C2>1);
        %Color Change
        Img=ColorChangeWhite(C1s,C2s);
%         Img(:,:,1)=C1.*(C1>eps).*(C1<=1)+double(C1>1);
%         Img(:,:,2)=zeros(size(C1));
%         Img(:,:,3)=C2.*(C2>eps).*(C2<=1)+double(C2>1);
        
        Img=double(Img);
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
    
