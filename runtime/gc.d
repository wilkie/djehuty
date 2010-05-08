/*
 * gc.d
 *
 * This module implements the D runtime functions for interfacing the
 * garbage collector.
 *
 */

module runtime.gc;

extern(C):
void* gc_malloc(size_t len, uint bits = 0);
void gc_free(void* ptr);

/*
void gc_init() {
}

void gc_term() {
}

void gc_enable() {
}

void gc_disable() {
}

void gc_collect() {
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
	return null;
}

void* gc_calloc(size_t sz, uint ba = 0) {
	return null;
}

void* gc_realloc(void* p, size_t sz, uint ba = 0) {
	return null;
}

size_t gc_extend(void* p, size_t mx, size_t sz) {
	return 0;
}

void gc_free(void* p) {
}

size_t gc_sizeOf(void* p) {
	return 0;
}

void gc_addRoot(void* p) {
}

void gc_addRange(void* p, size_t sz) {
}

void gc_removeRoot(void* p) {
}

void gc_removeRange(void* p) {
}

bool onCollectResource(Object obj) {
	return false;
}//*/
