%Create a carrier wave
f0 = 10.23e6;
f_IF = 154*f0;
f_D = 3e3;
code_delay = 201.3;%chips
PRN = 1;
length = 1e-3;
Ts = 1/f_IF;
[carrier] = fn_CreateCarrier(f_IF,f_D,length,Ts,0);
CA = ShiftedSampledCA(PRN,Ts,code_delay*1/Ts);
