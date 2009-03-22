#!/usr/bin/perl

# Scan the current CLASSPATH for all classes, and make an index 
# in the format:
#   <shortname> <fullname> <absolute-path>

# Get the CLASSPATH from the environment
open FSTR, "echo \$CLASSPATH|" or die "oops";
$cp = <FSTR>;
chomp($cp);
close FSTR;

# For each path entry
@els = split  /:/, $cp;
foreach (@els) {
	# Only for non-JAR entries:
	if (not /\.jar/ and not /^\.$/) {
		$root = $_;
    # Scan each classpath for .java files
		open JSTR, "find $root -name \"*.java\"|" or die "drat";
		while (<JSTR>) {
			chomp;
			$fullpath = $_;  # Absolute path to the file
			s/\.java//;
			s/$root\///;
			s/\//./g;
			$fullname = $_;  # Fully qualified class name
			($name) = $fullname =~ /\/?([^\.]*)$/; # Short classname
			print "$name $fullname $fullpath\n"; 
		}
		close JSTR;

	}
}
