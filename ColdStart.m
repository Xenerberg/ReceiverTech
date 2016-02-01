clear all; 
close all;
load('IncomingIF.mat');

Fs = 5.714e6;
Ts = 1/Fs;
incoming_1ms_IF = IncomingIF(1,:);
incoming_1ms_IF = incoming_1ms_IF';
sv = [32;32];
code_bin = 2/5.585532746823070;
doppler_bin = 500;
doppler_range = [-10000,10000];
n_doppler_bins = ceil((doppler_range(2) - doppler_range(1))/doppler_bin);
n_CA_samples = Fs*0.001; %Number of samples in 1ms.
   for sv_counter = sv(1):sv(2)
      %Implementatation of Time-frequency search
      for code_delay = 0:code_bin:1023
         %create the code replica with sv_counter and code_delay values
         delayed_SampledCA = ShiftedSampledCA(sv_counter, Ts, code_delay);
         delayed_SampledCA = delayed_SampledCA';
         for frequency_counter = -10000:doppler_bin:10000
           carrier_sin = fn_CreateCarrier(Fs, frequency_counter, 1e-3, Ts, 0);
           carrier_cos = fn_CreateCarrier(Fs, frequency_counter, 1e-3, Ts, 1);
           I_comp = carrier_sin.*delayed_SampledCA;
           Q_comp = carrier_cos.*delayed_SampledCA;
           generatedCA_complex = complex(I_comp, Q_comp);  
           Z = fn_fctCorrelate(generatedCA_complex,incoming_1ms_IF); 
           metric(ceil(code_delay/code_bin) + 1,(frequency_counter+10000)/doppler_bin + 1,sv_counter) = imag(Z)^2 + real(Z)^2;
         end
      end
   end


%Implementation of  Parallel Code Phase search

v_satellites = 1:32;
Correlation_MAP = zeros(n_CA_samples,n_doppler_bins+1,length(v_satellites));
v_dopp = zeros(length(v_satellites),1);
v_code = v_dopp;
v_max = v_code;
sv_Count = 0;
t_CA = 0.001; %s
t = 0:1/Fs:t_CA - 1/Fs; t= t';
for sv = v_satellites %change to 32
   sv_Count  = sv_Count + 1;
   i_Count = 0;
   corr_PRN = zeros(n_CA_samples,n_doppler_bins+1);
   sampled_CA = ShiftedSampledCA(sv,1/Fs,0)';
   for f_D = doppler_range(1):doppler_bin:doppler_range(length(doppler_range))
        i_Count = i_Count+1;        
        corr_PRN(:,i_Count) = fn_PCPS(Fs,f_D,sampled_CA,incoming_1ms_IF,t);        
   end
   Correlation_MAP(:,:,sv_Count) = corr_PRN; 
   [max_corr, pos] = max(corr_PRN(:));
   [code_phase_pos, dopp_offset_pos] = ind2sub(size(corr_PRN),pos);
   v_dopp(sv_Count) = dopp_offset_pos;
   v_code(sv_Count) = code_phase_pos;
   v_max(sv_Count) = max_corr;
   
end

