% Compute mag and phase of wave data
close all; clear all; clc;

%% ---------- Load in Experimental Data ---------- %%
load('Reg1_fixedTMD.mat');

time = channels(:,1);
eta = channels(:,2);
heave = channels(:,5);

%% ---------- Load in Simulated Data ---------- %%
% load('OpenFAST_Results.mat');
% time = sim_results.Time;
% eta = sim_results.Wave1Elev;
% heave = sim_results.PtfmHeave;

nsmooth = 25;

%% --------- Prepare Data for FFT ---------- %%
Data{1} = heave;
Data{2} = eta;

for i = 1:2
    data = Data{i};
    Fs = length(time)/max(time); %sampling frequency [Hz]
    L = length(data);
    
    %% ---------- Perform FFT ---------- %%
    vals = data(:);
    
    % Perform FFT & Compute PSD
    F = fft(vals);
    F = F(1:length(vals)/2+1); %2 side to 1 side - take only one side
    f1 = [0:Fs/length(vals):Fs/2]';
    
    % Smooth FFT
    if nsmooth > 0
        window = ones(nsmooth,1)/nsmooth;
        F = conv(F,window,'same');
    end
    Phase{i} = wrapToPi(phase(F));
    Combined{i} = F;
end
%% ---------- Analyze Phase ---------- %%
phase_diff = Phase{1} - Phase{2};
phase_diff = rad2deg(phase_diff);

figure
scatter(f1,phase_diff);
xlim([0,0.5]);
xlabel('Frequency [Hz]')
ylabel('Phase Difference [deg]')
title('Phase Difference')

figure
plot(Combined{1}); axis equal
yline(mean(imag(Combined{1})))
xline(mean(real(Combined{1})))
xlabel('Real')
ylabel('Imaginary')
title('Heave')

figure
plot(Combined{2}); axis equal
xlabel('Real')
ylabel('Imaginary')
title('Eta')
yline(mean(imag(Combined{2})))
xline(mean(real(Combined{2})))

figure
plot(f1,F)







