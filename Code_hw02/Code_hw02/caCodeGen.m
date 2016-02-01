function [ codeCA ] = caCodeGen (prn)
% "caCodeGen" function, generates the CA code for the user selected PRN
% CA code generation
% by Hunaiz Ali (ESPACE-13/14)
% ___________________________________________________ %

codPhas(:,1) = [2:5 1 2 1 2 3 2 3 5:9 1:6 1 4:7 8 1:4]';
codPhas(:,2) = [6:9 9 10 8:10 3 4 6:10 4:9 3 6:10 6:9]';
codSel = codPhas(prn,:); % select code phase, corrressponds to selected PRN
varCod = [1440 1620 1710 1744 1133 1455 1131 1454 1626 1504 1642 ...
          1750 1764 1772  1775 1776 1156 1467 1633 1715 1746 1763 ...
          1063 1706 1743 1761 1770 1774 1127 1453 1625 1712];
% generate g1
reg = -ones(1,10);
for ii = 1:1023
    gOne(ii) = reg(10);
    mod = reg(3)*reg(10); % modulo
    reg(2:end) = reg(1:9);
    reg(1) = mod;
end
% generate g2
reg = -ones(1,10);
for ii = 1:1023
    gTwo(ii) = reg(codSel(1))*reg(codSel(2));
    mod = reg(2)*reg(3)*reg(6)*reg(8)*reg(9)*reg(10);
    reg(2:end) = reg(1:9);
    reg(1) = mod;
end
% generate C/A code
codeCA = gOne.*gTwo;
ca = codeCA;
ca((ca==1))=0;
ca((ca==-1))=1;

end