% Simulink Driver

% Written By: Ian Ammerman
% Written: 7/12/23

close all; 
% clearvars -except tosave; 
clc;

%% ---------- USER INPUTS ---------- %%
sim_name = 'Irr4_s1_fixed'

HD_mod = 'Linear_Locked_HD';
Platform_mod = 'Linear_Locked_Platform';

wave_elevation = 'Irr4_s1_fixed.Elev'
%%% --------------------------------%%%

%% Setup
% Home Directory
home_dir = 'C:\Umaine Google Sync\GitHub\FOCAL-C2-Linearization\OpenFAST';

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

A_platform = A;
B_platform = B;
C_platform = C;
D_platform = D;
Ptfm_yop = cell2mat(SS_data.y_op);
cd(home_dir);

%% Load Wave Information
cd('Wave_Files');
wave = readmatrix(wave_elevation,'FileType','text','Delimiter','\t');
time = wave(:,1);
index = dsearchn(time,5000); % Only want first 1000s to keep sim time down

trunc_wave = wave(1:index,:);
time = trunc_wave(:,1);
HD_input = trunc_wave;
cd(home_dir);

%% Prepare Simulink Inputs
% Define HydroDyn operating point
for i = 1:length(HD_operating_point)
    oper = cell2mat(HD_operating_point(i));
    HD_op(i,1) = oper(1);
end

% Define state names
for i = 1:length(SS_data.x_desc);
    string = SS_data.x_desc{i};
    string_new = strrep(string,' ','_');
    state_names{1,i} = string_new;
end

% Specify initial conditions
IC = zeros(1,length(SS_data.x_op)+1);
% IC(2) = 9.06;

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

%% Store output data in structure
cd(sprintf('Simulations/%s',sim_name));

simulink_results = [t_out,data_out'];

for i = 1:length(out_state_names);
    out_structure.(out_state_names{i}) = simulink_results(:,i);
end

slx_results = out_structure

% Save output to file
save('Simulink_Results',"slx_results");

