function SaveImgPair(Direct,Name,i,I1,I2)

save([Direct Name sprintf('%05d', i)],'-v7.3','I1','I2');