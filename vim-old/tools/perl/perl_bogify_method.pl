#!/usr/bin/perl -w

while (<STDIN>)
{
	($key) = m/(\w*) _bogifyMethod/;

	print "field '$key" . "_called';\n";
	print "field '$key" . "_params';\n";
	print "field '$key" . "_ret_val';\n";
	print "sub $key {\n";
	print "\$self->$key" . "_called(1);\n";
	print "my \@params = \@_;\n";
	print "\$self->$key" . "_params(\\\@params);\n";
	print "return \$self->$key" . "_ret_val();\n";
	print "}\n\n";

}

