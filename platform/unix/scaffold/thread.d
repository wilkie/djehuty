/*
 * thread.d
 *
 * This Scaffold holds the Thread implementations for the Linux platform
 *
 * Author: Dave Wilkinson
 *
 */

module scaffold.thread;

import core.string;
import core.color;
import core.main;
import core.definitions;
import core.string;

import synch.thread;

import platform.unix.common;

import platform.vars.thread;
import platform.vars.condition;
import platform.vars.mutex;
import platform.vars.semaphore;

import binding.c;

void ThreadYield() {
	pthread_yield();
}

void ThreadSleep(ulong milliseconds) {
	timespec timetoexpire;

	timetoexpire.tv_sec = (milliseconds / 1000);
	timetoexpire.tv_nsec = (milliseconds % 1000) * 1000000;

	timespec remaining;

	while(nanosleep(&timetoexpire, &remaining) != 0) {
		timetoexpire = remaining;
	}
}

extern (C)
void *_djehuty_unix_thread_proc(void* udata) {
	ThreadPlatformVars* threadVars = cast(ThreadPlatformVars*)(udata);
	Thread t_info = threadVars.thread;

	t_info.run();

	threadVars.endCallback();
	return null;
}

long ThreadStart(ref ThreadPlatformVars threadVars, ref Thread thread, void delegate() endCallback) {
	threadVars.thread = thread;
	threadVars.endCallback = endCallback;

	int ret = pthread_create(&threadVars.id, null, &_djehuty_unix_thread_proc, &threadVars);

	if (ret) {
		// error creating thread
		threadVars.id = 0;
	}

	return threadVars.id;
}

void ThreadStop(ref ThreadPlatformVars threadVars) {
	if (threadVars.id) {
		if (threadVars.id == pthread_self()) {
			//soft exit
			//printf("thread - soft kill\n");
			threadVars.id = 0;
			pthread_exit(null);
		}
		else {
			//hard exit
			//printf("thread - hard kill\n");
			pthread_kill(threadVars.id, SIGKILL);
		}

		threadVars.id = 0;
	}
}

uint ThreadIdentifier() {
	return pthread_self();
}

bool ThreadIsCurrent(ref ThreadPlatformVars threadVars) {
	return false;
}


// Semaphores

void SemaphoreInit(ref SemaphorePlatformVars semVars, ref uint initialValue) {
	sem_init(&semVars.sem_id, 0, initialValue);
}

void SemaphoreUninit(ref SemaphorePlatformVars semVars) {
	sem_destroy(&semVars.sem_id);
}

void SemaphoreUp(ref SemaphorePlatformVars semVars) {
	sem_post(&semVars.sem_id);
}

void SemaphoreDown(ref SemaphorePlatformVars semVars, uint ms) {
	// TODO: semaphore timeout
	sem_wait(&semVars.sem_id);
}

void SemaphoreDown(ref SemaphorePlatformVars semVars) {
	sem_wait(&semVars.sem_id);
}

bool SemaphoreTry(ref SemaphorePlatformVars semVars) {
	return (sem_trywait(&semVars.sem_id) == 0);
}




// Mutexes

void MutexInit(ref MutexPlatformVars mutVars) {
	pthread_mutex_init(&mutVars.mut_id, null);
}

void MutexUninit(ref MutexPlatformVars mutVars) {
	pthread_mutex_destroy(&mutVars.mut_id);
}

void MutexLock(ref MutexPlatformVars mutVars) {
	pthread_mutex_lock(&mutVars.mut_id);
}

void MutexLock(ref MutexPlatformVars mutVars, ref uint ms) {
}

void MutexUnlock(ref MutexPlatformVars mutVars) {
	pthread_mutex_unlock(&mutVars.mut_id);
}

void ConditionInit(ref ConditionPlatformVars condVars) {
}

void ConditionSignal(ref ConditionPlatformVars condVars) {
}

void ConditionWait(ref ConditionPlatformVars condVars) {
}

void ConditionWait(ref ConditionPlatformVars condVars, ref MutexPlatformVars mutVars) {
}

void ConditionUninit(ref ConditionPlatformVars condVars) {
	pthread_cond_destroy(&condVars.cond_id);
}
