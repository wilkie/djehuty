/*
 * gc.d
 *
 * This module implements the D runtime functions for interfacing the
 * garbage collector.
 *
 */

module runtime.gc;

import synch.atomic;

import System = scaffold.system;

import binding.c;

extern(C):

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
	//GarbageCollector.getAttr(p);
}

uint gc_setAttr(void* p, uint a) {
	return 0;
	//GarbageCollector.setAttr(p, a);
}

uint gc_clrAttr(void* p, uint a) {
	return 0;
	//GarbageCollector.clearAttr(p, a);
}

void* gc_malloc(size_t sz, uint ba = 0) {
	return GarbageCollector.malloc(sz).ptr;
}

void* gc_calloc(size_t sz, uint ba = 0) {
	return GarbageCollector.calloc(sz).ptr;
}

void* gc_realloc(ubyte* p, size_t sz, uint ba = 0) {
	return GarbageCollector.realloc(p[0..sz], sz).ptr;
}

size_t gc_extend(ubyte* p, size_t mx, size_t sz) {
	return GarbageCollector.extend(p[0..mx], mx, sz);
}

void gc_free(ubyte* p) {
	return GarbageCollector.free(p[0..1]);
}

size_t gc_sizeOf(ubyte* p) {
	return GarbageCollector.sizeOf(p[0..1]);
}

void gc_addRoot(ubyte* p) {
	return GarbageCollector.addRoot(p[0..1]);
}

void gc_addRange(ubyte* p, size_t sz) {
	return GarbageCollector.addRange(p[0..sz]);
}

void gc_removeRoot(ubyte* p) {
	return GarbageCollector.removeRoot(p[0..1]);
}

void gc_removeRange(ubyte* p) {
	return GarbageCollector.removeRange(p[0..1]);
}

// Implementation
struct Pool {
}

class GarbageCollector {
public:
static:

	void enable() {
		Atomic.decrement(_disabled);
	}

	void disable() {
		Atomic.increment(_disabled);
	}

	void minimize() {
	}

	void collect() {
	}

	ubyte[] malloc(size_t length) {
		return System.malloc(length);
	}

	ubyte[] realloc(ubyte[] original, size_t length) {
		return System.realloc(original, length);
	}

	ubyte[] calloc(size_t length) {
		return System.calloc(length);
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
		return null;
	}

	size_t sizeOf(ubyte[] memory) {
		return 0;
	}

	void addRoot(ubyte[] memory) {
	}

	void addRange(ubyte[] range) {
	}

	void removeRoot(ubyte[] memory) {
	}

	void removeRange(ubyte[] range) {
	}

	size_t query(ubyte[] memory) {
		return memory.length;
	}

private:

	void _initialize() {
		printf("GC initialized\n");
		_inited = 1;
	}

	void _terminate() {
		printf("GC terminated\n");
		_inited = 0;
	}

	ulong _disabled;
	bool _inited;
}
