function [ ] = generate_c_code_from_matlab( )

originalDirectory = pwd( );

thisFilesFullName = mfilename( 'fullpath' );

thisFilesAbsolutePath = fileparts( thisFilesFullName );

generatedCodeDirectoryAbsolutePath = ...
	fullfile( thisFilesAbsolutePath, '..', 'generated_code' );

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