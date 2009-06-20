module synch.mutex;

import platform.imports;
mixin(PlatformGenericImport!("vars"));
mixin(PlatformGenericImport!("definitions"));
mixin(PlatformScaffoldImport!());

// Section: Core/Synchronization

// Description: This class provides a simple mutex, also known as a binary semaphore.  This is provided as a means to manually lock critical sections.  It is initially unlocked.
class Mutex
{
	this()
	{
		Scaffold.MutexInit(_pfvars);
	}

	~this()
	{
		Scaffold.MutexUninit(_pfvars);
	}

	// Description: This function will lock the mutex.  This could be used to enter a critical section.
	void lock()
	{
		Scaffold.MutexLock(_pfvars);
	}

	// Description: This function will unlock a locked mutex.  This could be used to leave a critical section.
	void unlock()
	{
		Scaffold.MutexUnlock(_pfvars);
	}

	void lock(uint milliseconds)
	{
		Scaffold.MutexLock(_pfvars, milliseconds);
	}

	MutexPlatformVars _pfvars;
}
