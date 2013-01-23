function [C1 C2]=ParLoad(FileName, eps)
% Loads C1 and C2 and does eps scaling so parfor can't see whats going on
% and freak out
    load(FileName,'C1','C2');
    if eps~=-Inf
        C1(C1<=eps)=0;
        C2(C2<=eps)=0;
    end
end