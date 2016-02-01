classdef hw2 < handle
    
    properties
    noise
    rcvSig
    end
   
    properties (Constant)
    PIT = 1e-3; 
    prn = 20;
    Ts = 1/5714e3;
    tk = (0:hw2.Ts:((1e-3)-hw2.Ts));
    tk2 = (0:hw2.Ts:((1e-3)-hw2.Ts)) + PIT;
    delay = 2;
    CN0 = 50;
    iniCarrPhase = 0;
    doplr = 0;
    fif = 4.3e6;
    Dt = 1;
    num = (1e-3)/hw2.Ts;
    end
    
    methods
        function p = hw2()   
        end
      
        function rcvSigGen(p, ca, iniCarrPhase, doplr, CN0)
        import constants.*;


        pow = db2pow(-158.5); % minimum received P_ca= -158.5 dB (page: 133)
        CN0 = db2pow(CN0);
        noiseP = fif * pow/CN0;
        stdev = sqrt(noiseP);
        mean = 0;

        nois =  AWGN( mean,stdev,num );
        p.rcvSig = ( sqrt(2*pow)*hw2.Dt.*ca.*cos((2*pi*(hw2.fif+hw2.doplr).*hw2.tk)+iniCarrPhase) ) ...
                 + nois;

        end
        
        function AWGN( p,meu,stdev,num )
            p.noise = meu + stdev.*randn(1,num);
        end           

   end    
end

