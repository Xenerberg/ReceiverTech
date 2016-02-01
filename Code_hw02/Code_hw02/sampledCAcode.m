function [ sampledCA ] = sampledCAcode( prn, Ts )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

goldRate = 1.023e6;
tc = 1/goldRate; % chip length

ca = caCodeGen(prn);
nt = tc/Ts;
ll = 1:length(ca);

ntt(1,:) = [1 floor(nt*ll(1:end-1))];
ntt(2,:) = floor(nt*ll);

for ii = 1:length(ca)
    sampledCA(ntt(1,ii):ntt(2,ii)) = ca(ii);
end

end