#!/usr/bin/perl -w

while (<STDIN>)
{
	($key) = m/(\w*) _bogifyClass/;

	print "\t/** BOGUS $key FOR TESTING something */\n";
	print "\tclass Bogus$key extends $key {\n";
	print "\t\tList _calls = new ArrayList();\n";
	print "\t\tpublic Bogus$key() {\n";
	print "\t\t}\n";
	print "\t}\n";
}
