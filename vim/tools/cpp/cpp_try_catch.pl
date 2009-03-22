#!/usr/bin/perl

while (<STDIN>)
{
	($exceptionType) = m/(\w*) _tryCatch/;
	if (not $exceptionType)
	{
		$exceptionType = "Exception";
	}	

	my $output =<< "END";
try
{

}
catch (${exceptionType} ex)
{
// Do something
}
END
print $output;
}
