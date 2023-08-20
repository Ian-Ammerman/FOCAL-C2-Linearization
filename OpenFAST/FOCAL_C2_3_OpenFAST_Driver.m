% FOCAL OpenFAST Model Driver
% Written by: Ian Ammerman
% Written: 5/31/23
% Last Modified: 8/3/23
close all; clear all; clc;

%%% -------------- USER INPUTS -------------- %%%

% MODEL
model_name = 'DT1_Locked_Platform';

% TEST DESCRIPTION
test_name = '0_DT1_Locked_Platform';

% WAVE CASE
wave_file = 'Test_01_fixed.Elev'

% WAVETMAX
WaveTMax = 10001;

%%% ------------ END USER INPUTS ------------ %%%

%% ----------- MODEL DEFINITIONS ----------- %%
% Model Inputs (Should remain constant for same system)
root_name = 'DT1';
home_dir = 'C:\Umaine Google Sync\GitHub\FOCAL-C2-Linearization\OpenFAST';

% Check if in home directory and go there if not
isHome = strcmp(cd,home_dir);

if isHome ~= 1
    cd(home_dir)
end

%% Prepare Wave File
cd('Wave_Files');
wave = readmatrix(wave_file,'FileType','text');
index = dsearchn(wave(:,1),WaveTMax);
wave = wave(1:index,:);
writematrix(wave,'InputWave.Elev','FileType','text','Delimiter','\t');
cd(home_dir);

%% Code
% Define file locations
bin_path = 'bin\openfast_x64.exe'
model_folder = 'Models';
sim_folder = sprintf('Simulations\\%s',test_name);
fst_path = sprintf('%s\\%s\\%s.fst',model_folder,model_name,root_name)

% Confirm simulation folder exists
if ~exist(sim_folder,'dir')
    errordlg("Simulation folder not found.",'Simulation Folder Error');
    return
end

% Confirm simulation folder clear of old data
cd(sim_folder)
out_name = sprintf('%s.out',root_name);
% 
% if isfile(out_name)
%     errordlg("Old output detected in simulation directory.",'Simulation Folder Error');
%     return
% end

% Run OpenFAST
cd(home_dir)
name = sprintf('%s %s',bin_path,fst_path);
[status,results] = dos(name,'-echo');
cd(sim_folder)

%% Move output files out of model inputs folder
disp('---------- Output Handling -----------')
try
    movefile(sprintf('../../Models/%s/*.out',model_name));
    disp('Output files of .out type relocated.');
catch
    disp('No files of type .out detected.')
end

try
    movefile(sprintf('../../Models/%s/*.ech',model_name));
    disp('Output files of .ech type relocated.');
catch
    disp('No files of type .ech detected.')
end

try
    movefile(sprintf('../../Models/%s/*.sum',model_name));
    disp('Output files of .sum type relocated.');
catch
    disp('No files of type .sum detected.')
end

try
    movefile(sprintf('../../Models/%s/*.lin',model_name));
    disp('Output files of .lin type relocated.');
catch
    disp('No files of type .lin detected.')
end

%% Read output files & Save Structure as .m File
[sim_results,units] = readFastTabular(out_name);
save('OpenFAST_Results.mat','sim_results');
save('OpenFAST_Units.mat','units');

%% Check for .lin File & Extract SS Matrices
lin_file = sprintf('%s.1.lin',root_name);
if isfile(lin_file)
    SS_data = ReadFASTLinear(lin_file);
    A = SS_data.A;
    B = SS_data.B;
    C = SS_data.C;
    D = SS_data.D;
    
    save(sprintf('%s_A.mat',root_name),'A');
    save(sprintf('%s_B.mat',root_name),'B');
    save(sprintf('%s_C.mat',root_name),'C');
    save(sprintf('%s_D.mat',root_name),'D');

    save(sprintf('%s_ss_data.mat',root_name));
end

%% Close Any Open File
fclose('all');











