#!/usr/bin/perl -w

while (<STDIN>)
{
	($key) = m/(\w*) _skeleton/;
	open SFILE, "$ENV{HOME}/.vim/tools/java/skels/$key.skel" or exit;
	while (<SFILE>) 
	{
		print;
	}
}
