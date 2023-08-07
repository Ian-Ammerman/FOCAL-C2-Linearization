% Program to form the test results into a structure and rename the
% variables to match with FAST

% Written By: Ian Ammerman
% Written: 8/3/23

clear all; close all; clc;
home = 'C:\Umaine Google Sync\GitHub\FOCAL-C2-Linearization\OpenFAST';
cd(home);

%% --------------- USER INPUTS --------------- %%
test_name = 'Irr4_s1_fixedTMD';
simulation_name = 'Irr4_s1_fixed';

%% Read in Test Data
if contains(test_name,'fixed')
    cd('Test_Data/Fixed TMD');
elseif contains(test_name,'pitch')
    cd('Test_Data/Pitch Frequency')
elseif contains(test_name,tower)
    cd('Test_Data/Tower Frequency')
end

new_labels = {'Time','Wave1Elev','PtfmSurge','PtfmSway','PtfmHeave','PtfmRoll'...
    ,'PtfmPitch','PtfmYaw','TwrBsMyi','TwHt2Alxt','TwHt1Alxt','T_1_','T_2_',...
    'T_3_','SStC1_zQ','SStC2_zQ','SStC3_zQ'};

load(sprintf('%s.mat',test_name));
time = channels(:,1);

%% Build New Structure
test_results = struct();
test_results.Time = time;
for i = 2:length(new_labels)
    test_results.(new_labels{i}) = channels(:,i);
end

%% Save File in Simulation Directory
cd(sprintf('../../Simulations/%s',simulation_name));
save('Test_Results.mat','test_results');