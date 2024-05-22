%% Simulate Non-Linear OpenFAST
clear all; close all; clc;
tests = {'C2_PinkNoise'};

FASTdir = 'C:\\Umaine Google Sync\Masters Working Folder\FOCAL_C2';
model = 'DT1';

for i = 1:length(tests)
    runFAST(model,tests{i},FASTdir,'CheckSimFolder',false);
end

%% Perform OpenFAST Linearization
clear all; close all; clc;
tests = {'000_Linearize'};

FASTdir = 'C:\\Umaine Google Sync\Masters Working Folder\FOCAL_C2';
model = 'DT1_Locked_Platform';

for i = 1:length(tests)
    runFAST(model,tests{i},FASTdir,'MoveFiles',false,'Linearize',true,...
        'CheckSimFolder',false,'HydroDyn',false);
end

% Check Observability


%% Run State-Space Model
clear all; close all; clc;
% tests = {'FD_Surge','FD_Heave','FD_Pitch'}
tests = {'C2_PinkNoise'}

% FD_IC = readmatrix('FD_IC.csv');
% FD_IC = FD_IC(:,2);

SLXdir = 'C:\Umaine Google Sync\Masters Working Folder\FOCAL_C2';
model = 'DT1_Locked';

for i = 1:length(tests)
    IC_x = zeros(20,1);
    % IC_x(i) = FD_IC(i);
    simout = runSLX(model,tests{i},SLXdir,'SeparateOutput',true,'InitialConditions',IC_x);
end

%% Run State-Space w/ Kalman Filter
clear all; close all; clc;

tests = {'Test_01'}
measurements = {'PtfmPitch','PtfmRoll','FAIRTEN1','FAIRTEN2','FAIRTEN3'};

SLXdir = 'C:\Umaine Google Sync\Masters Working Folder\FOCAL_C2';
model = 'DT1_Locked';

for i = 1:length(tests)
    IC_x = zeros(20,1);
    runSLX(model,tests{i},SLXdir,'Observer',true,'MeasurementFields',measurements,...
        'SeparateOutput',true,'InitialConditions',IC_x);
end