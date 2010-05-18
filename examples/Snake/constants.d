import io.console;
import core.color;

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

struct TileColor {
	alias Color.Blue Head;
	alias Color.Cyan Block;
	alias Color.Green Food;
	alias Color.Red Portal;
//	static Color Head = Color.Blue;
//	static Color Block = Color.Cyan;
//	static Color Food = Color.Green;
//	static Color Portal = Color.Red;
}

