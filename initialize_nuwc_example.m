function [  ] = initialize_nuwc_example(  )

set_up_matlab_path( );

set_up_simulink_work_directories( );

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
	
codeGenerationConfigurationObject = coder.config( 'lib' ); %#ok<NASGU> This variable is used later, but in command form, not function form.

cd( generatedCodeDirectoryAbsolutePath );

try


codegen -config codeGenerationConfigurationObject main_entry_point -args 2.0;

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