#!/usr/bin/perl -w

while (<STDIN>)
{
	($key) = m/(\w*) _bogifyMethod/;

	print "\tpublic void $key() {\n";
	print "\t\t_calls.add(\"$key\");\n";
	print "\t}\n";
}
