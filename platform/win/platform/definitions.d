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

import core.definitions;
import core.parameters;

// String Representation
alias wchar Char;

// Color Representation

static const Parameter_Colorbpp Colorbpp = Parameter_Colorbpp.Color8bpp;
static const Parameter_ColorType ColorType = Parameter_ColorType.ColorRGBA;



// Common Fonts

const string FontMonospace = "Courier";
const string FontTimes = "Times New Roman";
const string FontSans = "Sans";
const string FontSerif = "Sans Serif";
const string FontSystem = "Sans Serif";

// Keyboard

const int  KeyBackspace = VK_BACK;			//0x08
const int  KeyTab = VK_TAB;					//0x09
const int  KeyReturn = VK_RETURN;				//0x0D
const int  KeyAmbiShift = VK_SHIFT;			//0x10
const int  KeyAmbiControl = VK_CONTROL;		//0x11
const int  KeyAmbiAlt = VK_MENU;				//0x12
const int  KeyPause = VK_PAUSE;				//0x13
const int  KeyCapsLock = VK_CAPITAL;			//0x14
const int  KeyEscape = VK_ESCAPE;				//0x1B
const int  KeySpace = VK_SPACE;				//0x20
const int  KeyPageUp = VK_PRIOR;				//0x21
const int  KeyPageDown = VK_NEXT;				//0x22
const int  KeyEnd = VK_END;					//0x23
const int  KeyHome = VK_HOME;					//0x24
const int  KeyArrowLeft = VK_LEFT;			//0x25
const int  KeyArrowUp = VK_UP;				//0x26
const int  KeyArrowRight = VK_RIGHT;			//0x27
const int  KeyArrowDown = VK_DOWN;			//0x28
const int  KeyInsert = VK_INSERT;				//0x2D
const int  KeyDelete = VK_DELETE;				//0x2E
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
const int  KeyNumPad0 = VK_NUMPAD0;			//0x60
const int  KeyNumPad1 = VK_NUMPAD1;			//0x61
const int  KeyNumPad2 = VK_NUMPAD2;			//0x62
const int  KeyNumPad3 = VK_NUMPAD3;			//0x63
const int  KeyNumPad4 = VK_NUMPAD4;			//0x64
const int  KeyNumPad5 = VK_NUMPAD5;			//0x65
const int  KeyNumPad6 = VK_NUMPAD6;			//0x66
const int  KeyNumPad7 = VK_NUMPAD7;			//0x67
const int  KeyNumPad8 = VK_NUMPAD8;			//0x68
const int  KeyNumPad9 = VK_NUMPAD9;			//0x69
const int  KeyF1 = VK_F1;						//0x70
const int  KeyF2 = VK_F2;						//0x71
const int  KeyF3 = VK_F3;						//0x72
const int  KeyF4 = VK_F4;						//0x73
const int  KeyF5 = VK_F5;						//0x74
const int  KeyF6 = VK_F6;						//0x75
const int  KeyF7 = VK_F7;						//0x76
const int  KeyF8 = VK_F8;						//0x77
const int  KeyF9 = VK_F9;						//0x78
const int  KeyF10 = VK_F10;					//0x79
const int  KeyF11 = VK_F11;					//0x7A
const int  KeyF12 = VK_F12;					//0x7B
const int  KeyF13 = VK_F13;					//0x7C
const int  KeyF14 = VK_F14;					//0x7D
const int  KeyF15 = VK_F15;					//0x7E
const int  KeyF16 = VK_F16;					//0x7F

//THIRD LEVEL

const int  KeyF17 = VK_F17;					//0x80
const int  KeyF18 = VK_F18;					//0x81
const int  KeyF19 = VK_F19;					//0x82
const int  KeyF20 = VK_F20;					//0x83
const int  KeyF21 = VK_F21;					//0x84
const int  KeyF22 = VK_F22;					//0x85
const int  KeyF23 = VK_F23;					//0x86
const int  KeyF24 = VK_F24;					//0x87
const int  KeyNumLock = VK_NUMLOCK;			//0x90
const int  KeyScrollLock = VK_SCROLL;			//0x91
const int  KeyLeftShift = VK_LSHIFT;			//0xA0
const int  KeyRightShift = VK_RSHIFT;			//0xA1
const int  KeyLeftControl = VK_LCONTROL;		//0xA2
const int  KeyRightControl = VK_RCONTROL;		//0xA3
const int  KeyLeftAlt = VK_LMENU;				//0xA4
const int  KeyRightAlt = VK_RMENU;			//0xA5


