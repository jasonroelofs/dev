#!/usr/bin/perl -w

while (<STDIN>)
{
	($key) = m/(\w*) _test/;

	$testName = $key;
	$testName =~ s/\b(\w)/\U$1/; # u-case the first letter

	my $output =<< "END";
	template<>
	template<>
	/**
	 * See that ${testName}
	 */
	void test${testName}()
	{
		fail("Implement Me");
	}
END
	print $output;
}
