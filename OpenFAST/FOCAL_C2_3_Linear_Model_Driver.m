% Program to compare the response of a SS model to the corrosponding
% OpenFAST non-linear simulation.
% 
% Written By: Ian Ammerman
% Written: 6/6/23
close all; clear all; clc;

%% Define Home Directory & Model Root
home_dir = 'C:\Umaine Google Sync\GitHub\FOCAL-OpenFast-C2_3';
cd(home_dir) % start from home directory

root = 'CCT9_LC34';

%% OpenFAST (1) or Experiment (2) Comparison
type = 2; %flag, compare to OpenFAST sim or experimental data

%% Define Models to be Compared
% Experiment
data_name = 'focal.campaign2.expr.lc32s2';

% OpenFAST Model
base_sim = 'Baseline_WN';

% Linearized model
ss_sim = 'Linear_Locked';
ss_filepath = sprintf('Simulations/%s',ss_sim);

load(sprintf('%s/%s_A.mat',ss_filepath,root));
load(sprintf('%s/%s_B.mat',ss_filepath,root));
load(sprintf('%s/%s_C.mat',ss_filepath,root));
load(sprintf('%s/%s_D.mat',ss_filepath,root));
load(sprintf('%s/%s_ss_data.mat',ss_filepath,root));

%% Define Time-Series & Wave Input from Baseline Simulation
if type == 1 % OpenFAST Comparison
    base_result_path = sprintf('Simulations/%s/%s_SimResults.mat',base_sim,root);
    load(base_result_path);
    base_results = results;

    time = base_results.Time;
    wave_elevation = base_results.Wave1Elev;

    save_name = sprintf('SS_VS_%s.mat',base_sim);

elseif type == 2 % Data Comparison
    data_dir = 'C:\Umaine Google Sync\Research\FOCAL Data\Campaign 2';
    filename = sprintf('%s\\%s.csv',data_dir,data_name);
    
    opts = detectImportOptions(filename,'NumHeaderLines',2);
        opts.VariableNamesLine = 1;
        opts.VariableUnitsLine = 2;
    
    test = readtable(filename,opts);
    wave_elevation = test.waveElev;
    save_name = sprintf('SS_VS_%s.mat',data_name);

    time = linspace(min(test.time),max(test.time),length(test.time));
end

%% Create Input Vector from B Matrix Dimensions
u = zeros(width(B),length(time));

fields = SS_data.u_desc;
for i = 1:length(fields)
    wave_input_desc = 'HD Extended input: wave elevation at platform ref point, m';
    if strcmp(fields{i},wave_input_desc) == 1
        wave_index = i;
        break
    end
end

u(end,:) = wave_elevation;

%% Initial Conditions
x0 = zeros(length(SS_data.x_op),1);
x0(5) = -0.055152;

%% Simulate Response
ss_model = ss(A,B,C,D);
y = lsim(ss_model,u,time,x0);

%% Add Operating Point to Output
o_point = cell2mat(SS_data.y_op)';

for i = 1:height(y);
    y(i,:) = y(i,:) + o_point;
end

%% Append Time to Output Vector
y(:,end+1) = time;

%% Append Wave Elevation to Output Vector
fields = SS_data.y_desc;
for i = 1:length(fields)
    wave_input_desc = 'HD Wave1Elev, (m)';
    if strcmp(fields{i},wave_input_desc) == 1
        wave_index = i;
        break
    end
end

y(:,wave_index) = wave_elevation;

%% Process Output State Names
y_desc = SS_data.y_desc;
string_new = cell(height(y_desc),3);
for i = 1:height(y_desc)
    string = y_desc{i};
    string_new = strsplit(string);
    string_new(2) = strrep(string_new(2),',',''); % remove commas from names
    out_state_names(i,1) = string_new(2);
end

% out_state_names = string_new(:,2);

for i = 1:length(out_state_names)
    string = out_state_names{i};
    new_string = strrep(string,'[','_');
    new_string = strrep(new_string,']','_');
    new_string = strrep(new_string,',','_');
    out_state_names{i} = new_string;
end

out_state_names{end+1} = 'Time';

% out_state_names = {'WAMIT_x';
%                    'WAMIT_y';
%                    'WAMIT_z';
%                    'WAMIT_xm';
%                    'WAMIT_ym';
%                    'WAMIT_zm';
%                    'Wave1Elev';
%                    'HydroFzi';
%                    'HydroFyi';
%                    'HydroFxi';
%                    'HydroMyi';
%                    'HydroMxi';
%                    'HydroMzi';}

%% Save Response in Structure
save_dir = sprintf('Simulations/%s',ss_sim);
cd(save_dir);

values = transpose(num2cell(y,1));
ss_results = cell2struct(values,out_state_names,1);
save(save_name,"ss_results");

if type == 2
    save(sprintf('%s.mat',data_name),'test');
end

clc
disp('Comparison results saved successfully!');
cd('..\');

%% Close All Files
fclose all;
clear all;
