import djehuty;

import posn;

enum MoveResult {
	Ok,
	CollisionSelf,
}

class Snake {
	this(uint max_x, uint max_y, Dir d) {
		Posn.SetBounds(max_x, max_y);

		_max_x = max_x;
		_max_y = max_y;

		direction = d;

		_max_length = max_x * max_y / 2;

		_segments = new List!(Posn);
		_segments.add(new Posn(max_x/2, max_y/2));
	}

	Snake dup() {
		Snake ret = new Snake(_max_x, _max_y, direction);
		ret._segments = _segments.dup;
		return ret;
	}

	void direction(Dir d) {
		_direction = d;
	}

	Dir direction() {
		return _direction;
	}

	Posn[] segments() {
		return _segments.array();
	}

	Posn head() {
		return first(segments);
	}

	Posn neck() {
		return second(segments);
	}

	Posn[] torso() {
		return rest(segments);
	}

	Posn tail() {
		return last(segments);
	}

	bool isVertical() {
		return direction == Dir.Up || direction == Dir.Down;
	}

	uint length() {
		return _segments.length();
	}

	void reverse() {
		_segments = _segments.reverse();
	}

	void elongate(uint num = 1) {
		for (; length < _max_length && num > 0; num--)
			_segments.add(tail.dup());
	}

	int opEquals(Posn p) {
		foreach (Posn s; torso)
			if (s == p)
				return 1;
		return 0;
	}

	MoveResult slither() {
		foreach_reverse (uint i, Posn s; torso)
			s.moveTo(_segments[i]);

		switch (_direction) {
			case Dir.Up:
				head.y = head.y - 1;
				break;
			case Dir.Down:
				head.y = head.y + 1;
				break;
			case Dir.Left:
				head.x = head.x - 1;
				break;
			case Dir.Right:
				head.x = head.x + 1;
				break;
			default:
				break;
		}

		if (this == head)
			return MoveResult.CollisionSelf;

		return MoveResult.Ok;
	}

private:
	uint _max_x, _max_y;
	uint _max_length;

	Dir _direction;

	List!(Posn) _segments;
}

