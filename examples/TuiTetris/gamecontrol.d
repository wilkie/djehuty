import djehuty;

import tui.core;
import synch.timer;
import synch.semaphore;
import console.main;

import tetris;

class GameControl : TuiWidget {

	enum Event {
		ScoreUpdated,
	}

	this() {
		super(20,0,16,20);

		board = new Tetris();
		lock = new Semaphore(1);

		tmr = new Timer(250);
		push(tmr);
		tmr.start();
	}

	override void OnInit() {
		// draw board
		drawBoard();

		// draw current piece
		drawPiece();
	}

	void OnKeyDown(uint keyCode) {
		if (keyCode == KeyArrowDown) {
			tmr.stop();
			timerProc();
			tmr.start();
		}
		else if (keyCode == KeyArrowLeft) {
			if (board.moveLeft()) {
				lock.down();
				clearPiece();
				drawPiece();
				lock.up();
			}
		}
		else if (keyCode == KeyArrowRight) {
			if (board.moveRight()) {
				lock.down();
				clearPiece();
				drawPiece();
				lock.up();
			}
		}
		else if (keyCode == KeyArrowUp) {
			if (board.rotate()) {
				lock.down();
				clearPiece();
				drawPiece();
				lock.up();
			}
		}
		else if (keyCode == KeySpace) {
			tmr.stop();

			lock.down();

			int result = 1;
			while(result == 1) {
				result = board.moveDown();

				if (result > 0) {
					clearPiece();
				}
				else if (result == -1) {
					// cleared rows
					raiseSignal(Event.ScoreUpdated);
					drawBoard();
				}
				drawPiece();
			}

			lock.up();

			tmr.start();
		}
	}
	
	bool OnSignal(Dispatcher dsp, uint signal) {
		if (dsp is tmr) {
			timerProc();
		}
		return true;
	}
	
	int getScore() {
		return board.getScore();
	}

	void drawBoard() {
		int clr = -1;

		for(uint j; j < 20; j++) {
			for(uint o; o < 2; o++) {
				Console.setPosition(_x, _y + (j*2) + o);
				for (uint i; i < 10; i++) {
					if (clr != board[i,j]) {
						clr = board[i,j];

						Console.setColor(cast(fgColor)clr);
					}

					Console.put("\u2592\u2592\u2592\u2592");
				}
				Console.putln("");
			}
		}
	}

	void drawPiece() {
		Console.setColor(cast(fgColor)(board.getPieceType() + 1));

		lastPiece = new Coord[](4);

		Console.setColor(cast(fgColor)(board.getPieceType() + 1));

		foreach(i, pt; board.getPiece()) {
			Coord curPt;
			lastPiece[i].x = (board.getPosition().x + pt.x) * 4;
			lastPiece[i].y = (board.getPosition().y + pt.y) * 2;
		}

		foreach(pt; lastPiece) {
			if (pt.x >= 0 && pt.y >= 0 && pt.x < 40 && pt.y < 40) {
				Console.setPosition(_x + pt.x, _y + pt.y);
				Console.put("\u2592\u2592\u2592\u2592");
				Console.setPosition(_x + pt.x, _y + pt.y + 1);
				Console.put("\u2592\u2592\u2592\u2592");
			}
		}

		Console.setColor(fgColor.White);
	}

	void clearPiece() {
		Console.setColor(fgColor.Black);
		foreach(pt; lastPiece) {
			if (pt.x >= 0 && pt.y >= 0 && pt.x < 40 && pt.y < 40) {
				Console.setPosition(_x + pt.x, _y + pt.y);
				Console.put("\u2592\u2592\u2592\u2592");
				Console.setPosition(_x + pt.x, _y + pt.y + 1);
				Console.put("\u2592\u2592\u2592\u2592");
			}
		}
		Console.setColor(fgColor.White);
	}

protected:

	void timerProc() {
		lock.down();
		int result = board.moveDown();

		if (result > 0) {
			clearPiece();
		}
		else if (result == -1) {
			// cleared rows
			raiseSignal(Event.ScoreUpdated);
			drawBoard();
		}
		drawPiece();
		lock.up();
	}

	Semaphore lock;

	Tetris board;
	Timer tmr;

	Coord[] lastPiece;

}
