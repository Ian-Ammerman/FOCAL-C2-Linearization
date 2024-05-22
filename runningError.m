close all; clear all; clc;
% cd('C:\Umaine Google Sync\Masters Working Folder\FOCAL_C2\Simulations\C2_PinkNoise')


% Load in Test & Simulation Results
load('Test_Results.mat','test_results');
load('Simulink_Results','slx_results');
load('OpenFAST_Results.mat','sim_results')
load('SimulinkObserver_Results','slx_obs_results');
load('Kalman_Results.mat','kalman_results');

% Natural frequencies
% wn = 0.007 % surge & sway
wn = 0.036 % pitch & roll
%wn = 0.049 % heave
%wn = 0.011 % yaw


variable = 'PtfmSurge';
units = 'm';
Tn = 1/0.036;
tc_sim = 0;
tc_slx = 29.975;
tc_obs = 29.975;

time = test_results.Time;
sim_time = sim_results.Time-tc_sim;
slx_time = slx_results.Time-tc_slx;
obs_time = kalman_results.Time-tc_obs;

% Determine end time of analysis
tstart = 0;
tstop = min(max(sim_time),max(slx_time));

start_index = dsearchn(time,tstart);
stop_index = dsearchn(time,tstop);

time = time(start_index:stop_index);
Fs = length(time)/(max(time)-min(time));

% Sync data in time
ytest = rMean(test_results.(variable));
    ytest = ytest(start_index:stop_index);
    % ytest = ytest/max(ytest);
    ytest = rMean(ytest);

yslx = pchip(slx_time,rMean(slx_results.(variable)),time);
    % yslx = yslx/max(yslx);
    yslx = rMean(yslx);
ysim = pchip(sim_time,rMean(sim_results.(variable)),time);
    % ysim = ysim/max(ysim);
    ysim = rMean(ysim);
yobs = pchip(obs_time,kalman_results.(variable),time);
    yobs = rMean(yobs);
    % yobs = yobs/max(yobs);

wave = rMean(test_results.Wave1Elev);
    wave = wave(start_index:stop_index);

%% PSD Comparison ------------------------------------------------------------ %%
% Compute PSDs
Fs = round(length(time)/max(time));
nsmooth = 15;
sim_psd = myPSD(ysim,Fs,nsmooth);
slx_psd = myPSD(yslx,Fs,nsmooth);
test_psd = myPSD(ytest,Fs,nsmooth);
obs_psd = myPSD(yobs,Fs,nsmooth);
freq = test_psd(:,1);

% Compute Absolute Error in PSDs
slx_abs = 100*abs(slx_psd-test_psd)./max(test_psd(:,2));
obs_abs = 100*abs(obs_psd-test_psd)./max(test_psd(:,2));
sim_abs = 100*abs(sim_psd-test_psd)./max(test_psd(:,2));

% Plot Results
figure
subplot(2,1,1)
ax = gca; hold on; box on;
set(ax,'FontSize',13)
% plot(sim_psd(:,1),sim_psd(:,2),'DisplayName','OpenFAST','LineWidth',1);
plot(slx_psd(:,1),slx_psd(:,2),'DisplayName','StateSpace','LineWidth',1,'Color','#D95319');
plot(test_psd(:,1),test_psd(:,2),'DisplayName','Experiment','LineWidth',1,'Color',[0.2,0.2,0.2],'LineStyle','--');
plot(obs_psd(:,1),obs_psd(:,2),'DisplayName','Kalman','Color','#7E2F8E','LineWidth',1);
xline(wn,'LineWidth',1,'Color',[0,0,0],'LineStyle','-.','DisplayName',sprintf('w_n = %0.4g Hz',wn))

xlabel('Frequency [Hz]')
% ylabel('PSD [deg^2/Hz]')
xlim([0.005 0.15])
% xlim([0,0.05])
if contains(variable,'Ptfm')
    var_name = extractAfter(variable,'Ptfm')
end
ylabel(sprintf('%s PSD [%s^2/Hz]',var_name,units));
legend

subplot(2,1,2)
ax = gca; hold on; box on;
set(ax,'FontSize',13)
% plot(freq,sim_abs(:,2),'DisplayName','OpenFAST','LineWidth',1);
plot(freq,obs_abs(:,2),'DisplayName','Kalman','LineWidth',1,'Color','#7E2F8E')
plot(freq,slx_abs(:,2),'DisplayName','StateSpace','LineWidth',1);
yline(10,'HandleVisibility','off','LineStyle','--','Color','Black');
text(0.12,10,'10% Error','VerticalAlignment','bottom')
xline(wn,'LineWidth',1,'Color',[0,0,0],'LineStyle','-.','DisplayName',sprintf('w_n = %0.4g Hz',wn))
% plot(freq,obs_abs(:,2),'DisplayName','Kalman');

xlabel('Frequency [Hz]')
% ylim([0 16])
xlim([0.005 0.15])
% xlim([0,0.05])
ylabel({'PSD Error %'});
legend

%% Mean Relative Error
e_kalman = sqrt(mean(abs(yobs-ytest).^2/(max(ytest)-min(ytest))^2))
e_ss = sqrt(mean(abs(yslx-ytest).^2/(max(ytest)-min(ytest))^2)) 

Rsquare_kalman = sumSquareFit(ytest,yobs)
Rsquare_ss = sumSquareFit(ytest,yslx)
Rsquare_fast = sumSquareFit(ytest,ysim)
Rsquare_fast_kalman = sumSquareFit(ysim,yobs)
    



% figure
% gca; hold on;
% plot(time,ytest,'DisplayName','Experiment')
% plot(time,yobs,'DisplayName','Kalman')
% legend

% %% 2-Norm Error Calculation
% sim_abs = ysim - ytest;
% slx_abs = yslx - ytest;
% obs_abs = yobs - ytest;
% 
% e_sim = norm(sim_abs);
% e_slx = norm(slx_abs);
% e_obs = norm(obs_abs);
% 
% figure
% bar(["OpenFAST","State Space","Kalman Filter"], [e_sim,e_slx,e_obs])
% 
% %% Overall Correlation Coefficient ---------------------------------------------- %%
% % Form matrix
% ymat = [ytest,ysim,yslx,yobs];
% [R,P,RLO,RUP] = testCorrelation(ymat,'alpha',0.00000001);
% 
% figure
% subplot(2,1,1)
% gca; hold on; box on;
% plot(time,ytest,'DisplayName','Experiment')
% plot(time,ysim,'DisplayName','OpenFAST')
% plot(time,yslx,'DisplayName','State-Space')
% plot(time,yobs,'DisplayName','Kalman Filter')
% legend
% 
% Names = categorical(["Experiment","OpenFAST","State-Space","Kalman Filter"]);
% 
% subplot(2,1,2)
% bar(["Experiment","OpenFAST","State-Space","Kalman Filter"],R,0.4); hold on;
% errorbar(Names,R,R-RLO,RUP-R,'.');
% 
% %% Envelope Comparison --------------------------------------------------------- %%
% nwin = 368*2;
% [test_upper,test_lower] = envelope(ytest,nwin,'rms');
% [sim_upper,sim_lower] = envelope(ysim,nwin,'rms');
% [slx_upper,slx_lower] = envelope(yslx,nwin,'rms');
% [slx_obs_upper,slx_obs_lower] = envelope(yobs,nwin,'rms');
% 
% % Envelope correlation
% ycorrmat = [test_upper,sim_upper,slx_upper,slx_obs_upper];
% [Renv,Penv,RLOenv,RUPenv] = testCorrelation(ycorrmat);
% 
% figure
% subplot(2,1,1)
% gca; hold on; box on;
% plot(time,test_upper,'DisplayName','Experiment');
% plot(time,sim_upper,'DisplayName','OpenFAST');
% plot(time,slx_upper,'DisplayName','State Space');
% plot(time,slx_obs_upper,'DisplayName','Observer');
% legend
% 
% title(sprintf('Upper Response Envelope | %s',variable))
% % xlim([275 14000])
% xlabel('Time [s]')
% ylabel('N-m')
% 
% % Envelope Error
% slx_env_abs = 100*abs(slx_upper - test_upper)./max(test_upper);
% sim_env_abs = 100*abs(sim_upper - test_upper)./max(test_upper);
% obs_env_abs = 100*abs(slx_obs_upper - test_upper)./max(test_upper);
% 
% subplot(2,1,2)
% gca; hold on; box on; grid on;
% plot(time,slx_env_abs,'DisplayName','State-Space')
% plot(time,sim_env_abs,'DisplayName','OpenFAST')
% plot(time,obs_env_abs,'DisplayName','Observer')
% 
% title(sprintf('Upper Envelope Percent Error | %s',variable));
% % xlim([275 14000])
% xlabel('Time [s]')
% legend

% %% RAO Comparison
% % Compute RAO
% nsmooth = 10;
% sim_rao = myRAO(ysim,wave,Fs,nsmooth);
% slx_rao = myRAO(yslx,wave,Fs,nsmooth);
% obs_rao = myRAO(yobs,wave,Fs,nsmooth);
% test_rao = myRAO(ytest,wave,Fs,nsmooth);
% 
% figure
% plot(time,wave);
% title('Wave');
% 
% figure
% subplot(2,1,1)
% gca; hold on; box on;
% plot(1./sim_rao(:,1),sim_rao(:,2),'DisplayName','OpenFAST');
% plot(1./slx_rao(:,1),slx_rao(:,2),'DisplayName','State Space');
% plot(1./test_rao(:,1),test_rao(:,2),'DisplayName','Experiment');
% plot(1./obs_rao(:,1),obs_rao(:,2),'DisplayName','Kalman Filter');
% xline(Tn,'DisplayName',sprintf('T_n = %0.3g s',Tn),'LineStyle','--','LineWidth',2)
% 
% xlim([6,40])
% 
% xlabel('Period [s]')
% ylabel(sprintf('%s RAO',variable));
% 
% title({'Response Amplitude Operator'},{variable})
% legend('Location','northwest')
% 
% % Compute RAO Error
% sim_rel = abs(sim_rao-test_rao)./test_rao;
% slx_rel = abs(slx_rao-test_rao)./test_rao;
% obs_rel = abs(obs_rao-test_rao)./test_rao;
% 
% subplot(2,1,2)
% gca; hold on; box on;
% plot(1./sim_rao(:,1),sim_rel(:,2),'DisplayName','OpenFAST');
% plot(1./slx_rao(:,1),slx_rel(:,2),'DisplayName','State Space');
% plot(1./obs_rao(:,1),obs_rel(:,2),'DisplayName','Kalman Filter');
% xline(Tn,'DisplayName',sprintf('T_n = %0.3g s',Tn),'LineStyle','--','LineWidth',2)
% 
% xlabel('Period [s]')
% ylabel('Relative % Error')
% 
% xlim([6,40])
% title({'Relative Error % in RAO'},{variable})
% legend('Location','northwest')

% %% Moving Relative Error vs Significant Wave Height
% nwin = 10000;
% count = 0;
% [ss_error,kalman_error,Hs] = deal(zeros(length(time)-2*nwin,1));
% for i = 1:length(time)-nwin
%     test_vals = ytest(i:i+nwin);
%     % sim_vals = ysim(i:i+nwin);
%     slx_vals = yslx(i:i+nwin);
%     obs_vals = yobs(i:i+nwin);
%     eta_vals = wave(i:i+nwin);
% 
%     % Compute Significant Wave Height
%     Hs(i) = 4*sqrt(std(eta_vals));
% 
%     % Compute Mean Relative Error
%     % kalman_error(i) = sqrt(mean(abs(obs_vals-test_vals).^2));
%     kalman_error(i) = abs(std(obs_vals)-std(test_vals));
%     % ss_error(i) = sqrt(mean(abs(slx_vals-test_vals).^2));   
%     ss_error(i) = abs(std(slx_vals)-std(test_vals));
%     % count = count + 1
% end
% 
% Hs = smoothdata(Hs,"movmedian");
% Hs = smoothdata(Hs,'movmean');
% %%
% figure
% gca; hold on; box on;
% plot(time(1:end-nwin),ss_error,'DisplayName','State-Space');
% plot(time(1:end-nwin),kalman_error,'DisplayName','Kalman Filter')
% legend
% 
% figure
% gca; hold on; box on;
% plot(Hs,kalman_error,'DisplayName','Kalman Filter')
% plot(Hs,ss_error,'DisplayName','State-Space')
% 
% title('Mean Relative Error vs Significant Wave Height')
% xlabel('Significant Wave Height [m]')
% ylabel('Mean Relative Error [-]')
% legend
%%
% eplot = abs(yobs-ytest)/mean(max(ytest)-min(ytest));

% %% Moving Correlation Coefficient ------------------------------------------- %%
% nwin = 5000;
% 
% for i = 1:length(time)-nwin
%     test_vals = ytest(i:i+nwin);
%     sim_vals = ysim(i:i+nwin);
%     slx_vals = yslx(i:i+nwin);
%     obs_vals = yobs(i:i+nwin);
% 
%     rsim(i) = getCorrelationCoefficient(rMean(test_vals),rMean(sim_vals));
%     rslx(i) = getCorrelationCoefficient(rMean(test_vals),rMean(slx_vals));
%     robs(i) = getCorrelationCoefficient(rMean(test_vals),rMean(obs_vals));
% 
%     ebar_fast(i) = meanRelError(test_vals,sim_vals);
%     ebar_ss(i) = meanRelError(test_vals,slx_vals);
%     ebar_kalman(i) = meanRelError(test_vals,obs_vals);
% 
%     sig_rat_fast(i) = sigmaRatio(test_vals,sim_vals);
%     sig_rat_ss(i) = sigmaRatio(test_vals,slx_vals);
%     sig_rat_kalman(i) = sigmaRatio(test_vals,obs_vals);
% 
%     r_fast(i) = sumSquareFit(test_vals,sim_vals);
%     r_ss(i) = sumSquareFit(test_vals,slx_vals);
%     r_kalman(i) = sumSquareFit(test_vals,obs_vals);
% end
% %%
% figure
% gca; hold on; box on;
% plot(time,ytest,'DisplayName','Experiment');
% plot(time,yobs,'DisplayName','Kalman Filter');
% plot(time,yslx,'DisplayName','State-Space');
% 
% xlabel('Time [s]')
% title(sprintf('Time Series Comparison | %s',variable));
% legend
% 
% figure
% gca; hold on; box on;
% plot(time(1:end-nwin),r_fast,'DisplayName','OpenFAST');
% plot(time(1:end-nwin),r_ss,'DisplayName','State-Space');
% plot(time(1:end-nwin),r_kalman,'DisplayName','Kalman Filter')
% 
% xlabel('Time [s]')
% ylim([0,1])
% title(sprintf('Moving Coefficient of Determination | Window: %0.3g s',nwin*0.0416))
% legend



%%% --------------------------------------------------------------- %%%
%%% --------------------------------------------------------------- %%%
%%% --------------------------------------------------------------- %%%
%%% ------------------------- END OF CODE ------------------------- %%%
%%% --------------------------------------------------------------- %%%
%%% --------------------------------------------------------------- %%%
%%% --------------------------------------------------------------- %%%






















% % Mean Square Error
% slx_MSEi = slx_abs.^2;
% sim_MSEi = sim_abs.^2;
% 
% nwin = 10;
% winFreq = freq(1:end-nwin);
% for i = 1:length(test_psd(:,2))-nwin
%     slx_MSE(i) = sum(slx_MSEi(i:i+nwin,2));
%     sim_MSE(i) = sum(sim_MSEi(i:i+nwin,2));
% end
% 
% figure
% plot(winFreq,slx_MSE,'DisplayName','StateSpace');
% plot(winFreq,sim_MSE,'DisplayName','OpenFAST');
% 
% xlabel('Frequency [Hz]')
% xlim([0.04 0.18])
% title(sprintf('PSD Running Mean Square Error | %s | Window = %0.3g',variable,nwin/Fs));
% 
% % Root Mean Square Error
% slx_RMSE = slx_MSE.^0.5;
% sim_RMSE = sim_MSE.^0.5;
% 
% % Sum of squares fit
% nwin = 1;
% fbar = zeros(length(test_psd(:,2))-nwin,1);
% R = zeros(length(test_psd(:,2))-nwin,1);
% for i = 1:length(test_psd(:,2))-nwin
%     measured = test_psd(i:i+nwin,2);
%     predicted = sim_psd(i:i+nwin,2);
% 
%     R(i) = sumSquareFit(predicted,measured);
%     fbar(i) = mean(test_psd(i:i+nwin,1));
% end



% figure
% subplot(3,1,1)
% gca; hold on; box on;
% plot(sim_psd(:,1),sim_psd(:,2),'DisplayName','State-Space');
% plot(test_psd(:,1),test_psd(:,2),'DisplayName','Experiment');
% xlabel('Frequency [Hz]')
% xlim([0.05,0.15])
% title('Pitch PSDs')
% legend
% 
% subplot(3,1,2)
% gca; hold on; box on;
% plot(fbar,R);
% xlabel('Frequency [Hz]')
% ylim([0,1])
% xlim([0.05,0.15])
% title({'Moving R^2 Fit'},{sprintf('%i Samples',nwin)})
% 
% subplot(3,1,3)
% gca; hold on; box on;
% plot(sim_psd(:,1),relError);
% 
% xlabel('Frequency [Hz]')
% xlim([0.05 0.15])
% title('PSD Absolute Error')

% %% Cross Correlation Analysis
% [r,lags] = xcorr(ysim,ytest);
% [yupper,ylower] = envelope(r);
% 
% 
% figure
% gca; box on;
% 
% subplot(2,1,1)
% scatter(lags,r);
% title('Cross-Correlation')
% 
% subplot(2,1,2)
% gca; box on; hold on;
% plot(lags,yupper);
% plot(lags,ylower);
% 
% % %% Covariance
% % C = cov(ysim,ytest);
% % 
% % for i = 1:length(ysim)
% %     Cpoints(i) = cov(ysim(i),ytest(i));
% % end
% % 
% % figure
% % stem3(ysim,ytest,Cpoints)

% %% Absolute Error Analysis
% absError = abs(ytest-ysim);
% range = max(ytest)-min(ytest);
% relError = absError./range;
% 
% absMovError = movmean(relError,6);
% 
% figure
% 
% subplot(2,1,1)
% gca; hold on; box on;
% plot(time,relError,'DIsplayName','Relative Error');
% 
% subplot(2,1,2)
% gca; hold on; box on;
% plot(time,absMovError,'DisplayName','Moving Mean of Absolute Error');
% title('Relative Error Moving Mean')

% %% Cumulative Integral
% sim_trap = cumtrapz(time,ysim);
% test_trap = cumtrapz(time,ytest);
% 
% 
% 
% figure
% gca; box on; hold on;
% plot(time,absError,'DisplayName','Absolute Error');
% % plot(time,relError,'DisplayName','Relative Error');
% title('Pitch Error')
% legend
% 
% % %% Running Integral
% % nwin = 500;
% % 
% % sim_run = runInt(time,ysim,nwin);
% % test_run = runInt(time,ytest,nwin);
% % 
% % figure
% % gca; box on; hold on;
% % plot(rMean(sim_run),'DisplayName','Simulation')
% % plot(rMean(test_run),'DisplayName','Measured')
% % legend
% % title('Running Integral')

% %% Running Standard Deviation
% nwin = 5000;
% 
% sim_std = movmean(absError,nwin);
% test_std = movmean(ytest,nwin);
% 
% 
% test_std = smoothdata(test_std,'gaussian');
% 
% figure
% gca; box on; hold on;
% plot(time,sim_std,'DisplayName','Simulated');
% % plot(time,test_std,'DisplayName','Measured');
% legend
% title('Running Standard Deviation')








% ---------- FUNCTIONS ---------- %

function e = meanRelError(base,sample)
    e = mean(abs(sample-base)/(max(base)-min(base)));
end

function s = sigmaRatio(base,sample)
    s = std(sample)/std(base);
end

function R = sumSquareFit(base,sample)
    ybar = mean(base);
    fbar = mean(sample);

    SSE = sum((sample-base).^2);
    SST = sum((base).^2);
    R = 1 - SSE/SST;
end

function I = runInt(X,Y,window)
    for i = 1:length(X)-window
        start = i;
        stop = i+window;
        
        xwin = X(start:stop);
        ywin = Y(start:stop);

        I(i) = trapz(xwin,ywin);
    end
end

function I = windowInt(vals)
    I = trapz(vals)
end

function a = average(vals)

a = sum(vals)/length(vals);

end































% 
% dofs = {'PtfmPitch','TwrBsMyt'};
% index = 25000;
% 
% for i = 1:length(dofs)
%     slx_results.(dofs{i}) = pchip(slx_results.Time,slx_results.(dofs{i}),test_results.Time);
% end
% 
% %% Loop Through Fields
% for i = 1:length(dofs)
%     y1 = test_results.(dofs{i});
%     y2 = slx_results.(dofs{i});
%     time = test_results.Time;
%     time = time(1:25000);
% 
% 
%     % Residual
%     SSE = (y1(1:index)-y2(1:index)).^2;
%     SST = (y1(1:index)-mean(y1(1:index))).^2;
%     rsquare{i} = 1-SSE./SST;
% 
%     % Absolute Error
%     absE = abs(y1(1:index)-y2(1:index));
%     perE = absE./abs(y1(1:index));
% 
%     figure
%     title(dofs{i})
% %     plot(time,absE,'DisplayName','Error'); hold on
%     plot(time,abs(y1(1:index)),'DisplayName','Measured'); hold on;
%     plot(time-29.975,abs(y2(1:index)),'DisplayName','Simulated')
%     xlim([0 400])
%     legend
% end

