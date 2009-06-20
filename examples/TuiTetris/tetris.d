import djehuty;

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