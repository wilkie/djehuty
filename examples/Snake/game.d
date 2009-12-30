import djehuty;

import io.console;

import constants;
import posn;
import snake;
import win;

enum DeathBy {
	NotDead,
	CollisionSelf,
	CollisionPortal,
	CollisionReverse,
	Quit,
}

class SnakeGame {
	this(SnakeWindow win_n) {
		_win = win_n;

		_max_x = _win.width - 1;
		_max_y = _win.height - 1;

		_rand = new Random();

		Dir d = cast(Dir)_rand.choose([Dir.Up, Dir.Down, Dir.Left, Dir.Right]);
		_snake = new Snake(_max_x, _max_y, d);
	}

	void turn(Dir d) {
		if (_snake.direction == -d) {
			_snake.reverse();
			_rev = true;
		}
		_snake.direction = d;
	}

	Snake snake() {
		return _snake.dup;
	}

	void frame() {
		if (_snake is null || _win is null)
			return;

		Posn oldTail = _snake.tail.dup;

		MoveResult move = _snake.slither();

		if (_snake.length > 1) {
			drawTile(_snake.neck, Tile.Block, TileColor.Block);
		}

		if (_snake.length <= 1 || _snake.tail != oldTail) {
			drawTile(oldTail, Tile.Void);
		}

		drawTile(_snake.head, Tile.Head, TileColor.Head);

		if (move == MoveResult.CollisionSelf) {
			if (_rev) {
				_win.gameOver(DeathBy.CollisionReverse);
			} else {
				_win.gameOver(DeathBy.CollisionSelf);
			}
			return;
		} else if (_portal !is null && _portal == _snake.head) {
			_win.gameOver(DeathBy.CollisionPortal);
			return;
		} else if (_food !is null && _food == _snake.head) {
			_snake.head.moveTo(_portal);

			drawTile(_food, Tile.Void);

			_food = null;
			_portal = null;

			_snake.elongate(cast(uint)_rand.next(Growth.Min, Growth.Max));
		}

		if (_food is null) {
			_food = positionItem();
			drawTile(_food, Tile.Food, TileColor.Food);
		}
		if (_portal is null) {
			_portal = positionItem();
			drawTile(_portal, Tile.Portal, TileColor.Portal);
		}

		_rev = false;

		_win.setSpeed();
	}

private:
	void drawTile(Posn p, Tile t) {
		Console.position(p.x, p.y);
		Console.putChar(t);
	}

	void drawTile(Posn p, Tile t, TileColor c) {
		Console.setColor(c);
		drawTile(p, t);
	}

	Posn positionItem() {
		Posn ret;
		while (ret is null) {
			auto r = new Posn(cast(uint)_rand.next(_max_x + 1), cast(uint)_rand.next(_max_y + 1));
			if (_snake !is null && _snake == r)
				continue;
			if (_food !is null && _food == r)
				continue;
			if (_portal !is null && _portal == r)
				continue;
			ret = r;
		}
		return ret;
	}

	uint _max_x, _max_y;

	bool _rev;

	SnakeWindow _win;
	Random _rand;

	Snake _snake;
	Posn _food, _portal;
}

