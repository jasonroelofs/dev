#!/usr/bin/perl

while (<STDIN>)
{
	($type, $methodName) = m/(\w+)\s+(\w+) _bogifyMethod/;
	if (not $type)
	{
		($methodName) = m/(\w+) _bogifyMethod/;
		$type = "void";
	}

	my $output;

	if ($type eq "void")
	{
	$output =<< "END";
	bool _${methodName}_called;
	${type} ${methodName}()
	{
		_${methodName}_called = true;
	}
END
	}
	else
	{
	$output =<< "END";
	${type} _${methodName}_retVal;
	bool _${methodName}_called;
	${type} ${methodName}()
	{
		_${methodName}_called = true;
		return _${methodName}_retVal;
	}
END
	}
	print $output;
}
