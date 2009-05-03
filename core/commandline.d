module core.commandline;

import core.string;

// Description: This class holds the command line arguments that were passed into the app and will aid in parsing them.
class CommandLine
{
static:
public:

	String[] getArguments()
	{
		return arguments;
	}
	
	void addArgument(String newArgument)
	{
		arguments ~= new String(newArgument);
	}

protected:

	String[] arguments;
}