/*
 * thread.d
 *
 * This Scaffold holds the Thread implementations for the Linux platform
 *
 * Author: Dave Wilkinson
 *
 */

module platform.unix.scaffolds.thread;

import core.view;
import core.string;
import core.file;
import core.graphics;
import core.color;
import core.main;
import core.definitions;
import core.string;

import synch.thread;

import platform.unix.common;
import platform.unix.definitions;
import platform.unix.vars;

void ThreadSleep(ref ThreadPlatformVars threadVars, ulong milliseconds)
{
	timespec timetoexpire;

	timetoexpire.tv_sec = (milliseconds / 1000);
	timetoexpire.tv_nsec = (milliseconds % 1000) * 1000000;

	nanosleep(&timetoexpire, null);
}

/*

extern (C)
void *_djehuty_unix_thread_proc(void* udata)
{
	Thread t_info = cast(Thread)(udata);
	ThreadPlatformVars* threadVars = ThreadGetPlatformVars(t_info);

	t_info.run();

	threadVars.id = 0;

	ThreadUninit(t_info);

	pthread_exit(null);

	return null;
}


void ThreadStart(ref ThreadPlatformVars threadVars, ref Thread thread)
{
	int ret = pthread_create(&threadVars.id, null, &_djehuty_unix_thread_proc, cast(void *)thread);
	if (ret)
	{
		// error creating thread
		threadVars.id = 0;
	}
}

void ThreadStop(ref ThreadPlatformVars threadVars)
{
	if (threadVars.id)
	{
		if (threadVars.id == pthread_self())
		{
			//soft exit
			printf("thread - soft kill\n");
			threadVars.id = 0;
			pthread_exit(null);
		}
		else
		{
			//hard exit
			printf("thread - hard kill\n");
			pthread_kill(threadVars.id, SIGKILL);
		}

		threadVars.id = 0;
	}
}

void ThreadSleep(ref ThreadPlatformVars threadVars, ulong milliseconds)
{
	timespec timetoexpire;

	timetoexpire.tv_sec = (milliseconds / 1000);
	timetoexpire.tv_nsec = (milliseconds % 1000) * 1000000;

	nanosleep(&timetoexpire, null);
}

bool ThreadIsCurrent(ref ThreadPlatformVars threadVars)
{
	return false;
}



*/








// Semaphores

void SemaphoreInit(ref SemaphorePlatformVars semVars, ref uint initialValue)
{
	sem_init(&semVars.sem_id, 0, initialValue);
}

void SemaphoreUninit(ref SemaphorePlatformVars semVars)
{
	sem_destroy(&semVars.sem_id);
}

void SemaphoreUp(ref SemaphorePlatformVars semVars)
{
	sem_post(&semVars.sem_id);
}

void SemaphoreDown(ref SemaphorePlatformVars semVars, uint ms)
{
	// TODO: semaphore timeout
	sem_wait(&semVars.sem_id);
}

void SemaphoreDown(ref SemaphorePlatformVars semVars)
{
	sem_wait(&semVars.sem_id);
}





// Mutexes

void MutexInit(ref MutexPlatformVars mutVars)
{
}

void MutexUninit(ref MutexPlatformVars mutVars)
{
}

void MutexLock(ref MutexPlatformVars mutVars)
{
}

void MutexLock(ref MutexPlatformVars mutVars, ref uint ms)
{
}

void MutexUnlock(ref MutexPlatformVars mutVars)
{
}
