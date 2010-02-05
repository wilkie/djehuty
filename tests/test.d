module test;

import gui.button;

abstract class A {
}

class D : A {
public:
	int foo(string param = "haha", int foobar = 076) {
		if (param == "haha") {
			return 1;
		}
		int d = void;
		int e = 0xff;
		int f = 0x0;
		if (d >= 0b101) {
			return d;
		}
		return 0;
	}

	static string bar = `lol
line
lol`;

	double _foo(char param = '\'') {
		double d = void;
		double e = 0.3e3;
		if (d !>= 0xff.3p3) {
			return d;
		}
		double f = 0.3;
		double g = 0.e1;
		double h = .0e1;
		double i = .3;
		double j = .0;
		double k = .3e2;
		return 1.3;
	}

private:
}