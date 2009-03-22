#!/usr/bin/perl -w

while (<STDIN>)
{
	($key) = m/(\w*) _test/;

	$name = $key;
#	$name =~ s/\b(\w)/\U$1/; # u-case the first letter

	print "##\n";
	print "#  See that $key() \n";
	print "##\n";
	print "sub test_$name\n";
	print "{\n";
	print "  ok(0, \"implement me\");\n";
	print "}\n";
}
