function [ shiftedSampledCA ] = shiftedSampledCode( prn, Ts, shift )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

goldRate = 1.023e6;
tc = 1/goldRate; % chip length

fs = 1/Ts; % sampling freqz
ca = caCodeGen(prn);
nt = tc/Ts; % sampled T
ll = 1:length(ca);

ntt(1,:) = [1 floor(nt.*ll(1:end-1))];
ntt(2,:) = floor(nt.*ll);

for ii = 1:length(ca)
    sampledCA(ntt(1,ii):ntt(2,ii)) = ca(ii);
end

sampShift = round(shift* nt);
% shiftedSampledCA = [sampledCA(sampShift+1:end) sampledCA(1:sampShift)];
switch (sampShift>0)
    case 1
        shiftedSampledCA = [sampledCA(end-(sampShift-1):end) sampledCA(1:end-sampShift)];
    case 0
        shiftedSampledCA = [sampledCA(abs(sampShift)+1:end) sampledCA(1:abs(sampShift))];
end

end