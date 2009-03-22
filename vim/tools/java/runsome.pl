#
# runsome.pl
#
# This script, in conjunction with vim macros, is used to 
# specify specific test methods within a JUnit test suite
# to be run.
#
# To use: in vim, use mouse (or visual mode) to highlight a region of test code,
# then hit @y 
# 
my @methods;
my $className = shift;

while (<STDIN>)
{
	$line = $_;

	if ($line =~ m/^\s*public\s+void\s+(test[^(]*)/) {
		push @methods, $1;
	}
}

foreach $m (@methods) {
  print "\t\t\tsuite.addTest(new $className(\"$m\"));\n";
}

__END__

Macro defs:
The three lines below should be recorded into your vim session as named macros.
(Eg, go to the first one and type "ayy in edit mode, then "syy, etc.)
They are named:
a
s
y



mm/runall = wwcwtrue'm
mm/runall = wwcwfalse'm
"zymm/runall = wwcwfalse/RUN_SOME_HERE€kdmn/return suite;€kud'nO/RUN_SOME_HEREo€kb€kb€kb"zpv/return suite;€ku:!perl ~/.jpath/runsome.pl `sh ~/.jpath/findclass.sh %:p`'m


---------------
What you need to setup in your test suite code:

  static boolean runall = true;

	public static Test suite() {
		if (runall) 
		{
			// include all test methods in class
			return new TestSuite(DTestInstrumentDtp94.class);
		}
		else
		{
			// Selected tests:
			TestSuite suite = new TestSuite();

			// RUN_SOME_HERE
			

			return suite;
		}
	}


