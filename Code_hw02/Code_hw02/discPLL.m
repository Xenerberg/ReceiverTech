function [ pll_p4Quad,pll_cClasc,pll_cDecsn,pll_cOptim,pll_c2Quad  ] = discPLL( pI, pQ )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
maxI = abs(max(sqrt(pI(:).^2 + pQ(:).^2)));

pll_p4Quad = rad2deg( atan2(pQ,pI) );

pll_c2Quad = rad2deg( atan(pQ./pI) );
pll_cClasc = rad2deg( pQ.*pI/(maxI^2) );
pll_cDecsn = rad2deg( pQ.*sign(pI)/maxI );
pll_cOptim = rad2deg( max(min((pQ./pI),2*pi),-2*pi) );
end