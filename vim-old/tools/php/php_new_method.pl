#!/usr/bin/perl -w

while (<STDIN>)
{
	($methodName) = m/(\w*) _newMethod/;
	$access = "public";

	my $output =<< "END";
/**
 * Describe ${methodName} here.
 *
 * \@param type Name Description
 * \@throws type Description
 * \@return type Description
 */
${access} function ${methodName}()
{
	// Method internals here
}
END
print $output;
}

