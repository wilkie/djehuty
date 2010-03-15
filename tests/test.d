module test.foo;

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
	}

	~this() {
	}

	this(int a, int b) {
	}

	interface FooBarInterface {
	}
}
