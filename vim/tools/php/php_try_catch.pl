#!/usr/bin/perl -w

while (<STDIN>)
{
	($exceptionType) = m/(\w*) _tryCatch/;

	my $output =<< "END";
\ttry
\t{
	
\t}
\tcatch (${exceptionType} \$ex)
\t{
\t// Do something
\t}
END
print $output;
}
