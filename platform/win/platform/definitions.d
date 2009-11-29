/*
 * definitions.d
 *
 * This file holds common definitions to programmable parameters for Windows.
 *
 * Author: Dave Wilkinson
 *
 */

module platform.definitions;

import platform.win.common;

import core.parameters;

// String Representation
alias wchar Char;

// Color Representation

static const Parameter_Colorbpp Colorbpp = Parameter_Colorbpp.Color8bpp;
static const Parameter_ColorType ColorType = Parameter_ColorType.ColorBGRA;


// Common Fonts

const string FontMonospace = "Courier";
const string FontTimes = "Times New Roman";
const string FontSans = "Sans";
const string FontSerif = "Sans Serif";
const string FontSystem = "Sans Serif";

// Keyboard

const uint KeyBackspace = VK_BACK;			//0x08
const uint KeyTab = VK_TAB;					//0x09
const uint KeyReturn = VK_RETURN;			//0x0D
const uint KeyAmbiShift = VK_SHIFT;			//0x10
const uint KeyAmbiControl = VK_CONTROL;		//0x11
const uint KeyAmbiAlt = VK_MENU;			//0x12
const uint KeyPause = VK_PAUSE;				//0x13
const uint KeyCapsLock = VK_CAPITAL;		//0x14
const uint KeyEscape = VK_ESCAPE;			//0x1B
const uint KeySpace = VK_SPACE;				//0x20
const uint KeyPageUp = VK_PRIOR;			//0x21
const uint KeyPageDown = VK_NEXT;			//0x22
const uint KeyEnd = VK_END;					//0x23
const uint KeyHome = VK_HOME;				//0x24
const uint KeyArrowLeft = VK_LEFT;			//0x25
const uint KeyArrowUp = VK_UP;				//0x26
const uint KeyArrowRight = VK_RIGHT;		//0x27
const uint KeyArrowDown = VK_DOWN;			//0x28
const uint KeyInsert = VK_INSERT;			//0x2D
const uint KeyDelete = VK_DELETE;			//0x2E
const uint Key0 = 0x30;
const uint Key1 = 0x31;
const uint Key2 = 0x32;
const uint Key3 = 0x33;
const uint Key4 = 0x34;
const uint Key5 = 0x35;
const uint Key6 = 0x36;
const uint Key7 = 0x37;
const uint Key8 = 0x38;
const uint Key9 = 0x39;

//SECOND LEVEL

const uint KeyA = 0x41;
const uint KeyB = 0x42;
const uint KeyC = 0x43;
const uint KeyD = 0x44;
const uint KeyE = 0x45;
const uint KeyF = 0x46;
const uint KeyG = 0x47;
const uint KeyH = 0x48;
const uint KeyI = 0x49;
const uint KeyJ = 0x4A;
const uint KeyK = 0x4B;
const uint KeyL = 0x4C;
const uint KeyM = 0x4D;
const uint KeyN = 0x4E;
const uint KeyO = 0x4F;
const uint KeyP = 0x50;
const uint KeyQ = 0x51;
const uint KeyR = 0x52;
const uint KeyS = 0x53;
const uint KeyT = 0x54;
const uint KeyU = 0x55;
const uint KeyV = 0x56;
const uint KeyW = 0x57;
const uint KeyX = 0x58;
const uint KeyY = 0x59;
const uint KeyZ = 0x5A;
const uint KeySingleQuote = VK_OEM_3;
const uint KeySemicolon = VK_OEM_1;
const uint KeyLeftBracket = VK_OEM_4;
const uint KeyRightBracket = VK_OEM_6;
const uint KeyComma = VK_OEM_COMMA;
const uint KeyPeriod = VK_OEM_PERIOD;
const uint KeyForeslash = VK_OEM_2;
const uint KeyBackslash = VK_OEM_5;
const uint KeyQuote = VK_OEM_7;
const uint KeyMinus = VK_OEM_MINUS;
const uint KeyEquals = VK_OEM_PLUS;
const uint KeyNumPad0 = VK_NUMPAD0;			//0x60
const uint KeyNumPad1 = VK_NUMPAD1;			//0x61
const uint KeyNumPad2 = VK_NUMPAD2;			//0x62
const uint KeyNumPad3 = VK_NUMPAD3;			//0x63
const uint KeyNumPad4 = VK_NUMPAD4;			//0x64
const uint KeyNumPad5 = VK_NUMPAD5;			//0x65
const uint KeyNumPad6 = VK_NUMPAD6;			//0x66
const uint KeyNumPad7 = VK_NUMPAD7;			//0x67
const uint KeyNumPad8 = VK_NUMPAD8;			//0x68
const uint KeyNumPad9 = VK_NUMPAD9;			//0x69
const uint KeyF1 = VK_F1;					//0x70
const uint KeyF2 = VK_F2;					//0x71
const uint KeyF3 = VK_F3;					//0x72
const uint KeyF4 = VK_F4;					//0x73
const uint KeyF5 = VK_F5;					//0x74
const uint KeyF6 = VK_F6;					//0x75
const uint KeyF7 = VK_F7;					//0x76
const uint KeyF8 = VK_F8;					//0x77
const uint KeyF9 = VK_F9;					//0x78
const uint KeyF10 = VK_F10;					//0x79
const uint KeyF11 = VK_F11;					//0x7A
const uint KeyF12 = VK_F12;					//0x7B
const uint KeyF13 = VK_F13;					//0x7C
const uint KeyF14 = VK_F14;					//0x7D
const uint KeyF15 = VK_F15;					//0x7E
const uint KeyF16 = VK_F16;					//0x7F

//THIRD LEVEL

const uint KeyF17 = VK_F17;					//0x80
const uint KeyF18 = VK_F18;					//0x81
const uint KeyF19 = VK_F19;					//0x82
const uint KeyF20 = VK_F20;					//0x83
const uint KeyF21 = VK_F21;					//0x84
const uint KeyF22 = VK_F22;					//0x85
const uint KeyF23 = VK_F23;					//0x86
const uint KeyF24 = VK_F24;					//0x87
const uint KeyNumLock = VK_NUMLOCK;			//0x90
const uint KeyScrollLock = VK_SCROLL;		//0x91
const uint KeyLeftShift = VK_LSHIFT;		//0xA0
const uint KeyRightShift = VK_RSHIFT;		//0xA1
const uint KeyLeftControl = VK_LCONTROL;	//0xA2
const uint KeyRightControl = VK_RCONTROL;	//0xA3
const uint KeyLeftAlt = VK_LMENU;			//0xA4
const uint KeyRightAlt = VK_RMENU;			//0xA5