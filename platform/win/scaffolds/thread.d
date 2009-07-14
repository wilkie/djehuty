/*
 * thread.d
 *
 * This file implements the Scaffold for platform specific Thread
 * operations in Windows.
 *
 * Author: Dave Wilkinson
 *
 */

module platform.win.scaffolds.thread;

import core.view;
import core.string;
import core.file;
import core.graphics;
import core.color;
import core.main;
import core.definitions;
import core.string;

import synch.thread;

import platform.win.main;
import platform.win.common;
import platform.win.definitions;
import platform.win.vars;

/*extern(Windows)
DWORD _win_djehuty_thread_proc(void* udata)
{
	Thread t = cast(Thread)udata;

	t.run();

	ThreadPlatformVars* threadVars = ThreadGetPlatformVars(t);

	threadVars.thread = null;
	threadVars.thread_id = 0;

	ThreadUninit(t);

	return 0;
}

void ThreadStart(ref ThreadPlatformVars threadVars, ref Thread thread)
{
	threadVars.thread = CreateThread(null, 0, &_win_djehuty_thread_proc, cast(void*)thread, 0, &threadVars.thread_id);
}

void ThreadStop(ref ThreadPlatformVars threadVars)
{
	if (threadVars.thread_id == GetCurrentThreadId())
	{ // soft exit if called from the created thread
		ExitThread(0);
	}
	else
	{ // hard exit if called from another thread
		TerminateThread(threadVars.thread, 0);
	}

	threadVars.thread = null;
	threadVars.thread_id = 0;
}*/

void ThreadSleep(ref ThreadPlatformVars threadVars, ulong milliseconds)
{
	while (milliseconds > 0xFFFFFFFF)
	{
		.Sleep(0xFFFFFFFF);

		milliseconds -= 0xFFFFFFFF;
	}
	.Sleep(cast(uint)milliseconds);
}

//bool ThreadIsCurrent(ref ThreadPlatformVars threadVars)
//{
//	return threadVars.thread_id == GetCurrentThreadId();
//}












// Semaphores

void SemaphoreInit(ref SemaphorePlatformVars semVars, ref uint initialValue)
{
	semVars._semaphore = CreateSemaphoreA(null, (initialValue), 0xFFFFFFF, null);
}

void SemaphoreUninit(ref SemaphorePlatformVars semVars)
{
	CloseHandle(semVars._semaphore);
}

void SemaphoreUp(ref SemaphorePlatformVars semVars)
{
	ReleaseSemaphore(semVars._semaphore, 1, null);
}

void SemaphoreDown(ref SemaphorePlatformVars semVars, uint ms)
{
	WaitForSingleObject(semVars._semaphore, ms);
}

void SemaphoreDown(ref SemaphorePlatformVars semVars)
{
	WaitForSingleObject(semVars._semaphore, INFINITE);
}





// Mutexes

void MutexInit(ref MutexPlatformVars mutVars)
{
	InitializeCriticalSection(mutVars._mutex);
}

void MutexUninit(ref MutexPlatformVars mutVars)
{
	DeleteCriticalSection(mutVars._mutex);
}

void MutexLock(ref MutexPlatformVars mutVars)
{
	EnterCriticalSection(mutVars._mutex);
}

void MutexLock(ref MutexPlatformVars mutVars, ref uint ms)
{
	EnterCriticalSection(mutVars._mutex);
}

void MutexUnlock(ref MutexPlatformVars mutVars)
{
	LeaveCriticalSection(mutVars._mutex);
}


