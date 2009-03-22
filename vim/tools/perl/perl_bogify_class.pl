#!/usr/bin/perl -w

while (<STDIN>)
{
	($key) = m/(\w*) _bogifyClass/;

	print "\t##\n";
	print "\t# Bogus $key\n";
	print "\t##\n";
	print "\tpackage Bogus$key;\n";
	print "\tuse $key;\n";
	print "\tuse Spiffy '-Base';\n";
	print "\t\@Bogus$key" . "::ISA = '$key';\n";
	print "\nsub new() {\n";
	print "my \$ref = {};\n";
	print "bless(\$ref, 'Bogus$key');\n";
	print "return \$ref;\n\n";
	print "}\n";
}

