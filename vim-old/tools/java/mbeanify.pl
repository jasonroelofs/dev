#!/usr/bin/perl 

while (<STDIN>)
{
	($type, $fname) = m/(\w*)\s+(\w*)\s+_beanify/;

	$uname = $fname;
	$uname =~ s/^m_//;
	$uname =~ s/\b(\w)/\U$1/;

	print "\t$type $fname;\n";
	print "\n";
	print "\tpublic void set$uname($type p$uname)\n";
	print "\t{\n";
	print "\t\t$fname = p$uname;\n";
	print "\t}\n";
	print "\n";
	print "\tpublic $type get$uname()\n";
	print "\t{\n";
	print "\t\treturn $fname;\n";
	print "\t}\n";

}
