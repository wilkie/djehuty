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
			case 4:
				goto default;
				goto case 3;
				goto foo;
			case 6:
				break;
			case 7:
				break foo;
			default:
				continue;
		}
		return 4;
		return;
		volatile;
		volatile switch(3) { case 4: }
	}

	interface FooBarInterface {
	}
}
