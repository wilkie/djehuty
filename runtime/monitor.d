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

import synch.semaphore;

extern(C):

struct Monitor {
	Semaphore semaphore;
}

void _d_monitorenter(Object h) {
	// The monitor object is the second pointer in the object
	Monitor* monitor = *(cast(Monitor**)h + 1);
	if (monitor is null) {
		monitor = new Monitor;
		monitor.semaphore = new Semaphore(1);
		*(cast(Monitor**)h + 1) = monitor;
	}
	monitor.semaphore.down();
}

void _d_monitorexit(Object h) {
	Monitor* monitor = *(cast(Monitor**)h + 1);
	monitor.semaphore.up();
}

void _d_criticalenter(void* dcs) {
}

void _d_criticalexit(void* dcs) {
}
