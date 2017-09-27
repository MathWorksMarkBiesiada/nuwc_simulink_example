function [  ] = initialize_nuwc_example(  )

thisFilesFullName = mfilename( 'fullpath' );

thisFilesAbsolutePath = fileparts( thisFilesFullName );

%% Set up the MATLAB path:
directoriesToAddToMatlabPathCellStr = ...
	{ ...
	thisFilesAbsolutePath, ...
	fullfile( thisFilesAbsolutePath, 'models' ), ...
	fullfile( thisFilesAbsolutePath, 'data_dictionaries' ) ...	
	};

cellfun( @addpath, directoriesToAddToMatlabPathCellStr );


%% Set up the simulation cache and code-generation directories:
simCacheDirectory = ...
	fullfile( thisFilesAbsolutePath, 'simulation_cache' );

% The "createDir" argument is needed here because Git doesn't
% track empty directories without explicitly adding them. Since
% the "work" directory is likely to be purged prior to
% committing it to the repository, Git might not track it, and
% the directory might not exist for users that check out the
% repository.
Simulink.fileGenControl( 'set', ...
	'CacheFolder',      simCacheDirectory, ...
	'keepPreviousPath', true, ...
	'createDir',        true );

codeGenDirectory  = ...
	fullfile( thisFilesAbsolutePath, 'generated_code' );

% The "createDir" argument is needed here because Git doesn't
% track empty directories without explicitly adding them. Since
% the "work" directory is likely to be purged prior to
% committing it to the repository, Git might not track it, and
% the directory might not exist for users that check out the
% repository.
Simulink.fileGenControl( 'set', ...
	'CodeGenFolder',    codeGenDirectory, ...
	'keepPreviousPath', true, ...
	'createDir',        true );

return;

end

