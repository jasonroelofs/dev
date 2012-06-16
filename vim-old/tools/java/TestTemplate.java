package _PACKAGENAME_;

import junit.framework.*;

public class Test_CLASSNAME_ extends TestCase {

	public Test_CLASSNAME_(String name) {
		super(name);
	}

	/**
	 * Called before the execution of every test method. 
	 */
	protected void setUp() throws Exception {}

	/**
	 * Called after the execution of every test method. 
	 */
	protected void tearDown() throws Exception {}

	/**
	 * Called before any of the test methods defined in the
	 * test suite are executed. 
	 * Returning false from this method aborts test suite.
	 */
	public static boolean suiteSetUp() { return true; }

	/**
	 * Called after the execution of every test method in the suite.
	 */
	public static void suiteTearDown() {}
	

	/**
	 * Return a TestSuite 
	 */
	public static Test suite() {
		// Automatic test method discovery:
		TestSuite suite = new TestSuite(Test_CLASSNAME_.class);
		// Optional: Include only specified methods in suite:
		//  		TestSuite suite = new TestSuite();
		//  		suite.addTest(new Test_CLASSNAME_("testSomething"));
		return suite;
	}

	/**
	 * For standalone suite execution:
	 */
	public static void main(String args[]) {
		// run all test methods in suite with the textui runner
		junit.textui.TestRunner.run(suite());
		System.exit(0);
	}

	// 
	// TEST METHODS BELOW HERE
	//

	/**
	 * See that something 
	 */
	public void testSomething() throws Exception {
		fail("implement me");
	}
	
}


