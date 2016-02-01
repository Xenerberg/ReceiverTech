function [eI,eQ,pI,pQ,lI,lQ] = replicaSigEPL(rcvSig,repCarPhase,repDoplr,cD,prn,repDelay,tk)

Ts = abs( tk(2)-tk(1) );
tk = tk(1:end-1);
len_tk = length(tk);
fif = 4.3e6;

ll = length(repDoplr);
tk = repmat(tk,[ll 1]);

omega_tk = 2*pi*(fif+repmat(repDoplr',[1 len_tk])).*tk;

eI = zeros(length(repDelay), ll, length(repCarPhase)); eQ = eI;
pI = eI; pQ = eI;
lI = eI; lQ = eI;

for jj = 1: length(repDelay)
    
    if (isnan(cD) == 0)
        [ eI(jj,:,:), eQ(jj,:,:) ] = genIQ (prn, Ts, (repDelay(jj)-cD), rcvSig, ll, omega_tk, repCarPhase, len_tk); % early
        [ lI(jj,:,:), lQ(jj,:,:) ] = genIQ (prn, Ts, (repDelay(jj)+cD), rcvSig, ll, omega_tk, repCarPhase, len_tk); % late      
    else
        eI = NaN; eQ = eI; lI = eI; lQ = eI;
    end    
    [ pI(jj,:,:), pQ(jj,:,:) ] = genIQ (prn, Ts, repDelay(jj), rcvSig, ll, omega_tk, repCarPhase, len_tk); % punctual
end

end

function [ I, Q ] = genIQ (prn, Ts, repDelay, rcvSig, ll, omega_tk, repCarPhase, len_tk)
CA = shiftedSampledCode(prn, Ts, repDelay);
caa = length(CA);
rcv = length(rcvSig);

if (caa<rcv)
    bb = rcv-caa;
    CA(end:end+bb) = rcv(end-bb+1:end);
end

signal = repmat(rcvSig.*CA, [ll,1] );
I = [];
Q = I;
for hh = 1:length(repCarPhase)
    I(:,hh) = sum( signal.*cos(omega_tk+repCarPhase(hh)),2 )/len_tk; 
    Q(:,hh) = sum( signal.*sin(omega_tk+repCarPhase(hh)),2 )/len_tk;
end 

end

%     pCA = shiftedSampledCode(prn, Ts, repDelay(jj)); % punctual
%     signal = repmat(rcvSig.*pCA, [ll,1] );
%     for hh = 1:length(repCarPhase)
%         pI(jj,:,hh) = sum( signal.*cos(omega_tk+repCarPhase(hh)),2 )/len_tk;
%         pQ(jj,:,hh) = sum( signal.*sin(omega_tk+repCarPhase(hh)),2 )/len_tk;
%     end 