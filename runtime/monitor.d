/*
 * monitor.d
 *
 * This module implements the logic to lock objects using the synchronized
 * keyword.
 *
 * Originated: May 8th, 2010
 *
 */

module runtime.monitor;

import runtime.gc;

import synch.mutex;
import synch.thread;
import synch.atomic;

import io.console;

extern(C):

struct Monitor {
	Mutex lock;
	Thread owner;
	ulong count;
}

void _d_monitorenter(Object h) {
	// The monitor object is the second pointer in the object
	Monitor* monitor = *(cast(Monitor**)h + 1);
	if (monitor is null) {
		monitor = new Monitor;
		monitor.lock = new Mutex();
	}

	monitor.lock.lock();
}

void _d_monitorexit(Object h) {
	Monitor* monitor = *(cast(Monitor**)h + 1);
	if (monitor !is null) {
		monitor.lock.unlock();
	}
}

void _d_criticalenter(void* dcs) {
}

void _d_criticalexit(void* dcs) {
}
