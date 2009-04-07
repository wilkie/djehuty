module platform.osx.thread;

class Thread
{

public:

	~this()
	{
		Stop();
	}

	// the common function for the thread
	void Call()
	{
		if (_thread_callback !is null)
		{
			_thread_callback();
		}
		else if (_thread_f_callback !is null)
		{
			_thread_f_callback();
		}
	}

	void SetDelegate(void delegate() callback)
	{
		_thread_callback = callback;
		_thread_f_callback = null;
	}

	void SetDelegate(void function() callback)
	{
		_thread_f_callback = callback;
		_thread_callback = null;
	}

	bool IsCurrentThread()
	{
	}

	void Sleep(long milliseconds)
	{
	}

	void Start()
	{
	}

	void Stop()
	{
	}

protected:

	void delegate () _thread_callback = null;
	void function () _thread_f_callback = null;

}


class Semaphore
{
public:

	~this()
	{
		if (_inited)
		{
			CloseHandle(_semaphore);
		}
	}

	void Init(uint initialValue)
	{
	}

	void Up()
	{
	}

	void Down()
	{
	}

protected:

}
