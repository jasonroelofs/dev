#!/usr/bin/perl -w



while (<STDIN>)
{
	($subname) = m/(\w*)/;

	print "=head2 $subname\n";
	print "\n\n";
	print "=cut\n";
	print "\n";
	print "sub $subname {\n";
	print '  my $self = shift;' . "\n";
	print "}\n";

}

