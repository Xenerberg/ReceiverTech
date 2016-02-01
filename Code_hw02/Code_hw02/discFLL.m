function [ fllOptim, fllDecsn, fll4Quad ] = discFLL( pI1, pI2, pQ1, pQ2 )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

s1Max = abs(max( sqrt(pI1(:).^2 + pQ1(:).^2) ));
s2Max = abs(max( sqrt(pI2(:).^2 + pQ2(:).^2) ));
max12 = s1Max * s2Max;
cross = ((pI1.*pQ2) - (pI2.*pQ1))/max12;
dot = ((pI1.*pQ2) + (pI2.*pQ1))/max12;
T = 2*pi*1e-3;

fllOptim = max( min( (cross / T) , 50),-50);
fllDecsn = max( min( (cross .* sign(dot) / T) , 50),-50);
fll4Quad = max( min( (atan2(cross,dot) / T) , 50),-50);

end