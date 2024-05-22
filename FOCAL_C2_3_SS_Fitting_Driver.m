% SS Fitting driver for FOCAL campaign 2/3
% Written By: Ian Ammerman
% Written: 6/15/23

close all; clear all; clc;

%% Define Home
home_dir = 'C:\Umaine Google Sync\Masters Working Folder\FOCAL_C2';

if strcmp(home_dir,pwd) == 0
    cd(home_dir)
end

%% Excitation Fitting
% Define Input File
input_file = 'Excitation_Fitting_FOCAL_C2_3.inp';
input_path = sprintf('SS_Fitting\\%s',input_file);

% Call SS_Fitting Routine
[Newtime,ssExcite,Aglobal,Bglobal,Cglobal,Dglobal]=SS_Fitting_Wave_Excitation(input_path)

% Radiation Fitting
% Define Input File
input_file = 'Radiation_Fitting_FOCAL_C2_3.inp';
input_path = sprintf('SS_Fitting\\%s',input_file);

% Call SS_Fitting Routine
ss_fitting(input_path);