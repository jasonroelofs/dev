#!/usr/bin/perl -w

#
# newtest.pl <source-file>
#
# Generate a new JUnit test suite for the given class.
# A template file is used and parameterized based on the
# class and package name (gotten from a lookup in classindex.txt)
# and a new file is created in the test hierarchy.
#
# TODO create dir hier before creating file
#

# Get argument

$source = shift;
if (!$source)
{
	die "Usage: newtest.pl <sourcefile>\n";
}

# Locate home dir
$jpathDir="$ENV{HOME}/.jpath";
$javaToolDir="$ENV{HOME}/.vim/tools/java";

# Lookup the fully qualified class name
$fullclass = `sh $jpathDir/findclass.sh $source`;

# Parse the package and short class name
($pkg, $class) = $fullclass =~ /^(.*)\.(\w*)$/;

# Get the root directory of the test tree
$troot = $ENV{JPATH_TESTROOT};

# Establish the on-disk path to the new test file
$tpath = "";
if ( $pkg ) {
	$tpath = $pkg;
	$tpath =~ s/\./\//g;
}

# Establish the full file name of the test file
$testfile = "$troot/$tpath/Test$class.java";

# Refuse to overwrite existing files
if ( -f $testfile ) {
	print "Test file [$testfile] exists.\n";
	exit 1;
}

# Make sure directory exists
`mkdirhier $troot/$tpath`;

# Copy template into place, parameterizing class and pkg name as we go.
`cat $javaToolDir/TestTemplate.java | sed -e 's/_CLASSNAME_/$class/g' | sed -e 's/_PACKAGENAME_/$pkg/' > $testfile`;

# Print full file name to stdout
print $testfile . "\n";
