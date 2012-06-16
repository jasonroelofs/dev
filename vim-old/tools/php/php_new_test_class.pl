#!/usr/bin/perl -w

while (<STDIN>)
{
	($testClass) = m/(\w*) _newTestClass/;

	my $output =<< "END";
<?php

include_once("PHPUnit2/Framework/TestCase.php");
include_once("PHPUnit2/Framework/IncompleteTestError.php");

class ${testClass}Test extends PHPUnit2_Framework_TestCase
{
	protected \$testMe;
	
	/**
	 * Constructor
	 */
	public function __construct()
	{
		parent::__construct("${testClass}Test");
	}
	
	/**
	 * This method is called before every test step
	 */
	public function setUp()
	{
		// Perform setup things here
	}
	
	/**
	 * This method is called after every test step
	 */                        
	public function tearDown()
	{
		// Perform teardown things here
	}
	
	//
	// Tests Below Here
	//
	public function testSomething()
	{
		throw new PHPUnit2_Framework_IncompleteTestError("Implement Me");
		
	}
}
?>
END
	print $output;
}
