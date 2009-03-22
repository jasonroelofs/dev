#!/usr/bin/perl

while (<STDIN>)
{
	($type, $methodName) = m/(\w+)\s+(\w+) _newMethod/;
	if (not $type)
	{
		($methodName) = m/(\w+) _newMethod/;
		$type = "void";
	}

	my $output =<< "END";
	/**
	 * Describe ${methodName} here.
	 *
	 * \@param type Name Description
	 * \@throws type Description
	 * \@return type Description
	 */
	${type} ${methodName}();
END
print $output;
}
