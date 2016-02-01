function [ rcvSig ] = rcvSigGen( ca, iniCarrPhase, doplr, CN0 )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

Ts = 1/5714e3;
tk = 0:Ts:1e-3; tk = tk(1:end-1);
fif = 4.3e6;
Dt = 1;
num = 1e-3/Ts;

pow = db2pow(-158.5); % minimum received P_ca= -158.5 dB (page: 133)
CN0 = db2pow(CN0);
noiseP = fif * pow/CN0;
stdev = sqrt(noiseP);
mean = 0;

noise =  AWGN( mean,stdev,num );
rcvSig = ( sqrt(2*pow)*Dt.*ca.*cos((2*pi*(fif+doplr).*tk)+iniCarrPhase) ) ...
         + noise;

end