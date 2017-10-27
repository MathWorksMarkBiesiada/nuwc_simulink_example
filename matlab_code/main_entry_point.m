function [ y ] = main_entry_point( u, gainParameter )

% The data types and dimensions in the generated code are determined by
% the example arguments provided. However, there is a risk of using
% different data types when calling the MATLAB code from *within* MATLAB,
% as opposed to calling the generated code.
%
% To mitigate this risk, we use the "assert(...)" statements below to
% ensure that errors are thrown unless the correct data types and
% dimensions are used in all cases.

assert( isa( u, 'double' ) )
assert( isscalar( u ) );

assert( isa( gainParameter, 'double' ) )
assert( isscalar( gainParameter ) );

[ y ] = parentModelAsMatlab( u, gainParameter );

return;

end

function [ y ] = parentModelAsMatlab( u, gainParameter )

% "coder.inline(...)" is used to ensure that this MATLAB function becomes
% its own function in the generated code, as opposed to being inlined.
coder.inline( 'never' );
y = childModelAsMatlab( u, gainParameter );

return;
end

function [ y ] = childModelAsMatlab( u, gainParameter )

% "coder.inline(...)" is used to ensure that this MATLAB function becomes
% its own function in the generated code, as opposed to being inlined.
coder.inline( 'never' );
y = u * gainParameter;

return;
end