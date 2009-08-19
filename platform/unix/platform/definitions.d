/*
 * definitions.d
 *
 * This file gives the definition hints for several properties.
 *
 * Author: Dave Wilkinson
 *
 */

module platform.definitions;

version(PlatformLinux)
{


import core.parameters;

// String Representation
alias char Char;

// Color Representation
static const Parameter_Colorbpp Colorbpp = Parameter_Colorbpp.Color8bpp;
static const Parameter_ColorType ColorType = Parameter_ColorType.ColorBGRA;




// Graphical Types
//alias uint Pen;
//alias uint Brush;
//alias Pango.PangoFontDescription* Font;


// Common Fonts

const auto FontMonospace = "monospace"c;
const auto FontTimes = "times"c;
const auto FontSans = "sans"c;
const auto FontSerif = "serif"c;
const auto FontSystem = "sans"c;




import platform.unix.common;

const uint KeyBackspace = X.XK_BackSpace;
const uint KeyTab = X.XK_Tab;
const uint KeyReturn = X.XK_Return;
//const int KeyAmbiShift = X.XK_Shift;
//const int KeyAmbiControl = X.XK_Control;
//const int KeyAmbiAlt = X.XK_Alt;
const uint KeyPause = X.XK_Pause;
//const int KeyCapsLock = X.XK_Capital;
const uint KeyEscape = X.XK_Escape;
const uint KeySpace = X.XK_Space;
const uint KeyPageUp = X.XK_Prior;
const uint KeyPageDown = X.XK_Next;
const uint KeyEnd = X.XK_End;
const uint KeyHome = X.XK_Home;
const uint KeyArrowLeft = X.XK_Left;
const uint KeyArrowUp = X.XK_Up;
const uint KeyArrowRight = X.XK_Right;
const uint KeyArrowDown = X.XK_Down;
const uint KeyInsert = X.XK_Insert;
const uint KeyDelete = X.XK_Delete;
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

; //SECOND LEVEL

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
const uint KeyNumPad0 = X.XK_KP_0; //0x60
const uint KeyNumPad1 = X.XK_KP_1; //0x61
const uint KeyNumPad2 = X.XK_KP_2; //0x62
const uint KeyNumPad3 = X.XK_KP_3; //0x63
const uint KeyNumPad4 = X.XK_KP_4; //0x64
const uint KeyNumPad5 = X.XK_KP_5; //0x65
const uint KeyNumPad6 = X.XK_KP_6; //0x66
const uint KeyNumPad7 = X.XK_KP_7; //0x67
const uint KeyNumPad8 = X.XK_KP_8; //0x68
const uint KeyNumPad9 = X.XK_KP_9; //0x69
const uint KeyF1 = X.XK_F1; //0x70
const uint KeyF2 = X.XK_F2; //0x71
const uint KeyF3 = X.XK_F3; //0x72
const uint KeyF4 = X.XK_F4; //0x73
const uint KeyF5 = X.XK_F5; //0x74
const uint KeyF6 = X.XK_F6; //0x75
const uint KeyF7 = X.XK_F7; //0x76
const uint KeyF8 = X.XK_F8; //0x77
const uint KeyF9 = X.XK_F9; //0x78
const uint KeyF10 = X.XK_F10; //0x79
const uint KeyF11 = X.XK_F11; //0x7A
const uint KeyF12 = X.XK_F12; //0x7B
const uint KeyF13 = X.XK_F13; //0x7C
const uint KeyF14 = X.XK_F14; //0x7D
const uint KeyF15 = X.XK_F15; //0x7E
const uint KeyF16 = X.XK_F16; //0x7F

; //THIRD LEVEL

const uint KeyF17 = X.XK_F17; //0x80
const uint KeyF18 = X.XK_F18; //0x81
const uint KeyF19 = X.XK_F19; //0x82
const uint KeyF20 = X.XK_F20; //0x83
const uint KeyF21 = X.XK_F21; //0x84
const uint KeyF22 = X.XK_F22; //0x85
const uint KeyF23 = X.XK_F23; //0x86
const uint KeyF24 = X.XK_F24; //0x87
const uint KeyNumLock = X.XK_Num_Lock; //0x90
const uint KeyScrollLock = X.XK_Scroll_Lock; //0x91
const uint KeyLeftShift = X.XK_Shift_L; //0xA0
const uint KeyRightShift = X.XK_Shift_R; //0xA1
const uint KeyLeftControl = X.XK_Control_L; //0xA2
const uint KeyRightControl = X.XK_Control_R; //0xA3
const uint KeyLeftAlt = X.XK_Meta_L; //0xA4
const uint KeyRightAlt = X.XK_Meta_R; //0xA5

}
