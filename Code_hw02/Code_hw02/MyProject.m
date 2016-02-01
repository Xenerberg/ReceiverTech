classdef MyProject < handle
%    properties (Constant)
%       ProjectInfo = MyProject;
%    end
   properties
      Add
      Sub
   end
   methods %(Access = private)
      function obj = MyProject()
%           obj.Add;
%           obj.Sub;         
      end
      
      function addition ( obj, h, j)
          obj.Add = h + j;
          obj.Sub = h - j;
      end
   end
end

% obj = MyProject(4,5);
% obj.addition(4,5)

classdef hw2 < handle
    properties
    noise   
    end
   
    properties (Constant)
    Ts = 1/5714e3;
    tk = 0:hw2.Ts:((1e-3)-hw2.Ts);
    fif = 4.3e6;
    Dt = 1;
%     num = 1e-3/Ts;
    pow = db2pow(-158.5); % minimum received P_ca= -158.5 dB (page: 133)          
    meu = 0;
    
    end
   
   methods
      function p = hw2()   
      end     

      function AWGN( p,num,CN0 )
          import constants.*;
          CN0 = db2pow(CN0);
          noiseP = hw2.fif * hw2.pow/db2pow(CN0);
          stdev = sqrt(noiseP);
          p.noise = p.meu+stdev.*randn(1,num);
      end
      
      function rcvSig = rcvSigGen( ca, iniCarrPhase, doplr )
          import constants.*;
          nois = AWGN( p,num,CN0 );
          rcvSig = (sqrt(2*hw2.pow)*hw2.Dt.*ca.*cos((2*pi*(hw2.fif+doplr).*hw2.tk)+iniCarrPhase))+ nois;
      end
   end    
end