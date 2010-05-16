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
import io.console;

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
		// TODO: Should be an atomic exchange with null, and if it fails then 
		// proceed to use that object.
		*(cast(Monitor**)h + 1) = monitor;
	}
	Console.putln("down");
	monitor.semaphore.down();
}

void _d_monitorexit(Object h) {
	Monitor* monitor = *(cast(Monitor**)h + 1);
	Console.putln("up");
	monitor.semaphore.up();
}

void _d_criticalenter(void* dcs) {
}

void _d_criticalexit(void* dcs) {
}
