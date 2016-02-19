stress = 0:.1:5;
theta_tr_dot = 9.81*(2*pi/0.1903)*stress;
bandwidth = (1/1.2)*(theta_tr_dot/0.2).^(1/3);
CN0 = 10*log10(bandwidth/(0.2)^2);
T = 1e-3;
%Thermal Noise jitter
CN0_direct = 10.^(CN0/10);
rho_t_1 = (360/(2*pi))*sqrt(bandwidth(length(bandwidth))./CN0_direct.*(1+1./(2*T*CN0_direct)));
rho_t_2 = (360/(2*pi))*sqrt(bandwidth(2)./CN0_direct.*(1+1./(2*T*CN0_direct)));
rho_t_3 = (360/(2*pi))*sqrt(bandwidth(12)./CN0_direct.*(1+1./(2*T*CN0_direct)));
rho_t_4 = (360/(2*pi))*sqrt(bandwidth(22)./CN0_direct.*(1+1./(2*T*CN0_direct)));
rho_t_5 = (360/(2*pi))*sqrt(bandwidth(32)./CN0_direct.*(1+1./(2*T*CN0_direct)));
rho_t_6 = (360/(2*pi))*sqrt(bandwidth(42)./CN0_direct.*(1+1./(2*T*CN0_direct)));

hold all;
plot(CN0,rho_t_1);
plot(CN0,rho_t_2);
plot(CN0,rho_t_3);
plot(CN0,rho_t_4);
plot(CN0,rho_t_5);
plot(CN0,rho_t_6);

sigma_a = 1e-10;
f_L = 154*10.23e6;
bandwidth_1 = 16.75;
theta_a = 160*sigma_a*f_L./bandwidth;