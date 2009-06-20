module synch.semaphore;

import platform.imports;
mixin(PlatformGenericImport!("vars"));
mixin(PlatformGenericImport!("definitions"));
mixin(PlatformScaffoldImport!());

// Section: Core/Synchronization

// Description: This class abstracts a counting semaphore.
class Semaphore
{
public:

	~this()
	{
		if (_inited)
		{
			Scaffold.SemaphoreUninit(_pfvars);
		}
	}

	// Description: Creates an uninitialized semaphore.
	this()
	{
	}

	// Description: Creates and initializes a semaphore.
	// initialValue: The initial count for the semaphore.
	this(uint initialValue)
	{
		init(initialValue);
	}

	// Description: This function will initialize a semaphore and set it to an initial count.
	// initialValue: The initial count for the semaphore.
	void init(uint initialValue)
	{
		Scaffold.SemaphoreInit(_pfvars, initialValue);
		_inited = true;
	}

	// Description: This function will increment the count of the semaphore.
	void up()
	{
		Scaffold.SemaphoreUp(_pfvars);
	}

	// Description: This function will decrement the count of the semaphore as long as the count is greater than 0.  If not, it will yield the thread until the count is incremented via an up() call.  This is the blocking call of the semaphore.
	void down()
	{
		Scaffold.SemaphoreDown(_pfvars);
	}

	// Description: This function will decrement the count of the semaphore as long as the count is greater than 0.  If not, it will yield the thread until the count is incremented via an up() call.  This is the blocking call of the semaphore, but it will only block for as long as it is specified and will continue once there is a timeout.
	// milliseconds: The amount of time to block before continuing if the semaphore should have a count of zero.
	void down(uint milliseconds)
	{
		Scaffold.SemaphoreDown(_pfvars, milliseconds);
	}

protected:

	SemaphorePlatformVars _pfvars;

	bool _inited = false;


}
