#!/usr/bin/perl 

while (<STDIN>)
{
	($type, $varName) = m/(\w*)\s+(\w+) _getSet/;
	
	$varNameUpper = $varName;
	$varNameUpper =~ s/\b(\w)/\U$1/; # u-case the first letter

	my $output =<< "END";
/**
 * Accessor for the ${varName} ivar
 * \@return ${type} The current value for ${varName}
 */
public function get${varNameUpper}()
{
	return ${varName};
}

/**
 * Setter for the ${varName} ivar
 * \@param ${type} The new value for ${varName}
 */
public function set${varNameUpper}(p${varNameUpper})
{
	${varName} = p${varNameUpper};
}
END
print $output;
}

