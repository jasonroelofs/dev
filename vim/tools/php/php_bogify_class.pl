#!/usr/bin/perl -w

while (<STDIN>)
{
	($className) = m/(\w*) _bogifyClass/;

	my $output =<< "END";
/**
 * Bogus $className
 */
class Bogus$className extends $className
{
	public \$_methodCalls;
	protected \$__bogusPattern;
	protected \$__properties;

	public function __construct()
	{
		\$this->_methodCalls = array();
		\$this->__bogusPattern = '/^_(.*)\$/';
		// Build a list of class properties
		\$this->__properties = array();
		\$ref = new ReflectionClass("$className");
		foreach(\$ref->getProperties() as \$prop)
		{
			\$this->__properties[] = \$prop->getName();
		}

		parent::__construct();

	}

	public function __call(\$name, \$arguments)
	{
		// Check to see if it matches the bogus pattern
		\$matches = array();
		if(preg_match(\$this->__bogusPattern, \$name, \$matches) == 1)
		{
			\$realMethodName = \$matches[1];
			if(method_exists(\$this, \$realMethodName)){
				return call_user_func_array(array(\$this, \$realMethodName), \$arguments);
			}
			else
			{
				throw new Exception("No such method '\$realMethodName' in class $className");
			}
		}
	}

	public function __get(\$name)
	{
		\$matches = array();
		if(preg_match(\$this->__bogusPattern, \$name, \$matches) == 1)
		{
			\$realVarName = \$matches[1];
			if(in_array(\$realVarName, \$this->__properties))
			{
				return \$this->\$realVarName;
			}
		}
	}

	public function __set(\$name, \$value)
	{
		\$matches = array();
		if(preg_match(\$this->__bogusPattern, \$name, \$matches) == 1)
		{
			if(in_array(\$matches[1], \$this->__properties))
			{
				\$this->\$matches[1] = \$value;
			}
		}
	}
}
END
	print $output;
}


