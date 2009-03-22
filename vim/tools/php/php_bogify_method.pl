#!/usr/bin/perl -w

while (<STDIN>)
{
	($methodName) = m/(\w*) _bogifyMethod/;

	my $output =<< "END";
	public \$_${methodName}_retVal;
	public \$_${methodName}_throw;
	public \$_${methodName}_nextException;
	public \$_${methodName}_nextExceptionMessage;
	public function ${methodName}()
	{
		\$this->_methodCalls[] = "${methodName}";
		if(\$this->_${methodName}_throw == true)
		{
			\$reflector = new ReflectionClass(\$this->_${methodName}_nextException);
			if(\$reflector->isInstantiable())
			{
				throw \$reflector->newInstance(\$this->_${methodName}_nextExceptionMessage);
			}
		}
		return \$this->_${methodName}_retVal;
	}
END
print $output;
}

