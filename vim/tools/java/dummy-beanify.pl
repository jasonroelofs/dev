#!/usr/bin/perl 

while (<STDIN>)
{
	($type, $fname) = m/(\w*)\s+(\w*)\s+_beanify/;

	$uname = $fname;
	$uname =~ s/\b(\w)/\U$1/;

	print "\tpublic void set$uname($type val) {}\n";
	print "\tpublic $type get$uname() { return null; }\n";

}
