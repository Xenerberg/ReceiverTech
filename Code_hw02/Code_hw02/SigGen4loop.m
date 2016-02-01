function [rcvSig] = SigGen4loop(ca,iniCarrPhase,doplr,CN0,carrier)

Ts = 1/5714e3;
fif = 4.3e6;
Dt = 1;
num = (1e-3)/Ts;

pow = db2pow(-158.5); % minimum received P_ca= -158.5 dB (page: 133)
CN0 = db2pow(CN0);
noiseP = fif * pow/CN0;
stdev = sqrt(noiseP);
mean = 0;

noise =  AWGN( mean,stdev,num );
rcvSig = ( sqrt(2*pow)*Dt.*ca.*carrier ) ...
         + noise;

end