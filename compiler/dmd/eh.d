/*
 * eh.d
 *
 * DMD specific exception handling runtime functions. It is bullshit.
 *
 */

extern(System):

void _d_throw(Object o) {
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