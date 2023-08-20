% Computes PSDs of quantities from tests for comparison

clear all; close all; clc;

%% --------------- USER INPUTS --------------- %%
test = 'Test_01';

cd(sprintf('C:\Umaine Google Sync\GitHub\FOCAL-C2-Linearization\OpenFAST\Simulations/%s',test));
%% Evaluate and Store PSDs
nsmooth = 10;
time_end = 14000;
% Evaluate OpenFAST PSDs
if exist('OpenFAST_Results.mat','file')
    load('OpenFAST_Results.mat');
    fields = fieldnames(sim_results);
    time = sim_results.Time;
    tstop = dsearchn(time,time_end);
    Fs = length(time)/max(time);
    PSD_vals = [];
    FAST_Freq = [];

    for i = 2:length(fields)
        vals = sim_results.(fields{i});
        vals = vals(1:tstop);
        PSD = myPSD(vals,Fs,nsmooth);
        PSD_vals(:,i-1) = PSD(:,2); 

        if isempty(FAST_Freq)
            FAST_Freq = PSD(:,1);
        end 
    end

    PSD_out = [FAST_Freq,PSD_vals];

    fields{1} = 'Frequency';
    for j = 1:length(fields);
        OpenFAST_PSD.(fields{j}) = PSD_out(:,j);
    end
    save('OpenFAST_PSD.mat','OpenFAST_PSD');
end

% Evaluate Simulink PSDs
if exist('Simulink_Results.mat','file')
    load('Simulink_Results.mat');
    fields = fieldnames(slx_results);
    time = slx_results.Time;
    tstop = dsearchn(time,time_end);
    Fs = length(time)/max(time);
    PSD_vals = [];
    sim_Freq = [];

    for i = 2:length(fields)
        vals = slx_results.(fields{i});
        vals = vals(1:tstop);
        PSD = myPSD(vals,Fs,nsmooth);
        PSD_vals(:,i-1) = PSD(:,2); 

        if isempty(sim_Freq)
            sim_Freq = PSD(:,1);
        end 
    end

    PSD_out = [sim_Freq,PSD_vals];

    fields{1} = 'Frequency';
    for j = 1:length(fields);
        Simulink_PSD.(fields{j}) = PSD_out(:,j);
    end
    save('Simulink_PSD.mat','Simulink_PSD');
end

% Evaluate Experiment PSDs
if exist('Test_Results.mat','file')
    load('Test_Results.mat');
    fields = fieldnames(test_results);
    time = test_results.Time;
    tstop = dsearchn(time,time_end);
    Fs = length(time)/max(time);
    PSD_vals = [];
    test_Freq = [];

    for i = 2:length(fields)
        vals = test_results.(fields{i});
        vals = vals(1:tstop);
        PSD = myPSD(vals,Fs,nsmooth);
        PSD_vals(:,i-1) = PSD(:,2); 

        if isempty(test_Freq)
            test_Freq = PSD(:,1);
        end 
    end

    PSD_out = [test_Freq,PSD_vals];

    fields{1} = 'Frequency';
    for j = 1:length(fields);
        Test_PSD.(fields{j}) = PSD_out(:,j);
    end
    save('Test_PSD.mat','Test_PSD');
end

disp('PSDs generated!')

% Evaluate Observer
if exist('SimulinkObserver_Results.mat','file')
    load('SimulinkObserver_Results.mat');
    fields = fieldnames(slx_obs_results);
    time = slx_obs_results.Time;
    tstop = dsearchn(time,time_end);
    Fs = length(time)/max(time);
    PSD_vals = [];
    test_Freq = [];

    for i = 2:length(fields)
        vals = slx_obs_results.(fields{i});
        vals = vals(1:tstop);
        PSD = myPSD(vals,Fs,nsmooth);
        PSD_vals(:,i-1) = PSD(:,2); 

        if isempty(test_Freq)
            test_Freq = PSD(:,1);
        end 
    end

    PSD_out = [test_Freq,PSD_vals];

    fields{1} = 'Frequency';
    for j = 1:length(fields);
        Observer_PSD.(fields{j}) = PSD_out(:,j);
    end
    save('Observer_PSD.mat','Observer_PSD');
end

disp('PSDs generated!')


















