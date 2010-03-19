module test.foo;

pragma(msg);

int b[][][][][];
int ((((q))))[][];
int a;

enum FooEnum;
enum FooBar {
	Member1,
	Member2,
}

struct FooStruct {
	struct FooInnerStruct {
	}
}

version(FooBarDeluxe) {
}

version = ReleaseFoo;

debug(FooFooBunny) {
}

debug(FooFooBunnyEars):

debug {
}

debug:

unittest {
}

class FooClass {
	this(...) {
		for ( ; 2+3*5 ; ) {
		}
	}

	~this() {
	}

	this(int a, int b) {
		switch(5) {
			case 6:
				break;
			case 7:
				break foo;
			default:
				continue;
		}
	}

	interface FooBarInterface {
	}
}
