import djehuty;

import tui.widget;

import synch.timer;
import synch.semaphore;

import io.console;

import tetris;

class GameControl : TuiWidget {

	enum Event {
		ScoreUpdated,
	}

	this() {
		super(20,0,40,80);

		board = new Tetris();
		lock = new Semaphore(1);

		tmr = new Timer(250);
		push(tmr);
		tmr.start();
	}

	override void onInit() {
	}

	override void onDraw() {
		// draw board
		drawBoard();

		// draw current piece
		drawPiece();
	}

	override void onKeyDown(Key key) {
		if (key.code == Key.Down || key.code == Key.J) {
			tmr.stop();
			timerProc();
			tmr.start();
		}
		else if (key.code == Key.Left || key.code == Key.H) {
			if (board.moveLeft()) {
				lock.down();
				clearPiece();
				drawPiece();
				lock.up();
			}
		}
		else if (key.code == Key.Right || key.code == Key.L) {
			if (board.moveRight()) {
				lock.down();
				clearPiece();
				drawPiece();
				lock.up();
			}
		}
		else if (key.code == Key.Up || key.code == Key.K) {
			if (board.rotate()) {
				lock.down();
				clearPiece();
				drawPiece();
				lock.up();
			}
		}
		else if (key.code == Key.Space) {
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

	bool onSignal(Dispatcher dsp, uint signal) {
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
				Console.position(0, (j*2) + o);
				for (uint i; i < 10; i++) {
					if (clr != board[i,j]) {
						clr = board[i,j];

						Console.setColor(cast(bgColor)clr);
					}

					Console.put("    ");
				}
				Console.putln("");
			}
		}
	}

	void drawPiece() {
		lastPiece = new Coord[](4);

		Console.setColor(cast(bgColor)(board.getPieceType() + 1));

		foreach(i, pt; board.getPiece()) {
			Coord curPt;
			lastPiece[i].x = (board.getPosition().x + pt.x) * 4;
			lastPiece[i].y = (board.getPosition().y + pt.y) * 2;
		}

		foreach(pt; lastPiece) {
			if (pt.x >= 0 && pt.y >= 0 && pt.x < 40 && pt.y < 40) {
				Console.position(pt.x, pt.y);
				Console.put("    ");
				Console.position(pt.x, pt.y + 1);
				Console.put("    ");
			}
		}

		Console.setColor(fgColor.White);
	}

	void clearPiece() {
		Console.setColor(fgColor.Blue, bgColor.Black);
		foreach(pt; lastPiece) {
			if (pt.x >= 0 && pt.y >= 0 && pt.x < 40 && pt.y < 40) {
				Console.position(pt.x, pt.y);
				Console.put("    ");
				Console.position(pt.x, pt.y + 1);
				Console.put("    ");
			}
		}
		Console.setColor(fgColor.White);
	}
	
	override bool isTabStop() {
		return true;
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
