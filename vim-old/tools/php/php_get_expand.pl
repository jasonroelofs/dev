#!/usr/bin/perl 

while (<STDIN>)
{
	($type, $varName) = m/(\w*)\s+(\w+) _getSet/;
	if (! $varName)
	{
		($varName) = m/(\w+) _getSet/;
	}
	
	$varNameUpper = $varName;
	$varNameUpper =~ s/\b(\w)/\U$1/; # u-case the first letter

	if ($type)
	{
		$type += " ";
	}

	my $output =<< "END";
/**
 * Accessor for the ${varName} ivar
 * \@return ${type}The current value for ${varName}
 */
public function get${varNameUpper}()
{
	return \$this->${varName};
}

/**
 * Setter for the ${varName} ivar
 * \@param ${type}The new value for ${varName}
 */
public function set${varNameUpper}(\$newVal)
{
	\$this->${varName} = \$newVal;
}
END
print $output;
}

