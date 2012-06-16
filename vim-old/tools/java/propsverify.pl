#!/usr/bin/perl

#$srcfile = "PnlTerminalContainer.java";
#$propsfile = "toolcrib_terminal.properties";

$srcfile = shift;
$propsfile = shift;

if (!$srcfile || !$propsfile) {
	die "Usage: propsverify.pl <srcfile> <propsfile>\n";
}




print "Verifying keys in '$srcfile' against '$propsfile'...\n";

# Find all keys used in getString() or getChar() calls:
$text = `cat $srcfile`;
@usedkeys = $text =~ m/get(?:String|Char)\s*\(\s*"(.*?)"/sg;

# List the available keys in the props file
open PFILE, $propsfile or die "Couldn't open $propsfile";
my @keys;
while (<PFILE>) {
  chomp;
	if (m/^\s*#/) {
	  next;
	} elsif (m/\=/ and m//) {
		($key) = split /\s*=/;
		push @keys, $key;
	}
}

#DEBUG
if (0) {
	print "DEFINED:\n";
	foreach (@keys) {
		print;
		print "\n";
	}
	print "USED:\n";
	foreach (@usedkeys) {
		print;
		print "\n";
	}
}

# Find out which keys used in the source are 
# not defined in the props file.
my @undef;
foreach $check (@usedkeys)  {
	if (grep(/^$check$/, @keys) < 1) {
		push @undef, $check;
    #print "Undefined key: $check\n";
	}
}


# Report undefined key usage:
if (@undef) {
	foreach (@undef) {
		print "Undefined key: $_\n";
	}
} else {
	print "OK\n";
}
