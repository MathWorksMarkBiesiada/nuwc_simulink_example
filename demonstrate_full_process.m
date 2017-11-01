function [ ] = demonstrate_full_process( )

set_up_matlab_path( );

set_up_simulink_work_directories( );

%% Simulate the model
modelBaseName = 'nuwc_parent_model';

open_system( modelBaseName );

set_param( modelBaseName, 'SimulationCommand', 'update' );


% There are multiple ways to create a series of time vectors, and they all
% compound error differently. The method below lines up with how Simulink
% manages time internally:
localSimulinkSimulationInputTimeSteps = [ 0 : 50 ]' * 0.1;

localSimulinkSimulationInputValues = sin( localSimulinkSimulationInputTimeSteps );

% The configuration parameters steer the model to read these variables from
% the base workspace, so we need to copy them there, using the names
% specified in the configuration parameters.
assignin( 'base', 'simulinkSimulationInputTimeSteps', localSimulinkSimulationInputTimeSteps );
assignin( 'base', 'simulinkSimulationInputValues', localSimulinkSimulationInputValues );

% Because of the configuration parameters, running "sim" implicitly
% creates "simulinkSimulationOutputTimeSteps" and
% "simulinkSimulationOutputValues" in the calling workspace.
sim( modelBaseName );

%% Confirm that the MATLAB functions match the simulation:
parameterValue = double( 42.0 );

stepQuantity = numel( simulinkSimulationOutputTimeSteps );
matlabSimulationOutputValues = zeros( stepQuantity, 1 );
for stepIndex = 1 : stepQuantity
	
	currentInputValue = ...
		localSimulinkSimulationInputValues( stepIndex );
	
	expectedOutputValue = ...
		simulinkSimulationOutputValues( stepIndex );
	
	currentOutputValue = ...
		main_entry_point( currentInputValue, parameterValue );
	
	matlabSimulationOutputValues( stepIndex ) = currentOutputValue;
	
	assert( currentOutputValue == expectedOutputValue );
	
end

%% Generate code:
generate_c_code_from_matlab( );

return;
end

function [ ] = generate_c_code_from_matlab( )

originalDirectory = pwd( );

thisFilesFullName = mfilename( 'fullpath' );

thisFilesAbsolutePath = fileparts( thisFilesFullName );

generatedCodeDirectoryAbsolutePath = ...
	fullfile( thisFilesAbsolutePath, 'generated_code' );

codeGenerationException = [ ];
	
codeGenerationConfigurationObject = ...
	coder.config( 'lib' );

codeGenerationConfigurationObject.GenerateReport = true;

codeGenerationConfigurationObject.Verbose = true;

cd( generatedCodeDirectoryAbsolutePath );

try


codegen -config codeGenerationConfigurationObject main_entry_point -args { 2.0, 42 };

catch codeGenerationException
	% We'll rethrow this later.
end

cd( originalDirectory );

if( isempty( codeGenerationException ) )
	% No problems occurred.
else
	rethrow( codeGenerationException );
end


return;
end


function [ ] = set_up_matlab_path( )

thisFilesFullName = mfilename( 'fullpath' );

thisFilesAbsolutePath = fileparts( thisFilesFullName );

directoriesToAddToMatlabPath = ...
	{ ...
	thisFilesAbsolutePath, ...
	fullfile( thisFilesAbsolutePath, 'models' ), ...
	fullfile( thisFilesAbsolutePath, 'data_dictionaries' ), ...
	fullfile( thisFilesAbsolutePath, 'matlab_code' ) ...
	};

cellfun( @addpath, directoriesToAddToMatlabPath );

return;

end

function [ ] = set_up_simulink_work_directories( )

thisFilesFullName = mfilename( 'fullpath' );

thisFilesAbsolutePath = fileparts( thisFilesFullName );

simulationCacheDirectoryAbsolutePath = ...
	fullfile( thisFilesAbsolutePath, 'simulation_cache' );

Simulink.fileGenControl('set', 'CacheFolder', simulationCacheDirectoryAbsolutePath, 'createDir', true );

generatedCodeDirectoryAbsolutePath = ...
	fullfile( thisFilesAbsolutePath, 'generated_code' );

Simulink.fileGenControl('set', 'CodeGenFolder', generatedCodeDirectoryAbsolutePath, 'createDir', true );

return;
end