enum Dir : int {
	Up    = -1,
	Down  = +1,
	Left  = -2,
	Right = +2,
}

class Posn {
	this(int x_n, int y_n) {
		x = x_n;
		y = y_n;
	}

	Posn dup() {
		return new Posn(_x, _y);
	}

	static void SetBounds(uint max_x_n, uint max_y_n) {
		_max_x = max_x_n;
		_max_y = max_y_n;
	}

	void x(int x_n) {
		if (x_n < 0) {
			_x = _max_x;
		} else if (x_n > _max_x) {
			_x = 0;
		} else {
			_x = x_n;
		}
	}

	uint x() {
		return _x;
	}

	void y(int y_n) {
		if (y_n < 0) {
			_y = _max_y;
		} else if (y_n > _max_y) {
			_y = 0;
		} else {
			_y = y_n;
		}
	}

	uint y() {
		return _y;
	}

	void moveTo(Posn p) {
		x = p.x;
		y = p.y;
	}

	int opEquals(Posn p) {
		return cast(int)(x == p.x && y == p.y);
	}

private:
	static uint _max_x, _max_y;

	uint _x, _y;
}

