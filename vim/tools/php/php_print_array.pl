#!/usr/bin/perl

while (<STDIN>)
{
	($arrayName) = m/([^\s]*) _printArray/;
	my $output =<< "END";
    print("<pre>");
    print_r(\$${arrayName});
    print("</pre>");
END
print $output;
}
