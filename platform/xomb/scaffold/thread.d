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

import platform.vars.thread;
import platform.vars.condition;
import platform.vars.mutex;
import platform.vars.semaphore;

void ThreadYield() {
}

void ThreadSleep(ulong milliseconds) {
}

uint ThreadStart(ref ThreadPlatformVars threadVars, ref Thread thread, void delegate() endCallback) {
	return 0;
}

void ThreadStop(ref ThreadPlatformVars threadVars) {
}

uint ThreadIdentifier() {
	return 0;
}

bool ThreadIsCurrent(ref ThreadPlatformVars threadVars) {
	return false;
}


// Semaphores

void SemaphoreInit(ref SemaphorePlatformVars semVars, ref uint initialValue) {
}

void SemaphoreUninit(ref SemaphorePlatformVars semVars) {
}

void SemaphoreUp(ref SemaphorePlatformVars semVars) {
}

void SemaphoreDown(ref SemaphorePlatformVars semVars, uint ms) {
}

void SemaphoreDown(ref SemaphorePlatformVars semVars) {
}

bool SemaphoreTry(ref SemaphorePlatformVars semVars) {
	return false;
}




// Mutexes

void MutexInit(ref MutexPlatformVars mutVars) {
}

void MutexUninit(ref MutexPlatformVars mutVars) {
}

void MutexLock(ref MutexPlatformVars mutVars) {
}

void MutexLock(ref MutexPlatformVars mutVars, ref uint ms) {
}

void MutexUnlock(ref MutexPlatformVars mutVars) {
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
}
