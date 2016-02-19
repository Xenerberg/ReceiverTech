function [correlation] = fn_PCPS(F_IF,f_D,sampled_CA, signal_CA,t)
    carrier_sin = sin(2*pi*(F_IF + f_D)*t);
    carrier_cos = cos(2*pi*(F_IF + f_D)*t);
    I_CA = carrier_cos.*sampled_CA;
    Q_CA = carrier_sin.*sampled_CA;
    realpart = fcxcorr( signal_CA, I_CA)/(norm(signal_CA)*norm(I_CA));
    imagpart = fcxcorr( signal_CA, Q_CA)/(norm(signal_CA)*norm(I_CA));
%     I_comp = signal_CA.*carrier_sin;
%     Q_comp = signal_CA.*carrier_cos;

    %signal_complex = complex(I_comp,Q_comp);
    %Z = fcxcorr( signal_complex, sampled_CA);
    correlation = sqrt((realpart).^2 + (imagpart).^2);
end

