/*
 * eh.d
 *
 * DMD specific exception handling runtime functions. It is bullshit.
 *
 */

extern(System):

import binding.c;

void _d_throw(Object o) {
	printf("EXCEPTION!\n");
	printf("EXCEPTION!\n");
	printf("EXCEPTION!\n");
	printf("EXCEPTION!\n");
	printf("EXCEPTION!\n");
	exit(-1);
}

extern(C):

void _d_local_unwind2() {
}

struct EXCEPTION_DISPOSITION {
}

struct EXCEPTION_RECORD {
}

struct CONTEXT {
}

struct DEstablisherFrame {
}

EXCEPTION_DISPOSITION _d_framehandler(
	    EXCEPTION_RECORD *exception_record,
	    DEstablisherFrame *frame,
	    CONTEXT *context,
	    void *dispatcher_context) {
	EXCEPTION_DISPOSITION ret;
	return ret;
}