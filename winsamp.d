import packages.console;
import packages.synch;
import packages.core;

class TermTetris : ConsoleApplication {

	// Start an application instance
	static this() { new TermTetris(); }

	override void OnApplicationStart() {
		Console.hideCaret();
		setConsoleWindow(new GameWindow());
	}
}

class GameControl : ConsoleControl {

	enum Event {
		ScoreUpdated,
	}

	this(void delegate(GameControl, Event) eventProc = null) {
		super(20,0,16,20);

		board = new Tetris();
		lock = new Semaphore(1);

		tmr = new Timer(250);
		tmr.setDelegate(&timerProc);
		tmr.start();

		this.eventProc = eventProc;
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
			timerProc(tmr);
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
					if (eventProc) {
						eventProc(this, Event.ScoreUpdated);
					}

					drawBoard();
				}
				drawPiece();
			}

			lock.up();

			tmr.start();
		}
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

					Console.put("\u2588\u2588\u2588\u2588");
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
				Console.put("\u2588\u2588\u2588\u2588");
				Console.setPosition(_x + pt.x, _y + pt.y + 1);
				Console.put("\u2588\u2588\u2588\u2588");
			}
		}

		Console.setColor(fgColor.White);
	}

	void clearPiece() {
		Console.setColor(fgColor.Black);
		foreach(pt; lastPiece) {
			if (pt.x >= 0 && pt.y >= 0 && pt.x < 40 && pt.y < 40) {
				Console.setPosition(_x + pt.x, _y + pt.y);
				Console.put("\u2588\u2588\u2588\u2588");
				Console.setPosition(_x + pt.x, _y + pt.y + 1);
				Console.put("\u2588\u2588\u2588\u2588");
			}
		}
		Console.setColor(fgColor.White);
	}

protected:

	bool timerProc(Timer tmr) {
		lock.down();
		int result = board.moveDown();

		if (result > 0) {
			clearPiece();
		}
		else if (result == -1) {
			// cleared rows
			if (eventProc) {
				eventProc(this, Event.ScoreUpdated);
			}
			drawBoard();
		}
		drawPiece();
		lock.up();
		return true;
	}

	Semaphore lock;

	Tetris board;
	Timer tmr;

	Coord[] lastPiece;
	
	void delegate(GameControl, Event) eventProc;
}

class Tetris {

	this() {
		rnd = new Random();

		nextPiece();
		clearBoard();
	}

	void clearBoard() {
		board = new int[][](10,20);
	}

	void setBlock(int x, int y, int clr) {
		board[x][y] = clr;
	}

	int opIndex(size_t i, size_t j) {
		return board[i][j];
	}

	int opIndexAssign(int value, size_t i, size_t j) {
		return board[i][j] = value;
	}

	int getPieceType() {
		return currentPiece;
	}

	int getDirection() {
		return currentDirection;
	}

	Coord[] getPiece() {
		return pieces[currentPiece][currentDirection];
	}
	
	Coord getPosition() {
		return currentPos;
	}
	
	int moveDown() {
		if (canMoveDown()) {
			currentPos.y++;
			return 1;
		}

		// cannot move down, so the piece is in place
		int ret = 0;

		if (plantPiece()) {
			ret = -1;
		}

		nextPiece();

		return ret;
	}

	bool moveLeft() {
		if (canMoveLeft()) {
			currentPos.x--;
			return true;
		}
		return false;
	}
	
	bool moveRight() {
		if (canMoveRight()) {
			currentPos.x++;
			return true;
		}
		return false;
	}
	
	bool rotate() {
		if (canRotate()) {
			currentDirection = (currentDirection+1) % 4;
			return true;
		}
		return false;
	}
	
	int getScore() {
		return score;
	}

protected:

	void nextPiece() {
		currentPiece = cast(int)rnd.next(7);
		currentPos.x = 5;
		currentPos.y = 0;
	}

	bool plantPiece() {
		bool ret = false;

		int[] rows;

		foreach(pt; pieces[currentPiece][currentDirection]) {
			if (currentPos.x + pt.x >= 0 && currentPos.y + pt.y >= 0) {
				if (currentPos.x + pt.x < 10 && currentPos.y + pt.y < 20) {
					board[currentPos.x + pt.x][currentPos.y + pt.y] = currentPiece + 1;

					rows ~= (currentPos.y + pt.y);
				}
			}
		}
		
		if (rows !is null) {
			// look at rows from top to bottom
			rows.sort;
			
			int rowsCleared;

			foreach(row; rows) {
				// check row
				if (rowFilled(row)) {
					// clear row
					clearRow(row);
					// move the piece to be added down as well
					ret = true;
					// one more row cleared!
					rowsCleared++;
					// add score
					score += rowsCleared*100;
				}
			}
		}

		return ret;
	}

	bool canRotate() {
		int nextDirection = currentDirection + 1;
		nextDirection %= 4;

		foreach(pt; pieces[currentPiece][nextDirection]) {
			if (currentPos.x + pt.x >= 0 && currentPos.y + pt.y >= 0 &&
				currentPos.x + pt.x < 10 && currentPos.y + pt.y < 20) {
				if (board[currentPos.x + pt.x][currentPos.y + pt.y] != 0) {
					return false;
				}
			}
			else {
				return false;
			}
		}

		return true;
	}

	bool canMoveDown() {
		foreach(pt; pieces[currentPiece][currentDirection]) {
			if (currentPos.x + pt.x >= 0 && currentPos.y + pt.y + 1 >= 0) {
				if (currentPos.x + pt.x < 10 && currentPos.y + pt.y + 1 < 20) {
					if (board[currentPos.x + pt.x][currentPos.y + pt.y + 1] != 0) {
						return false;
					}
				}
				else {
					return false;
				}
			}
		}

		return true;
	}

	bool canMoveLeft() {
		foreach(pt; pieces[currentPiece][currentDirection]) {
			if (currentPos.x + pt.x - 1 < 0) {
				return false;
			}

			if (currentPos.x + pt.x - 1 >= 0 && currentPos.y + pt.y >= 0 &&
				currentPos.x + pt.x - 1 < 10 && currentPos.y + pt.y < 20) {
				if (board[currentPos.x + pt.x - 1][currentPos.y + pt.y] != 0) {
					return false;
				}
			}
		}

		return true;
	}

	bool canMoveRight() {
		foreach(pt; pieces[currentPiece][currentDirection]) {
			if (currentPos.x + pt.x + 1 >= 10) {
				return false;
			}

			if (currentPos.x + pt.x + 1 >= 0 && currentPos.y + pt.y >= 0 &&
				currentPos.x + pt.x + 1 < 10 && currentPos.y + pt.y < 20) {
				if (board[currentPos.x + pt.x + 1][currentPos.y + pt.y] != 0) {
					return false;
				}
			}
		}

		return true;
	}
	
	bool rowFilled(int rowIndex) {
		for(int i; i < 10; i++) {
			if (board[i][rowIndex] == 0) {
				// row is NOT filled
				return false;
			}
		}

		return true;
	}
	
	void clearRow(int rowIndex) {
		for (int j = rowIndex; j > 0; j--) {
			for(int i; i < 10; i++) {
				board[i][j] = board[i][j-1];
			}
		}
		for (int i; i < 10; i++) {
			board[i][0] = 0;
		}
	}

	int board[][];
	Random rnd;

	int currentPiece;
	int currentDirection;

	Coord currentPos;
	
	int score;

	static const Coord pieces[][][] =
	[
		[ // I
			[	{ 0, -2}, { 0, -1}, { 0,  0}, { 0,  1}	],
			[	{-2,  0}, {-1,  0}, { 0,  0}, { 1,  0}	],
			[	{ 0, -1}, { 0,  0}, { 0,  1}, { 0,  2}	],
			[	{-1,  0}, { 0,  0}, { 1,  0}, { 2,  0}	],
		],
		[ // O
			[	{ 0,  0}, { 1,  0}, { 0,  1}, { 1,  1}	],
			[	{ 0,  0}, { 1,  0}, { 0,  1}, { 1,  1}	],
			[	{ 0,  0}, { 1,  0}, { 0,  1}, { 1,  1}	],
			[	{ 0,  0}, { 1,  0}, { 0,  1}, { 1,  1}	],
		],
		[ // Z
			[	{-1,  0}, { 0,  0}, { 0,  1}, { 1,  1}	],
			[	{ 0, -1}, { 0,  0}, {-1,  0}, {-1,  1}	],
			[	{-1, -1}, { 0, -1}, { 0,  0}, { 1,  0}	],
			[	{ 0,  0}, { 0,  1}, { 1,  0}, { 1, -1}	],
		],
		[ // S
			[	{-1,  1}, { 0,  0}, { 0,  1}, { 1,  0}	],
			[	{ 0,  1}, { 0,  0}, {-1,  0}, {-1, -1}	],
			[	{-1,  0}, { 0, -1}, { 0,  0}, { 1, -1}	],
			[	{ 0,  0}, { 0, -1}, { 1,  0}, { 1,  1}	],
		],
		[ // L
			[	{ 0,  0}, { 0, -1}, { 0, -2}, { 1,  0}	],
			[	{-2,  0}, {-1,  0}, { 0,  0}, { 0, -1}	],
			[	{-1,  0}, { 0,  0}, { 0,  1}, { 0,  2}	],
			[	{ 0,  0}, { 1,  0}, { 2,  0}, { 0,  1}	],
		],
		[ // J
			[	{ 0,  0}, { 0, -1}, { 0, -2}, {-1,  0}	],
			[	{-2,  0}, {-1,  0}, { 0,  0}, { 0,  1}	],
			[	{ 1,  0}, { 0,  0}, { 0,  1}, { 0,  2}	],
			[	{ 0,  0}, { 1,  0}, { 2,  0}, { 0, -1}	],
		],
		[ // T
			[	{ 0,  0}, {-1,  0}, { 1,  0}, { 0, -1}	],
			[	{ 0,  0}, {-1,  0}, { 0,  1}, { 0, -1}	],
			[	{ 0,  0}, { 0,  1}, {-1,  0}, { 1,  0}	],
			[	{ 0,  0}, { 1,  0}, { 0, -1}, { 0,  1}	],
		],
	];
}

// ------------

class GameWindow : ConsoleWindow {
	this() {
		scoreLabel = new ConsoleLabel(4, 5, 10, "0");

		addControl(scoreLabel);
		addControl(new ConsoleLabel(2, 3, 10, "Score", fgColor.BrightYellow));
		addControl(new GameControl(&OnGameEvent));
	}

	void OnGameEvent(GameControl g, GameControl.Event e) {
		switch(e) {
			default:
			case GameControl.Event.ScoreUpdated:
				scoreLabel.setText(new String(g.getScore()));
				break;
		}
	}

protected:
	ConsoleLabel scoreLabel;
}

