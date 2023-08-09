# FOCAL-C2-Linearization
This repository represents the ongoing effort to create an accurate state-space model of the IEA task 37 15MW reference offshore wind turbine using the linearization capabilities of OpenFAST. The current OpenFAST models can be found in OpenFAST > Models, and information on these models will be added below. Additionally, you will find information on how to run the models and on the various Matlab scripts available. In short, to run the models as they are, simply clone/download the OpenFAST folder and use the included scripts as described below. No additional files should be necessary.

GENERAL FILE STRUCTURE
-----------------------
The OpenFAST directory is structured to allow simulation parameters and results to be automatically sorted and stored separately using the provided driver files. The main OpenFAST folder contains the following sub-folders:

    1. Hydro - This folder contains a copy of the potential flow analysis results along with the state-space fittings for platform excitation & radiation forces (.ss & .ssexctn)

    2. Models - This folder contains additional sub-folders, one for each OpenFAST model.

    3. SS_Fitting - This folder contains the results of the excitation state-space fitting along with the appropriate input files. The Matlab files and associated driver for performing the fittings will be added soon.

    4. Simulations - This folder contains simulation results. Each sub-folder represents a single test case and contains the simulated and experimental results for each.

    5. Test_Data - This folder contains the raw experimental data from the FOCAL campaign in the form of matlab matrices

    6. Wave_Files - This folder contains .Elev wave elevation files for use by OpenFAST via wavemod = 5

    7. bin - This folder contains the OpenFAST .exe file

DRIVING OPENFAST (FOCAL_C2_3_OpenFAST_Driver.m)
-----------------------------------------------
!! Important Driver Setup !!

The matlab script FOCAL_C2_3_OpenFAST_Driver.m is provided to run the OpenFAST simulations. Before using this driver, it is important to set the home directory correctly. Open the file in Matlab and replace the string in "home_dir" to its current location (DO NOT move the driver relative to the rest of the file structure). This same procedure is done for each driver in the repository.

!! End Driver setup !!

Once the home directory is set, the driver is ready to use. The "User Inputs" section at the start of the program contains all of the variables you will need to change to run the simulation. These are:

    1. model_name - Name of the folder contained in "Models" corrosponding to the OpenFAST model you want to use. This is where OpenFAST will go to get the input files.

    2. test_name - Name of the folder contained in "Simulations" where the outputs will be sent. For example, when simulating the wave case Irr_s1_fixed, the simulation folder and test_name variable should be named "Irr_s1_fixed".  

    3. wave_file - Name of the .Elev file contained in "Wave_Files" for HydroDyn to use. There is no need to change this name in the HydroDyn input file as the driver takes care of this.

    4. WaveTMax - Maximum time for the simulation. This MUST be greater than WaveTMax in HydroDyn.

Once these inputs have been updated, navigate to the corrosponding model folder and open the .fst and HydroDyn.dat files to ensure the following:

    1. TMax in the .fst file is less than or equal to WaveTMax
    2. WaveTMax in the HydroDyn.dat file is less than WaveTMax in the driver file.

With these checks performed, run the driver file using the Matlab GUI (or pressing f5). OpenFAST should run and save the outputs to a structure in the simulation folder.

PREPARING EXPERIMENTAL RESULTS (formatTestResults.m)
-----------------------------------------------------
!! This Matlab script works ONLY with the provided test data. For use with other test data, this script must be modified or the data reformatted !!

!! IMPORTANT: Driver home directory must be set as noted above !!

To format the appropriate test data into a structure to compare with the simulation results, navigate to the appropriate folder in "Test_Data". In the "User Inputs" section of the code, enter the following:

    1. test_name - Name of test data file (Ex. 'Irr4_s1_fixedTMD').
    2. simulation_name - Name of the outputs folder, as noted in the OpenFAST driver steps

Once set, run the script and the results will be added to the simulation folder. For guidelines on re-formatting data to match this script's standard, see below (WIP!!)

DRIVING STATE-SPACE MODEL (Simulink_Driver_v2.m)
-------------------------------------------------

The Simulink driver file is setup and used nearly the same as the OpenFAST driver file. Once the home directory is set, update the input variables:

    1. HD_mod - model containing the HydroDyn linearization
    2. Platform_mod - model containing the platform linearization
    3. wave_elevation - Name of wave elevation file to use for the simulation

Run the driver and the results will be saved in the simulation folder.

PLOTTING RESULTS (FOCAL_C2_3_Any_Sim_Plotter.m)
-------------------------------------
!! This script requires the use of a custom function "rMean.m", available on the Github !!

To plot the results of the simulation, open the FOCAL_C2_3_Any_Sim_Plotter.m file. Setup the home directory as before. In the user inputs section, enter the following:

    1. type - Row vector containing flags for each type of sim to plot, see legend
    2. plot_mark - Unused for now
    3. simulation - Name of simulation to plot
    4. xrange - Lower and upper x-axis limits for plotting
    5. desc - Cell array of descriptions (in order of type) for the plot legend

Near the bottom of the code, in a for loop, are the time and variable definitions (var1, var2, etc.). For each variable, change the field name in the structure call to the desired variable name. Change the corrosponding name in the varnames array above. If not all 4 plots are desired, change the "num_plot" variable below and only the first num_plot variables will be used.

Note: The call to the custom function "rMean" serves to remove the mean value from each variable. If undesired, this can removed. Otherwise, be sure to save this function to the Matlab path.

PSD RESULTS (PSD_Generator.m & PSD_Plotter.m)
----------------------------------------------
The two PSD scripts serve to generate and plot PSDs for result variables. Enter the test name, nsmooth desired value (for smoothing, higher is more smoothing) and end time for consideration in the "User Inputs" section, and run the script. Make sure to set the directory in the cd call to the correct simulations directory.

Once generated, use the PSD_Plotter.m file the same as the Any_Sim_Plotter before to plot the results.