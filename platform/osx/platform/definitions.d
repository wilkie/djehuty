module platform.definitions;

version(PlatformOSX) {
	alias char Char;

	import core.parameters;

	static const Parameter_Colorbpp Colorbpp = Parameter_Colorbpp.Color8bpp;
	static const Parameter_ColorType ColorType = Parameter_ColorType.ColorRGBA;

	const auto FontMonospace = "Courier";
	const auto FontTimes = "Times New Roman";
	const auto FontSans = "Sans";
	const auto FontSerif = "Sans Serif";
	const auto FontSystem = "Sans Serif";

	const int  KeyBackspace = 0x8;			//0x08
	const int  KeyTab = 0x9;					//0x09
	const int  KeyReturn = 0xD;				//0x0D
	const int  KeyAmbiShift = 0x10;			//0x10
	const int  KeyAmbiControl = 0x11;		//0x11
	const int  KeyAmbiAlt = 0x12;				//0x12
	const int  KeyPause = 0x13;				//0x13
	const int  KeyCapsLock = 0x14;			//0x14
	const int  KeyEscape = 0x1b;				//0x1B
	const int  KeySpace = 0x20;				//0x20
	const int  KeyPageUp = 0x21;				//0x21
	const int  KeyPageDown = 0x22;				//0x22
	const int  KeyEnd = 0x23;					//0x23
	const int  KeyHome = 0x24;					//0x24
	const int  KeyArrowLeft = 0x25;			//0x25
	const int  KeyArrowUp = 0x26;				//0x26
	const int  KeyArrowRight = 0x27;			//0x27
	const int  KeyArrowDown = 0x28;			//0x28
	const int  KeyInsert = 0x2D;				//0x2D
	const int  KeyDelete = 0x2E;				//0x2E
	const int  Key0 = 0x30;
	const int  Key1 = 0x31;
	const int  Key2 = 0x32;
	const int  Key3 = 0x33;
	const int  Key4 = 0x34;
	const int  Key5 = 0x35;
	const int  Key6 = 0x36;
	const int  Key7 = 0x37;
	const int  Key8 = 0x38;
	const int  Key9 = 0x39;

	//SECOND LEVEL

	const int  KeyA = 0x41;
	const int  KeyB = 0x42;
	const int  KeyC = 0x43;
	const int  KeyD = 0x44;
	const int  KeyE = 0x45;
	const int  KeyF = 0x46;
	const int  KeyG = 0x47;
	const int  KeyH = 0x48;
	const int  KeyI = 0x49;
	const int  KeyJ = 0x4A;
	const int  KeyK = 0x4B;
	const int  KeyL = 0x4C;
	const int  KeyM = 0x4D;
	const int  KeyN = 0x4E;
	const int  KeyO = 0x4F;
	const int  KeyP = 0x50;
	const int  KeyQ = 0x51;
	const int  KeyR = 0x52;
	const int  KeyS = 0x53;
	const int  KeyT = 0x54;
	const int  KeyU = 0x55;
	const int  KeyV = 0x56;
	const int  KeyW = 0x57;
	const int  KeyX = 0x58;
	const int  KeyY = 0x59;
	const int  KeyZ = 0x5A;
	const int  KeyNumPad0 = 0x60;			//0x60
	const int  KeyNumPad1 = 0x61;			//0x61
	const int  KeyNumPad2 = 0x62;			//0x62
	const int  KeyNumPad3 = 0x63;			//0x63
	const int  KeyNumPad4 = 0x64;			//0x64
	const int  KeyNumPad5 = 0x65;			//0x65
	const int  KeyNumPad6 = 0x66;			//0x66
	const int  KeyNumPad7 = 0x67;			//0x67
	const int  KeyNumPad8 = 0x68;			//0x68
	const int  KeyNumPad9 = 0x69;			//0x69
	const int  KeyF1 = 0x70;						//0x70
	const int  KeyF2 = 0x71;						//0x71
	const int  KeyF3 = 0x72;						//0x72
	const int  KeyF4 = 0x73;						//0x73
	const int  KeyF5 = 0x74;						//0x74
	const int  KeyF6 = 0x75;						//0x75
	const int  KeyF7 = 0x76;						//0x76
	const int  KeyF8 = 0x77;						//0x77
	const int  KeyF9 = 0x78;						//0x78
	const int  KeyF10 = 0x79;					//0x79
	const int  KeyF11 = 0x7a;					//0x7A
	const int  KeyF12 = 0x7b;					//0x7B
	const int  KeyF13 = 0x7c;					//0x7C
	const int  KeyF14 = 0x7d;					//0x7D
	const int  KeyF15 = 0x7e;					//0x7E
	const int  KeyF16 = 0x7f;					//0x7F

	//THIRD LEVEL

	const int  KeyF17 = 0x80;					//0x80
	const int  KeyF18 = 0x81;					//0x81
	const int  KeyF19 = 0x82;					//0x82
	const int  KeyF20 = 0x83;					//0x83
	const int  KeyF21 = 0x84;					//0x84
	const int  KeyF22 = 0x85;					//0x85
	const int  KeyF23 = 0x86;					//0x86
	const int  KeyF24 = 0x87;					//0x87
	const int  KeyNumLock = 0x90;			//0x90
	const int  KeyScrollLock = 0x91;			//0x91
	const int  KeyLeftShift = 0xA0;			//0xA0
	const int  KeyRightShift = 0xA1;			//0xA1
	const int  KeyLeftControl = 0xA2;		//0xA2
	const int  KeyRightControl = 0xA3;		//0xA3
	const int  KeyLeftAlt = 0xA4;				//0xA4
	const int  KeyRightAlt = 0xA5;			//0xA5
	const uint KeySingleQuote = '`';
	const uint KeySemicolon = ';';
	const uint KeyLeftBracket = '[';
	const uint KeyRightBracket = ']';
	const uint KeyComma = ',';
	const uint KeyPeriod = '.';
	const uint KeyForeslash = '/';
	const uint KeyBackslash = '\\';
	const uint KeyQuote = '\'';
	const uint KeyMinus = '-';
	const uint KeyEquals = '=';
}
