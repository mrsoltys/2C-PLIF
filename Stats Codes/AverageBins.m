function [OutputData Centers] = AverageBins(InputData,InputXs,BinSize)


L=length(InputData);
R=rem(L,BinSize);


if R==0     % If the number of bins fits into the size of the aray
    i=1;
    j=1;
else        % otherwise, stick fractions of bins on the front and back. 
            % If the remainder is odd, the front fraction will be 1 larger
            % than the back fraction.
            
    i=ceil(R/2);
    OutputData(1)=mean(InputData(1:i));
    j=2;
    Centers(1)=(InputXs(1)+InputXs(i))/2;
    i=i+1;
end


% While there is enough room for a full bin, take the mean of the bin, and
% locate the center of the bin.

while (i+BinSize)<=L
    OutputData(j)=mean(InputData(i:(i+BinSize)));
    Centers(j)=(InputXs(i)+InputXs(i+BinSize))/2;
    i=i+BinSize+1;
    j=j+1;
    
end

% If there's any remanding data, throw it in a bin at the end
if i<L
    OutputData(j)=mean(InputData(i:L));
    Centers(j)=(InputXs(i)+InputXs(L))/2;
end

end