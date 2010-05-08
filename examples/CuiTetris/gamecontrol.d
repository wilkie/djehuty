import djehuty;

import cui.widget;

import synch.timer;
import synch.semaphore;

import io.console;

import tetris;

class GameControl : CuiWidget {

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
			if (inited) {
				timerProc();
			} else {
				inited = true;
			}
		}
		return true;
	}

	int getScore() {
		return board.getScore();
	}

	void drawBoard() {
		synchronized(this) {
			int clr = -1;

			for(uint j; j < 20; j++) {
				for(uint o; o < 2; o++) {
					for (uint i; i < 10; i++) {
						if (clr != board[i,j]) {
							clr = board[i,j];

							Console.backcolor = colors[clr];
						}

						Console.putAt(i*4, (j*2) + o, "    ");
					}
				}
			}
		}
	}

	static Color colors[] = [
		Color.Black,
		Color.Red,
		Color.Blue,
		Color.Green,
		Color.Yellow,
		Color.Magenta,
		Color.Cyan,
		Color.White
	];

	void drawPiece() {
		synchronized(this) {
			lastPiece = new Coord[](4);
			Console.backcolor = colors[board.getPieceType() + 1];

			foreach(i, pt; board.getPiece()) {
				Coord curPt;
				lastPiece[i].x = (board.getPosition().x + pt.x) * 4;
				lastPiece[i].y = (board.getPosition().y + pt.y) * 2;
			}
	
			foreach(pt; lastPiece) {
				if (pt.x >= 0 && pt.y >= 0 && pt.x < 40 && pt.y < 40) {
					//Console.position(pt.x, pt.y);
					Console.putAt(pt.x, pt.y, "    ");
					//Console.position(pt.x, pt.y + 1);
					Console.putAt(pt.x, pt.y + 1, "    ");
				}
			}
	
			Console.forecolor = Color.Gray;
		}
	}

	void clearPiece() {
		synchronized(this) {
			Console.forecolor = Color.Blue;
			Console.backcolor = Color.Black;
			foreach(pt; lastPiece) {
				if (pt.x >= 0 && pt.y >= 0 && pt.x < 40 && pt.y < 40) {
					//Console.position(pt.x, pt.y);
					Console.putAt(pt.x, pt.y, "    ");
					//Console.position(pt.x, pt.y + 1);
					Console.putAt(pt.x, pt.y + 1, "    ");
				}
			}
			Console.forecolor = Color.Gray;
		}
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

	bool inited;

	Semaphore lock;

	Tetris board;
	Timer tmr;

	Coord[] lastPiece;

}
