% Plot sea state
close all; clear all; clc;

%% Define Plot Parameters
% Start & stop time
tstart = 8000;
tstop = 8800;

% Define time shift 
tc = 29.975;

% Define your custom color order
customColorOrder = [
    0.8500 0.3250 0.0980; % Default red (#D95319)
    0 0 0;                 % Black
    0.4940 0.1840 0.5560; % Default dark purple (#7E2F8E)
    ];

% Set the default line styles
lineStyles = {'-', '--', '-'};

% Set the default line widths
lineWidths = 1;

% Set the default axes properties to use the custom color order and line styles
set(0, 'DefaultAxesColorOrder', customColorOrder, 'DefaultAxesLineStyleOrder', lineStyles,'DefaultLineLineWidth', lineWidths);

%% Load in Data
load("Kalman_Results.mat")
load("Test_Results.mat")
load("Simulink_Results.mat")

%% Remove Mean from Results
test_names = fieldnames(test_results);
for i = 1:length(test_names)
    if strcmp(test_names{i},'Time') ~= 1
        test_results.(test_names{i}) = rMean(test_results.(test_names{i}));
    end
end

state_names = fieldnames(slx_results);
for i = 1:length(state_names)
    if strcmp(state_names{i},'Time') ~= 1
        slx_results.(state_names{i}) = rMean(slx_results.(state_names{i}));
    end
end

kalman_names = fieldnames(kalman_results);
for i = 1:length(kalman_names)
    if strcmp(kalman_names{i},'Time') ~= 1
        kalman_results.(kalman_names{i}) = rMean(kalman_results.(kalman_names{i}));
    end
end

%% Plot Results
% Open Figure
figure('Position',[1921.8,521,1075.2,1106.4])

% Plot Platform Surge
subplot(4,1,1)
gca; hold on; box on;

plot_var = 'PtfmSurge';
plot(slx_results.Time-tc,slx_results.(plot_var),'DisplayName','State-Space');
plot(test_results.Time,test_results.(plot_var),'DisplayName','Experiment','LineStyle','--');
plot(kalman_results.Time-tc,kalman_results.(plot_var),'DisplayName','Kalman');

xlim([tstart,tstop]);

xlabel('Time [s]')
ylabel('Surge [m]')
legend

% Plot Platform Heave
subplot(4,1,2)
gca; hold on; box on;

plot_var = 'PtfmHeave';
plot(slx_results.Time-tc,slx_results.(plot_var),'DisplayName','State-Space');
plot(test_results.Time,test_results.(plot_var),'DisplayName','Experiment','LineStyle','--');
plot(kalman_results.Time-tc,kalman_results.(plot_var),'DisplayName','Kalman');

xlim([tstart,tstop]);

xlabel('Time [s]')
ylabel('Heave [m]')
legend

% Plot Platform Pitch
subplot(4,1,3)
gca; hold on; box on;

plot_var = 'PtfmPitch';
plot(slx_results.Time-tc,slx_results.(plot_var),'DisplayName','State-Space');
plot(test_results.Time,test_results.(plot_var),'DisplayName','Experiment','LineStyle','--');
plot(kalman_results.Time-tc,kalman_results.(plot_var),'DisplayName','Kalman');

xlim([tstart,tstop]);

xlabel('Time [s]')
ylabel('Pitch [deg]')
legend

% Plot Tower Bending Moment
subplot(4,1,4)
gca; hold on; box on;

plot_var = 'TwrBsMyt';
plot(slx_results.Time-tc,slx_results.(plot_var),'DisplayName','State-Space');
plot(test_results.Time,test_results.(plot_var)*10^-3,'DisplayName','Experiment','LineStyle','--');
plot(kalman_results.Time-tc,kalman_results.(plot_var),'DisplayName','Kalman');

xlim([tstart,tstop]);

xlabel('Time [s]')
ylabel('Twr My [kN-m]')
legend