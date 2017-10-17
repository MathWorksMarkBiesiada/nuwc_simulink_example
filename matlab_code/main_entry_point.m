function [ y ] = main_entry_point( u )
assert( isa( u, 'double' ) )
assert( isscalar( u ) );

y = u + 1;

return;

end

