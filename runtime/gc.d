/*
 * gc.d
 *
 * This module implements the D runtime functions for interfacing the
 * garbage collector.
 *
 */

module runtime.gc;

import synch.atomic;

extern(C):

import scaffold.system;

void gc_init() {
	GarbageCollector._initialize();
}

void gc_term() {
	GarbageCollector._terminate();
}

void gc_enable() {
	GarbageCollector.enable();
}

void gc_disable() {
	GarbageCollector.disable();
}

void gc_collect() {
	GarbageCollector.collect();
}

uint gc_getAttr(void* p) {
	return 0;
}

uint gc_setAttr(void* p, uint a) {
	return 0;
}

uint gc_clrAttr(void* p, uint a) {
	return 0;
}

void* gc_malloc(size_t sz, uint ba = 0) {
	return GarbageCollector.malloc(sz).ptr;
}

void* gc_calloc(size_t sz, uint ba = 0) {
	return GarbageCollector.calloc(sz).ptr;
}

void* gc_realloc(void* p, size_t sz, uint ba = 0) {
	return GarbageCollector.realloc(p[0..sz]).ptr;
}

size_t gc_extend(void* p, size_t mx, size_t sz) {
	return GarbageCollector.extend(p[0..mx]);
}

void gc_free(void* p) {
	return GarbageCollector.free(p[0..1]);
}

size_t gc_sizeOf(void* p) {
	return GarbageCollector.sizeOf(p[0..1]);
}

void gc_addRoot(void* p) {
	return GarbageCollector.addRoot(p[0..1]);
}

void gc_addRange(void* p, size_t sz) {
	return GarbageCollector.addRange(p[0..1]);
}

void gc_removeRoot(void* p) {
	return GarbageCollector.removeRoot(p[0..1]);
}

void gc_removeRange(void* p) {
	return GarbageCollector.removeRange(p[0..1]);
}

// Implementation
struct Pool {
}

class GarbageCollector {
public:
static:

	void enable() {
		Atomic.decrement(disabled);
	}

	void disable() {
		Atomic.increment(disabled);
	}

	void minimize() {
	}

	void collect() {
	}

	ubyte[] malloc(size_t length) {
		return null;
	}

	ubyte[] realloc(ubyte[] original, size_t length) {
		return null;
	}

	size_t extend(ubyte[] original, size_t max, size_t size) {
		return 0;
	}

	size_t reserve(size_t length) {
		return 0;
	}

	void free(ubyte[] memory) {
	}

	void* addressOf(ubyte[] memory) {
	}

	size_t sizeOf(ubyte[] memory) {
	}

	void addRoot(ubyte[] memory) {
	}

	void addRange(ubyte[] range) {
	}

	void removeRoot(ubyte[] memory) {
	}

	void removeRange(ubyte[] range) {
	}

private:

	void _initialize() {
		_inited = 1;
	}

	uint _disabled;
	bool _inited;
}
