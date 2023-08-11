% Simulink Driver

% Written By: Ian Ammerman
% Written: 7/12/23

close all; 
% clearvars -except tosave; 
clc;

%% ---------- USER INPUTS ---------- %%
% Simulation time
sim_time = 3000;

% Simulation source information
sim_name = 'test_01'
HD_mod = 'Linear_Locked_HD';
Platform_mod = 'Linear_Locked_Platform_Red';
wave_elevation = 'test_01.Elev'



%%% --------------------------------%%%

%% Setup
% Directories
home_dir = 'C:\Umaine Google Sync\GitHub\FOCAL-C2-Linearization\OpenFAST';
sim_dir  = sprintf('Simulations/%s',sim_name);

% Check if home - if not, go there
isHome = strcmp(cd,home_dir);
if isHome ~= 1
    cd(home_dir);
end

%% Load State-Space Models
HD_dir = sprintf('Models/%s',HD_mod);
Platform_dir = sprintf('Models/%s',Platform_mod);

%%% ---------- Load HydroDyn Model ---------- %%%
cd(HD_dir); 
load("CCT9_LC34_A");
load("CCT9_LC34_B");
load("CCT9_LC34_C");
load("CCT9_LC34_D");
load("CCT9_LC34_ss_data.mat");

% Define model
A_HD = A; B_HD = B; C_HD = C; D_HD = D;
HD_operating_point = SS_data.u_op;
HD_yop = cell2mat(SS_data.y_op)*0;

cd(home_dir); 
%%% ----------Load Platform Model ---------- %%%
cd(Platform_dir);
load("CCT9_LC34_A");
load("CCT9_LC34_B");
load("CCT9_LC34_C");
load("CCT9_LC34_D");
load("CCT9_LC34_ss_data.mat")

% Define Model
A_platform = A;
B_platform = B;
C_platform = C;
D_platform = D;
Ptfm_yop = cell2mat(SS_data.y_op);
cd(home_dir);

%% Load Wave Information
cd('Wave_Files');
wave = readmatrix(wave_elevation,'FileType','text');
time = wave(:,1);
index = dsearchn(time,sim_time); % Only take up to sim_time
trunc_wave = wave(1:index,:); % trim time vetor
time = trunc_wave(:,1);
cd(home_dir)

%% Format Simulink Inputs
% NOTE: Initial conditions defined in user inputs section
cd(sim_dir);

% Wave Elevation Input
HD_input = trunc_wave;

% Observer feedback (L)
L_platform = zeros(11,1); % zero out for now

% Specify initial conditions
IC = zeros(1,length(SS_data.x_op)+1);
% IC(2) = -3.16; % surge

% Plant simulation
load('OpenFAST_Results.mat');
fields = fieldnames(sim_results);
plant = zeros(200001,length(fields));
for i = 1:length(fieldnames(sim_results));
    var = sim_results.(fields{i});
    plant(:,i) = var;
end
live_measurement = plant;
cd(home_dir)
%% Run Simulink Model & Extract Output Data
cd('Models/Simulink');
simulation_output = sim('Linear_Decoupled_HD.slx','StartTime',...
    num2str(min(time)),'StopTime',num2str(max(time)));
cd(home_dir);

% Output data & state names
sim_out = simulation_output.platform_out;
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
out_state_names = horzcat({'Time'},out_state_names);

%% Process output data
t_out = sim_out.Time;

for i = 1:size(sim_out.Data,3);
    data_out(:,i) = sim_out.Data(:,1,i);
end

% Add operating point to output
op = cell2mat(SS_data.y_op);
for i = 1:width(data_out)
    data_out(:,i) = data_out(:,i) + op;
end

% Center around zero
for i = 1:width(data_out)
    data_out(:,i) = rMean(data_out(:,i));
end

%% Store output data in structure
cd(sim_dir);

simulink_results = [t_out,data_out'];

for i = 1:length(out_state_names);
    out_structure.(out_state_names{i}) = simulink_results(:,i);
end

slx_results = out_structure;

% Save output to file
save('Simulink_Results',"slx_results");

