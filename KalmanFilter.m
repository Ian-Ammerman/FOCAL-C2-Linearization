% Manual State-Space Simulation w/ Kalman Filter
close all; clear all; clc;
home = 'C:\Umaine Google Sync\GitHub\FC2_SS_Validation';

%% System Definition ------------------------------------------------------ %%
% Load in HydroDyn SS Model Matrices. These will be simulated directly - no
% Kalman filter is applied here at this time. Future work could use
% sensor measurements to correct force
load(sprintf('%s\\Models\\DT1_Locked_HD\\DT1_Locked_HD_A.mat',home),'A');
load(sprintf('%s\\Models\\DT1_Locked_HD\\DT1_Locked_HD_B.mat',home),'B');
load(sprintf('%s\\Models\\DT1_Locked_HD\\DT1_Locked_HD_C.mat',home),'C');

A_HD = A;
B_HD = B(:,[37,7,8,9,10,11,12]);
C_HD = C;
D_HD = zeros(height(C_HD),width(B_HD));

HDsys = ss(A_HD,B_HD,C_HD,D_HD);

clear A B C;

%% ------------------------------------------------- %%
% Load in Kalman filter control function x = Ax + Bu
load(sprintf('%s\\Models\\DT1_Locked_Platform\\DT1_Locked_Platform_A',home),'A');
load(sprintf('%s\\Models\\DT1_Locked_Platform\\DT1_Locked_Platform_B',home),'B');
load(sprintf('%s\\Models\\DT1_Locked_Platform_out\\DT1_Locked_Platform_out_C',home),'C');
load(sprintf('%s\\Models\\DT1_Locked_Platform\\DT1_Locked_Platform_D',home),'D');
load(sprintf('%s\\Models\\DT1_Locked_Platform_out\\DT1_Locked_Platform_out_ss_data.mat',home),'SS_data');

A_platform = A;
B_platform = B(:,[37:42]);
C_platform = C;
D_platform = zeros(height(C_platform),width(B_platform));

y_desc = SS_data.y_desc;

string_new = cell(height(y_desc),3);
for i = 1:height(y_desc)
    string = y_desc{i};
    string_new = strsplit(string);

    state_name = string_new(2);
    state_name = strrep(state_name,',',''); % remove commas from names
    state_name = strrep(state_name,'[','');
    state_name = strrep(state_name,']','');
    out_state_names(1,i) = state_name;
end
outputNames = horzcat(out_state_names);

clear A B C D SS_data

%% ------------------------------------------------------------- %%
% Measurement Function [H] is C matrix corresponding to observed
% quantitites. Used for residual equation y = z - Hx
load(sprintf('%s\\Models\\DT1_Locked_Platform\\DT1_Locked_Platform_C.mat',home),'C');
load(sprintf('%s\\Models\\DT1_Locked_Platform\\DT1_Locked_Platform_ss_data.mat',home),'SS_data');

y_op = SS_data.y_op; %operating point of measurements to adjust z

H = C;
clear C SS_data;

%% ----------------------------------------------------------------------- %%
% Measurement [z] & measurement noise [R] (from real plant, simulated with
% experiment data) as well as simulation time vector, dt, and wave elevation input.
load(sprintf('%s\\Simulations\\Test_03\\Test_Results.mat',home),'test_results');
MeasurementFields = {'PtfmPitch','PtfmRoll','FAIRTEN1','FAIRTEN2','FAIRTEN3'};

time = test_results.Time;
dt = max(time)/length(time);
wave_input = test_results.Wave1Elev;

Plant = zeros(length(time),length(MeasurementFields));
Fs = length(time)/max(time);
Ffilter = 0.8;

for i = 1:length(MeasurementFields)
    try
        if strcmp(MeasurementFields{i},'TwrBsMyt')
            vals = test_results.(MeasurementFields{i})*10^-3;
        else
            vals = test_results.(MeasurementFields{i});
        end
        baseline = vals-y_op{i};
    catch
        error(sprintf('Could not load %s from test results.',MeasurementFields{i}));
    end

    lowFiltered = lowpass(baseline,Ffilter,Fs);
    Plant(:,i) = lowFiltered;

    filtered(:,i) = lowFiltered;
    noise(:,i) = baseline-lowFiltered;
end

% Conversions for plant measurements
Plant = [zeros(714,width(Plant));Plant];

% Covariance of sensor readings
% R = cov(noise);
R = zeros(5);
R(1,1) = 0.0031;
R(2,2) = 0.0031;
R(3,3) = 2.6*10^6;
R(4,4) = 2.6*10^6;
R(5,5) = 2.6*10^6;

R(2,1) = R(1,1)*0.02;
R(1,2) = R(1,1)*0.02;
% moor_ten_range = max(test_results.FAIRTEN3)-min(test_results.FAIRTEN3);
% Rdiag = [0.00000002,0.00000002,0.0000025*moor_ten_range,0.0000025*moor_ten_range,0.0000025*moor_ten_range];
% R = diag(Rdiag);
% for i = 1:width(R)
%     R(i,i) = Rdiag(i);
% end

%% ------------------------------------------------------------------------ %%
% Define state transition function. This is different from control function
% above - this defines the progression of the states (x = Fx). F is found
% through the equation F = e^At, solved using the first 6 terms of the
% taylor series expansion.
tic
maxTerms = 10;
F = eye(size(A_platform)) + A_platform*dt;
for j = 2:maxTerms
    F = F + ((A_platform*dt)^j)/factorial(j);
end

Bd = inv(A_platform)*(F-eye(size(F)))*B_platform;

platformTime = toc;
fprintf('Platform transition function computed in %0.3g seconds. \n',platformTime);

% HydroDyn Model Transition Function
tic
F_HD = eye(size(A_HD)) + A_HD*dt;
for j = 2:maxTerms
    F_HD = F_HD + ((A_HD*dt)^j)/factorial(j);
end

Bd_HD = inv(A_HD)*(F_HD-eye(size(F_HD)))*B_HD;

hdTime = toc;
fprintf('HydroDyn transition function computed in %0.3g seconds. \n',hdTime);

%% ----------------------------------------------------------------------- %%
% Define the initial process covariace matrix. 
load('FullKalman_P.mat','P');

% Define the measurement coveriance matrix.
load('FullKalman_Q.mat','Q');

%% RUN SIMULATION ---------------------------------------------------- %%
% Initialization (zero IC)
x_HD = zeros(size(A_HD,1),1);
x = zeros(size(A_platform,1),1);

tic
for i = 1:length(time)
    
    % Define HydroDyn Input
    eta = wave_input(i);
    u_HD = [eta;x(11:16)];

    % Perform HydroDyn Prediction
    x_HD = F_HD*x_HD + Bd_HD*u_HD;

    % Extract hydrodynamic loads
    y_HD = C_HD*x_HD;

    % Define platform input vector
    u = y_HD;

    % Collect measurements
    z = Plant(i,:);

    % Perform prediction step
    % gainVector = ones(size(Q,1),1);
    % gainVector(4) = 10;
    [x,P] = predict(x,P,F,dGain(2.25,Q),Bd,u);

    % Perform update step
    %%% Add gain to Q matrix
    [x,P,K] = update(H,P,R,z',x);

    % Store state values for plotting later
    Xlog(:,i) = x;
    Clog(:,i) = C_platform*x;
    % timeLog(i) = loopTime;
    Plog(:,:,i) = P;
    
end
totalTime = toc;
fprintf('Simulation completed in %0.5g seconds. \n',totalTime);

%%
Xlog = Xlog';
Clog = Clog';
% timeLog = timeLog';

kalman_results.Time = time;
for i = 1:length(outputNames)
    kalman_results.(outputNames{i}) = Clog(:,i);
end

%% Plot Results
tstart = 4600;
tstop = 4700;

figure
gca; hold on; box on;
ylabel('Fore-Aft Tower Bending [kN-m]')
xlabel('Time [s]')
plot(time,rMean(test_results.TwrBsMyt*10^-3),'DisplayName','Experiment');
plot(time-29.975,rMean(kalman_results.TwrBsMyt),'DisplayName','Kalman');
xlim([tstart,tstop])
legend

figure
gca; hold on; box on;
ylabel('Pitch [deg]')
xlabel('Time [s]')
plot(time,rMean(test_results.PtfmPitch),'DisplayName','Experiment');
plot(time-29.975,rMean(kalman_results.PtfmPitch),'DisplayName','Kalman');
xlim([tstart,tstop]);
ylim([-0.6,0.6])
legend

figure
gca; hold on; box on;
ylabel('Heave [m]')
xlabel('Time [s]')
plot(time,rMean(test_results.PtfmHeave),'DisplayName','Experiment');
plot(time-29.975,rMean(kalman_results.PtfmHeave),'DisplayName','Kalman');
xlim([tstart,tstop])
legend

figure
gca; hold on; box on;
ylabel('Surge [m]')
xlabel('Time [s]')
plot(time,rMean(test_results.PtfmSurge),'DisplayName','Experiment');
plot(time-29.975,rMean(kalman_results.PtfmSurge),'DisplayName','Kalman');
xlim([tstart,tstop]);
legend

% %% Save Results in Simulation Folder
% cd('C:\Umaine Google Sync\Masters Working Folder\FOCAL_C2\Simulations\C2_PinkNoise')
% save('Kalman_Results.mat','kalman_results')

%% Functions --------------------------------------------------------- %%
% Prediction (Labbe, 2020, pg 212)
function [x,P] = predict(x,P,F,Q,B,u)
    x = F*x + B*u; %predict states
    P = F*P*F' + Q; %predict process covariance
end

% Update
function [x,P,K] = update(H,P,R,z,x)
    S = H*P*H' + R; % Project system uncertainty into measurement space & add measurement uncertainty
    K = P*H'*inv(S);
    y = z-H*x; % Error term
    x = x+K*y;
    KH = K*H;
    P = (eye(size(KH))-KH)*P;
end

























