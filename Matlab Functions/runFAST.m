function runFAST(model,test,FASTdir,varargin)

%
% Written By: Ian Ammerman
% Written: 9/1/23
%
% runFAST(model,test,FASTdir) runs an OpenFAST simulation. Note that all directories are
% relative to the FASTdir.
%
% Inputs:
% ----------
% model - name of model to test
% test - name of test folder for saving
% FASTdir - home directory (absolute path) of the driver
%
% Optional Name-Value Pairs:
% ---------------------------
% 'Buffer',time - settling time to add before the simulation. Appends
% the wave elevation to a zero wave file and wind files to a zero wind file
% and offsets final output. Assumes tstart in OpenFAST is set to zero.
% Defaults to zero.
%
% 'MoveFiles',t/f - flag whether to relocate sim files from model folder to
% simulation folder. Useful for running linearizations. Defaults to true.
%
% 'Linearize',t/f - extracts state-space matrices from .lin files generated
% at simulation end. Defaults to false.
%
% 'CheckSimFolder',t/f - stops simulation if old output is detected in
% target simulation folder. Defaults to false.
%
% 'HydroDyn',t/f - if enabled, the linearization routine will extract the
% HydroDyn matrices in place of the platform dynamics

% -------------------------------------------------------------------- %

p = inputParser;
addRequired(p,'model',@ischar);
addRequired(p,'test',@ischar);
addRequired(p,'FASTdir',@ischar);
addOptional(p,'MoveFiles',true,@islogical);
addOptional(p,'Buffer',0,@isPositiveIntegerValuedNumeric)
addOptional(p,'CheckSimFolder',true,@islogical);
addOptional(p,'Linearize',false,@islogical);
addOptional(p,'HydroDyn',false,@islogical);

parse(p,model,test,FASTdir,varargin{:});

model = p.Results.model;
test = p.Results.test;
FASTdir = p.Results.FASTdir;
MoveFiles = p.Results.MoveFiles;
Buffer = p.Results.Buffer;
CheckSimFolder = p.Results.CheckSimFolder;
Linearize = p.Results.Linearize;
HydroDyn = p.Results.HydroDyn;
p.Results

cd(FASTdir)

%% Directory Names
bin_path = 'bin\openfast_x64.exe'
fst_path = sprintf('Models\\%s\\%s.fst',model,model)
model_path = sprintf('%s/Models/%s',FASTdir,model)
sim_folder = sprintf('%s/Simulations/%s',FASTdir,test)
out_name = sprintf('%s.out',model)

%% Prepare Inputs & Check Sim Folder
if Linearize == false
    prepWaveFile(Buffer,sim_folder);
    prepWindFile(Buffer,sim_folder);
end

if CheckSimFolder
    checkSimFolder(sim_folder,model);
end

%% Run OpenFAST
name = sprintf('%s %s',bin_path,fst_path);
[status,results] = dos(name,'-echo');

%% Relocate Output Files to Simulation Folder
if MoveFiles == false
    cd(model_path)
else
    disp('---------- Relocating Output Files -----------')
    cd(sim_folder)
    
    filetypes = {'.out','.ech','.sum','.lin'};
    for i = 1:length(filetypes)
        try
            movefile(sprintf('../../Models/%s/*%s',model,filetypes{i}));
            fprintf('Output files of type %s relocated. \n',filetypes{i});
        catch
            fprintf('No files of type %s detected. \n',filetypes{i});
        end
    end
end

%% Linearize (if enabled)
if Linearize
    if HydroDyn
        filename = sprintf('%s.1.HD.lin',model);
    else
        filename = sprintf('%s.1.lin',model);
    end

    extractLinear(filename,model);
    fprintf('%s linearization complete using %s!',model,filename)
end

%% Process Outputs & Save as Matlab Files
disp('---------- Processing Outputs -----------')
[sim_results,units] = readFastTabular(out_name);
sim_results.Time = sim_results.Time - min(sim_results.Time)-Buffer;
save('OpenFAST_Results.mat','sim_results');
save('OpenFAST_Units.mat','units');
fclose('all');

%% Run Complete
cd(FASTdir)
disp('---------- Simulation Run Complete -----------')
end