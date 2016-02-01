classdef cGen < handle
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    ca
    end
    
    properties (Constant)
    codPhas = [2:5 1 2 1 2 3 2 3 5:9 1:6 1 4:7 8 1:4; 6:9 9 10 8:10 3 4 6:10 4:9 3 6:10 6:9]';          
    varCod = [1440 1620 1710 1744 1133 1455 1131 1454 1626 1504 1642 ...
              1750 1764 1772  1775 1776 1156 1467 1633 1715 1746 1763 ...
              1063 1706 1743 1761 1770 1774 1127 1453 1625 1712];       
    tc = 1/1.023e6; % chip length
    end
    
    methods
        function obj = cGen()
        end
        
        function caCodeGen (obj, prn)
            import constans.*
            codSel = cGen.codPhas(prn,:);
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
            caCode = gOne.*gTwo;
            caCode(caCode==1)=0;
            caCode(caCode==-1)=1;
            obj.ca = caCode;
        end
        
        function sampledCAcode( obj, prn, Ts )
            import constans.*;
            caCode = caCodeGen(prn);
            nnt = cGen.tc / Ts;
            ll = 1:length(caCode);
            ntt(1,:) = [1 floor(nnt*ll(1:end-1))];
            ntt(2,:) = floor(nnt*ll);
            for ii = 1:length(caCode)
                obj.ca(ntt(1,ii):ntt(2,ii)) = caCode(ii);
            end
        end
        
        function shiftedSampledCode( obj, prn, Ts, shift )
            import constans.*;
            nnt = cGen.tc / Ts;
            sampledCA = sampledCAcode( prn, Ts );
            sampShift = round(shift * nnt);
            switch (sampShift>0)
                case 1
                    obj.ca = [sampledCA(end-(sampShift-1):end) sampledCA(1:end-sampShift)];
                case 0
                    obj.ca = [sampledCA(abs(sampShift)+1:end) sampledCA(1:abs(sampShift))];
            end
        end
    end
end

