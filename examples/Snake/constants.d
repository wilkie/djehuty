import io.console;

enum FrameWait : uint {
	Init       = 1000,
	Min        = 300,
	Multiplier = 100,
	Step       = 1,
}

enum Growth : uint {
	Min = 10,
	Max = 50,
}

enum SpeedCoef : uint {
	H = 2,
	V = 3,
}

enum Tile : dchar {
	Head   = '@',
	Block  = '#',
	Food   = '*',
	Portal = '^',
	Void   = ' ',
}

enum TileColor : fgColor {
	Head   = fgColor.BrightBlue,
	Block  = fgColor.BrightCyan,
	Food   = fgColor.BrightGreen,
	Portal = fgColor.BrightRed,
}

