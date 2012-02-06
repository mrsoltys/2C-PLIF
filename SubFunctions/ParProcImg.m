function [C1 C2]=ParProcImg(Direct,i, b1, b2, B1, B2, D1, D2, Lambda1, Lambda2)

        %Load Images
       load([Direct 'TransImgs/Trans'  sprintf('%05d', i)],'I1','I2');
            I1 = double( I1 );
            I2 = double( I2 );
        
        %Correct Images
            %% Correct I1:
            C1= b1*(I1-B1-Lambda2.*(I2-B2))./...
                   (B1-D1-Lambda2.*(B2-D2));           
            %% Correct I2 (Leakage)
            C2= b2*(I2-B2-Lambda1.*(I1-B1))./...
                   (B2-D2-Lambda1.*(B1-D1));           
            
            %imwrite(Img,[Direct 'ComboImgs/Combo'  sprintf('%05d', i) '.jpg']);
            C1=single(C1);
            C2=single(C2);
            %C1C2=single(C1C2);
        %Save Processed Images
            save([Direct 'ProcImgs/Proc' sprintf('%05d', i)],'-v7.3','C1','C2');%,'C1C2');
            
end