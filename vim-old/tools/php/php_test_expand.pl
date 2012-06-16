#!/usr/bin/perl -w

while (<STDIN>)
{
	($key) = m/(\w*) _test/;

	$testName = $key;
	$testName =~ s/\b(\w)/\U$1/; # u-case the first letter

	my $output =<< "END";
	/**
	 * See that ${testName}
	 */
	public function test${testName}()
	{
		throw new PHPUnit2_Framework_IncompleteTestError("Implement me");
	}
END
	print $output;
}
