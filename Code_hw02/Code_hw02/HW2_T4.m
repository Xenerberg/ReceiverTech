close all; clear all; clc

prn = 1;
Ts = 1/5714e3;
tk = 0:Ts:10;
tk = reshape( tk(1:end-1)' , 5714 , [] )';

delay = 201.3;

CN0 = 50;
iniCarrPhase = pi/2 + degtorad(10*tk(:,1)); % [cycles]
doplr = 3e3;

ca = caCodeGen(prn);

for ii = 1:length(1e4)
    rcvSig(ii,:) = SigGen4loop( ca, iniCarrPhase(ii), doplr, CN0, tk(ii,:) );
end