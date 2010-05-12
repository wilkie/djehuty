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

extern(C):

void _d_monitorenter(Object h) {
}

void _d_monitorexit(Object h) {
}

void _d_criticalenter(void* dcs) {
}

void _d_criticalexit(void* dcs) {
}
