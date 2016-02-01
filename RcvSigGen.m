function [ GeneratedIncomingIF ] = RcvSigGen( code_delay, init_carrier_phase, Doppler, CN0 )
    f0 = 10.23e6;
    f_IF = 154*f0;
    f_D = Doppler;
    code_delay = 201.3;%chips
    PRN = 1;
    length = 1e-3;
    Fs = 5.714e6;
    Ts = 1/Fs;
    
    P = fn_db2Power(-158.5);%dB
    CN0 = fn_db2Power(CN0);
    sigma = sqrt(f_IF*P/CN0);
    D = 1; %Data bit is considered as 1
    %Generate carrier
    [carrier] = fn_CreateCarrier(f_IF,f_D,length,Ts,0);    
    n_carrierShift = init_carrier_phase*1/Ts;
    carrier = circshift(carrier,[0,n_carrierShift]);
    %Generate shifted sampled CA code
    CA = ShiftedSampledCA(PRN,Ts,code_delay*0.001/1023)';
    %Generate noise
    noise = AWGN(0,sigma,0.001/Ts);
   
    GeneratedIncomingIF = sqrt(2*P)*D*CA.*carrier;
    
end

