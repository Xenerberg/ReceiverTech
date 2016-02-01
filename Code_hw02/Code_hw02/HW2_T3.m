t_interval  = 1000;
los_jerk = 5 * 9.8;
tk_all = 0:Ts:t_interval*PIT;
tk_all = reshape( tk_all(1:end-1)' , N_sample , [] )';
f_d_max = PIT * los_jerk * 1575.24e6 / 3e8;
code_delay_truth = 0;
ini_carrier_phase_truth = degtorad(20);
f_d_truth = nan(1,t_interval);