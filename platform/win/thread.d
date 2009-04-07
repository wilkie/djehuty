module platform.win.thread;

import platform.win.common;

extern(Windows)
DWORD _win_djehuty_thread_proc(void* udata)
{
	Thread t = cast(Thread)udata;

	t.Call();

	t.thread = null;
	t.thread_id = 0;

	return 0;
}

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
		if (thread)
		{
			return thread_id == GetCurrentThreadId();
		}

		return false;
	}

	void Sleep(long milliseconds)
	{
		// we are given a long for length, windows only has an int function
		while (milliseconds > 0xFFFFFFFF)
		{
			.Sleep(0xFFFFFFFF);

			milliseconds -= 0xFFFFFFFF;
		}
		.Sleep(cast(uint)milliseconds);
	}

	void Start()
	{
		if (thread is null)
		{
			thread = CreateThread(null, 0, &_win_djehuty_thread_proc, cast(void*)this, 0, &thread_id);
		}
	}

	void Stop()
	{
		if (thread !is null)
		{
			if (thread_id == GetCurrentThreadId())
			{ // soft exit if called from the created thread
				ExitThread(0);
			}
			else
			{ // hard exit if called from another thread
				TerminateThread(thread, 0);
			}

			thread = null;
			thread_id = 0;
		}
	}

protected:

	void delegate () _thread_callback = null;
	void function () _thread_f_callback = null;

	HANDLE thread = null;
	DWORD thread_id = 0;

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
		_semaphore = CreateSemaphoreA(null, (initialValue), 0xFFFFFFF, null);
	}

	void Up()
	{
		ReleaseSemaphore(_semaphore, 1, null);
	}

	void Down()
	{
		WaitForSingleObject(_semaphore, INFINITE);
	}

protected:

	HANDLE _semaphore;
	bool _inited = false;

}
