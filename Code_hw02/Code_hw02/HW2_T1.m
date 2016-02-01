close all; clear all; clc

plotting = 1; % 'all';

PIT = 3e-3; 
prn = 1;
Ts = 1/5714e3;
tk = 0:Ts:1e-3;
tk2 = (0:Ts:1e-3) + PIT;
delay = 2;
CN0 = 50;
iniCarrPhase = 0;
doplr = 0;
doplr_truth = 0e3;

ca = shiftedSampledCode(prn, Ts, delay);
rcvSig = rcvSigGen(ca,iniCarrPhase,doplr,CN0);
%% Replica Signal %%
repIniCarPhas = iniCarrPhase + (-pi:pi/20:pi);
repDelay = delay + (-2:0.5:2); % +/-2 chips with half chip spacing
repDopBin = 250;
repDoplr = ceil( doplr + (-3e3:repDopBin:3e3) ); % +/-1.5kHz = 3kHz
repDoplrFll = doplr-1e3:20:doplr+1e3;
cD = 0.5; % half chip delay

%% True
cen_delay = ceil(length(repDelay)/2);
cen_phase = ceil(length(repIniCarPhas)/2);
cen_f_d = ceil(length(repDoplr)/2);
cen_f_d_FLL = ceil(length(repDoplrFll)/2);


%%
[ eI, eQ, pI, pQ, laI, laQ ] = replicaSigEPL( rcvSig, repIniCarPhas, repDoplr, cD, prn, repDelay, tk);
% ----------------------- Plotting Correlation Fn.s ----------------------- %
if (plotting == 1)|(strcmp(plotting,'all')==1)
% ACF w.r.t code delay
figure;
subplot(121); plot(repDelay,[eI(:,12,20),pI(:,12,20),laI(:,12,20)]),grid on;
xlabel('code delay error [chip]');title('correlation fn. I w.r.t code delay');legend('E','P','L')
subplot(122); plot(repDelay,[eQ(:,12,20),pQ(:,12,20),laQ(:,12,20)]),grid on;
xlabel('code delay error [chip]');title('correlation fn. Q w.r.t code delay');legend('E','P','L')

% ACF w.r.t doppler freq.
figure;
subplot(121); plot(repDoplr,eI(5,:,20),repDoplr,pI(5,:,20),repDoplr,laI(5,:,20)),grid on;
xlabel('doppler error [Hz]');title('correlation fn. I w.r.t doppler freq.');legend('E','P','L')
subplot(122); plot(repDoplr,eQ(5,:,20),repDoplr,pQ(5,:,20),repDoplr,laQ(5,:,20)),grid on;
xlabel('doppler error [Hz]');title('correlation fn. Q w.r.t doppler freq.');legend('E','P','L')

% ACF w.r.t carrier phase
x = rad2deg(repIniCarPhas);
figure;
subplot(121); plot(x,reshape(eI(5,12,:),[],1),x,reshape(pI(5,12,:),[],1),x,reshape(laI(5,12,:),[],1));
grid on;
xlabel('carrier phase error [°]');title('correlation fn. I w.r.t carrier phase');legend('E','P','L')
subplot(122); plot(x,reshape(eQ(5,12,:),[],1),x,reshape(pQ(5,12,:),[],1),x,reshape(laQ(5,12,:),[],1));
grid on;
xlabel('carrier phase error [°]');title('correlation fn. Q w.r.t carrier phase');legend('E','P','L')
end
% ----------------------- DLL Discriminator ----------------------- %
if (plotting == 2)||(strcmp(plotting,'all')==1)
    [dllEnv,dllPow,dllQuasi,dllCoh] = discDLL( eI, eQ, pI, pQ, laI, laQ );        
    figure;
    plot(repDelay,dllEnv(:,12,20),repDelay,dllPow(:,12,20),repDelay,dllQuasi(:,12,20),repDelay,dllCoh(:,12,20)),grid on;
    xlabel('code delay error [chip]');ylabel('DLL discriminator output [chips]')
    title('Delay Lock Loop Discriminator');legend('nc-early late envelop','nc-early late power','quasi-coh','coherent')
    
    figure;
    subplot(1,2,1); hold all
    plot( repDelay , dllEnv(:,cen_f_d-2,cen_phase)),grid on;
    plot( repDelay , dllEnv(:,cen_f_d-1,cen_phase)),grid on;
    plot( repDelay , dllEnv(:,cen_f_d  ,cen_phase)),grid on;
    plot( repDelay , dllEnv(:,cen_f_d+1,cen_phase)),grid on;
    plot( repDelay , dllEnv(:,cen_f_d+2,cen_phase)),grid on;
    legend( ['Doppler shift=' num2str(repDoplr(cen_f_d-2)) 'Hz'] , ...
            ['Doppler shift=' num2str(repDoplr(cen_f_d-1)) 'Hz'] , ...
            ['Doppler shift=' num2str(repDoplr(cen_f_d-0)) 'Hz'] , ...
            ['Doppler shift=' num2str(repDoplr(cen_f_d+1)) 'Hz'] , ...
            ['Doppler shift=' num2str(repDoplr(cen_f_d+2)) 'Hz'] );
    title('Envelope Normalized DLL Discriminator');
    xlabel('Code delay [chips]');
    ylabel('Discriminator output [chips]');
    
    subplot(1,2,2); hold all
    plot( repDelay , dllCoh(:,cen_f_d-2,cen_phase)),grid on;
    plot( repDelay , dllCoh(:,cen_f_d-1,cen_phase)),grid on;
    plot( repDelay , dllCoh(:,cen_f_d  ,cen_phase)),grid on;
    plot( repDelay , dllCoh(:,cen_f_d+1,cen_phase)),grid on;
    plot( repDelay , dllCoh(:,cen_f_d+2,cen_phase)),grid on;
    legend( ['Doppler shift=' num2str(repDoplr(cen_f_d-2)) 'Hz'] , ...
            ['Doppler shift=' num2str(repDoplr(cen_f_d-1)) 'Hz'] , ...
            ['Doppler shift=' num2str(repDoplr(cen_f_d-0)) 'Hz'] , ...
            ['Doppler shift=' num2str(repDoplr(cen_f_d+1)) 'Hz'] , ...
            ['Doppler shift=' num2str(repDoplr(cen_f_d+2)) 'Hz'] );
    title('Coherent DLL Discriminator');
    xlabel('Code delay [chips]');
    ylabel('Discriminator output [chips]');
end
% ----------------------- PLL Discriminator ----------------------- %
if (plotting == 3)|(strcmp(plotting,'all')==1)
    [pll_p4Quad,pll_cClasc,pll_cDecsn,pll_cOptim,pll_c2Quad ] = discPLL( pI, pQ );
    x = rad2deg(repIniCarPhas);
    figure; hold all
    plot(x,reshape(pll_p4Quad(5,12,:),[],1)),grid on;
    plot(x,reshape(pll_cClasc(5,12,:),[],1)),grid on;
    plot(x,reshape(pll_cDecsn(5,12,:),[],1)),grid on;
    plot(x,reshape(pll_cOptim(5,12,:),[],1)),grid on;
    plot(x,reshape(pll_c2Quad(5,12,:),[],1)),grid on;
    xlabel('carrier phase error [°]'); ylabel('PLL discriminator output [°]'); title('Phase Lock Loop Discriminator');
    legend('pure-4Quad','costas-classic','costas-decision','costas-optimum','costas-2Quad')
    
    figure;
    subplot(1,2,1);
    hold all
    plot( x , reshape(pll_p4Quad(cen_delay,cen_f_d-2,:) ,[],1)),grid on;
    plot( x , reshape(pll_p4Quad(cen_delay,cen_f_d-1,:) ,[],1)),grid on;
    plot( x , reshape(pll_p4Quad(cen_delay,cen_f_d  ,:) ,[],1)),grid on;
    plot( x , reshape(pll_p4Quad(cen_delay,cen_f_d+1,:) ,[],1)),grid on;
    plot( x , reshape(pll_p4Quad(cen_delay,cen_f_d+2,:) ,[],1)),grid on;
    legend( ['Doppler shift = ' num2str(repDoplrFll(cen_f_d_FLL-2)) 'Hz'] , ...
            ['Doppler shift = ' num2str(repDoplrFll(cen_f_d_FLL-1)) 'Hz'] , ...
            ['Doppler shift = ' num2str(repDoplrFll(cen_f_d_FLL-0)) 'Hz'] , ...
            ['Doppler shift = ' num2str(repDoplrFll(cen_f_d_FLL+1)) 'Hz'] , ...
            ['Doppler shift = ' num2str(repDoplrFll(cen_f_d_FLL+2)) 'Hz'] );
    title(['pure-4Quad, true Doppler=' num2str(doplr_truth) 'Hz']);
    xlabel('Phase [°]');
    ylabel('Discriminator output [°]');
    
    subplot(1,2,2);
    hold all
    plot( x , reshape(pll_c2Quad(cen_delay,cen_f_d-2,:) ,[],1)),grid on;
    plot( x , reshape(pll_c2Quad(cen_delay,cen_f_d-1,:) ,[],1)),grid on;
    plot( x , reshape(pll_c2Quad(cen_delay,cen_f_d  ,:) ,[],1)),grid on;
    plot( x , reshape(pll_c2Quad(cen_delay,cen_f_d+1,:) ,[],1)),grid on;
    plot( x , reshape(pll_c2Quad(cen_delay,cen_f_d+2,:) ,[],1)),grid on;
    legend( ['Doppler shift = ' num2str(repDoplrFll(cen_f_d_FLL-2)) 'Hz'] , ...
            ['Doppler shift = ' num2str(repDoplrFll(cen_f_d_FLL-1)) 'Hz'] , ...
            ['Doppler shift = ' num2str(repDoplrFll(cen_f_d_FLL-0)) 'Hz'] , ...
            ['Doppler shift = ' num2str(repDoplrFll(cen_f_d_FLL+1)) 'Hz'] , ...
            ['Doppler shift = ' num2str(repDoplrFll(cen_f_d_FLL+2)) 'Hz'] );
    title(['costas-2Quad, true Doppler=' num2str(doplr_truth) 'Hz']);
    xlabel('Phase [°]');
    ylabel('Discriminator output [°]');

end
% ----------------------- FLL Discriminator ----------------------- %
if (plotting == 4)|(strcmp(plotting,'all')==1)
    [ ~, ~, pI1, pQ1, ~, ~ ] = replicaSigEPL( rcvSig, repIniCarPhas, repDoplrFll, NaN, prn, repDelay, tk);
    [ ~, ~, pI2, pQ2, ~, ~ ] = replicaSigEPL( rcvSig, repIniCarPhas, repDoplrFll, NaN, prn, repDelay, tk2);
    [ fllOptim, fllDecsn, fll4Quad ] = discFLL( pI1, pI2, pQ1, pQ2 );
    figure; hold all
    plot(repDoplrFll,fllOptim(5,:,20),'linewidth',2),grid on;
    plot(repDoplrFll,fllDecsn(5,:,20),'--','linewidth',2),grid on;
    plot(repDoplrFll,fll4Quad(5,:,20),'.-','linewidth',2),grid on;
    xlabel('doppler error [Hz]');ylabel('FLL discriminator output [Hz]')
    title('Frequency Lock Loop Discriminator');legend('near optimum','decision directed','4 Quad atan')
end
