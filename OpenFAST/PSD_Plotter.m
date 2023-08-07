%% Plot SS Results Against Full Simulation Results
close all; clear all; clc;

home_dir = 'C:\Umaine Google Sync\GitHub\FOCAL-C2-Linearization\OpenFAST';
cd(home_dir);

% Define time offset if .ssexctn files used
tc = struct();
    tc.OpenFAST = 500;
    tc.Simulink = 529.975;
    tc.Experiment = 0;

%% --------------- User Inputs ---------------- %%
% Comparison flag (1: OpenFAST | 2: Simulink | 3: Experimental)
type = [1,2,3];
plot_mark = {'none','none','none'};
simulation = 'Irr4_s1_fixed';

xrange = [0.005 0.15];

% Descriptions
desc = {'OpenFAST';
        'State Space';
        'Experiment'};


cd(sprintf('Simulations/%s',simulation));
for i = 1:length(type)
    t = type(i);

    switch t
        case 1 % OpenFAST Non-Linear Simulation Results
            load('OpenFAST_PSD.mat');
            full_results{i} = OpenFAST_PSD;
            clear sim_results;

        case 2 % Simulink State Space Simulation
            load('Simulink_PSD.mat');
            full_results{i} = Simulink_PSD;
            clear slx_results;

        case 3 % Experimental Results
            load('Test_PSD.mat')
            full_results{i} = Test_PSD;
            clear test_results
    end
end


% Variable to plot
varnames = {'Wave Elevation [m]';
            'Heave [m]';
            'Pitch [deg]';
            'Surge [m]'};

for i = 1:length(type)
    Freq{i} = full_results{i}.Frequency;
    var1{i} = rMean(full_results{i}.Wave1Elev);
    var2{i} = rMean(full_results{i}.PtfmHeave);
    var3{i} = rMean(full_results{i}.PtfmPitch);
    var4{i} = rMean(full_results{i}.PtfmSurge);
end

%% -------------- Do Plotting --------------- %%
figure('Name','SS to Simulation Comparison')
num_plot = 4;
for k = 1:num_plot
    subplot(num_plot,1,k)
    ax = gca; box on; hold on;
    xlabel('Time [s]')
    xlim(xrange);
    title(varnames{k})

    switch k
        case 1
           for i = 1:length(type)
               plot(Freq{i},var1{i},'DisplayName',desc{i});
           end

        case 2
            for i = 1:length(type)
                plot(Freq{i},var2{i},'DisplayName',desc{i});
            end

        case 3
            for i = 1:length(type)
                plot(Freq{i},var3{i},'DisplayName',desc{i});
            end
        
        case 4
            for i = 1:length(type)
                plot(Freq{i},var4{i},'DisplayName',desc{i});
            end
    end

    legend
end