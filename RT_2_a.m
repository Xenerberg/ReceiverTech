%Generate IF signal
clear all;
Ts = 1/(5.714e6);
Fs = 1/Ts;
t = 0:1/Fs:0.001 - 1/Fs; t= t';
f0 = 10.23e6;
f_IF = 154*f0;
code_delay = 2;
doppler = 0;
carrier_init_phase = 0;
CN0 = 45.5;
GeneratedIncomingIF = RcvSigGen(code_delay,carrier_init_phase,doppler,CN0);

range_code_delay = -2:0.5:2;
range_doppler = -3e3:250:3e3; 
range_carrier_phase = 0%-1:0.5:1;
range_carrier_phase = range_carrier_phase*1/f_IF;
%Correlation_maps = zeros(size(range_code_delay,2),size(range_doppler,2),size(range_carrier_phase,2));
counter_1 = 0;
counter_2 = 0;
counter_3 = 0;

v_satellites = [1];
sv_Count = 0;
n_CA_samples = 0.001*Fs;
n_freq_bins = 6000/250;
for sv = v_satellites %change to 32
   sv_Count  = sv_Count + 1;
   i_Count = 0;
   corr_PRN = zeros(n_CA_samples,n_freq_bins);
   sampled_CA = ShiftedSampledCA(sv,1/Fs,0)';
   for f_D = -3e3:250:3e3
        i_Count = i_Count+1;
        carrier_sin = sin(2*pi*(f_IF + f_D)*t);
        carrier_cos = cos(2*pi*(f_IF + f_D)*t);
        I_comp = GeneratedIncomingIF.*carrier_sin;
        Q_comp = GeneratedIncomingIF.*carrier_cos;
        
        signal_complex = complex(I_comp,Q_comp);
        Z = fcxcorr( signal_complex, sampled_CA);
        corr_amp = sqrt(real(Z).^2 + imag(Z).^2);
        corr_PRN(:,i_Count) = corr_amp;        
   end
   Correlation_maps(:,:,sv_Count) = corr_PRN; 
   [max_corr, pos] = max(corr_PRN(:));
   [code_phase_pos, dopp_offset_pos] = ind2sub(size(corr_PRN),pos);
   v_dopp(sv_Count) = dopp_offset_pos;
   v_code(sv_Count) = code_phase_pos;
   v_max(sv_Count) = max_corr;
   
end

%Carrier phase tracking

    

