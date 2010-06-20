/*
 * thread.d
 *
 * This file implements the Scaffold for platform specific Thread
 * operations in Windows.
 *
 * Author: Dave Wilkinson
 *
 */

module scaffold.thread;

import core.main;
import core.definitions;
import core.string;

import synch.thread;

import platform.win.main;

import binding.win32.windef;
import binding.win32.winuser;
import binding.win32.winnt;
import binding.win32.winbase;

import platform.vars.mutex;
import platform.vars.semaphore;
import platform.vars.thread;
import platform.vars.condition;

extern(Windows)
DWORD _win_djehuty_thread_proc(void* udata)
{
	ThreadPlatformVars* threadVars = cast(ThreadPlatformVars*)udata;
	Thread t = threadVars.thread;

	t.run();

	threadVars.thread = null;

	return 0;
}

uint ThreadStart(ref ThreadPlatformVars threadVars, ref Thread thread, void delegate() endCallback)
{
	threadVars.threadHnd = CreateThread(null, 0, &_win_djehuty_thread_proc, cast(void*)&threadVars, 0, &threadVars.id);
	return threadVars.id;
}

void ThreadStop(ref ThreadPlatformVars threadVars)
{
	if (threadVars.id == GetCurrentThreadId())
	{ // soft exit if called from the created thread
		ExitThread(0);
	}
	else
	{ // hard exit if called from another thread
		TerminateThread(threadVars.threadHnd, 0);
	}

	threadVars.threadHnd = null;
	threadVars.id = 0;
}

void ThreadSleep(ulong milliseconds) {
	while (milliseconds > 0xFFFFFFFF) {
		.Sleep(0xFFFFFFFF);

		milliseconds -= 0xFFFFFFFF;
	}
	.Sleep(cast(uint)milliseconds);
}

void ThreadYield() {
}

uint ThreadIdentifier() {
	return 0;
}

//bool ThreadIsCurrent(ref ThreadPlatformVars threadVars)
//{
//	return threadVars.thread_id == GetCurrentThreadId();
//}












// Semaphores

void SemaphoreInit(ref SemaphorePlatformVars semVars, ref uint initialValue) {
	semVars._semaphore = CreateSemaphoreA(null, (initialValue), 0xFFFFFFF, null);
}

void SemaphoreUninit(ref SemaphorePlatformVars semVars) {
	CloseHandle(semVars._semaphore);
}

void SemaphoreUp(ref SemaphorePlatformVars semVars) {
	ReleaseSemaphore(semVars._semaphore, 1, null);
}

void SemaphoreDown(ref SemaphorePlatformVars semVars, uint ms) {
	WaitForSingleObject(semVars._semaphore, ms);
}

void SemaphoreDown(ref SemaphorePlatformVars semVars) {
	WaitForSingleObject(semVars._semaphore, INFINITE);
}

bool SemaphoreTry(ref SemaphorePlatformVars semVars) {
	return false;
}




// Mutexes

void MutexInit(ref MutexPlatformVars mutVars) {
//	InitializeCriticalSection(mutVars._mutex);
	mutVars._semaphore = CreateSemaphoreA(null, (1), 0xFFFFFFF, null);
}

void MutexUninit(ref MutexPlatformVars mutVars) {
	//DeleteCriticalSection(mutVars._mutex);
	CloseHandle(mutVars._semaphore);
}

void MutexLock(ref MutexPlatformVars mutVars) {
//	EnterCriticalSection(mutVars._mutex);
	WaitForSingleObject(mutVars._semaphore, INFINITE);
}

void MutexLock(ref MutexPlatformVars mutVars, ref uint ms) {
	// XXX: Use TryEnterCriticalSection in a timed loop here
	//EnterCriticalSection(mutVars._mutex);
	WaitForSingleObject(mutVars._semaphore, ms);
}

void MutexUnlock(ref MutexPlatformVars mutVars) {
	//LeaveCriticalSection(mutVars._mutex);
	ReleaseSemaphore(mutVars._semaphore, 1, null);
}


// Conditions

void ConditionInit(ref ConditionPlatformVars condVars) {
}

void ConditionSignal(ref ConditionPlatformVars condVars) {
}

void ConditionWait(ref ConditionPlatformVars condVars) {
}

void ConditionWait(ref ConditionPlatformVars condVars, ref MutexPlatformVars mutVars) {
}

void ConditionUninit(ref ConditionPlatformVars condVars) {
}