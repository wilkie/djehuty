module platform.unix.definitions;

version(PlatformLinux)
{

import platform.unix.common;

import core.definitions;
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





const int KeyBackspace = X.XK_BackSpace;
const int KeyTab = X.XK_Tab;
const int KeyReturn = X.XK_Return;
//const int KeyAmbiShift = X.XK_Shift;
//const int KeyAmbiControl = X.XK_Control;
//const int KeyAmbiAlt = X.XK_Alt;
const int KeyPause = X.XK_Pause;
//const int KeyCapsLock = X.XK_Capital;
const int KeyEscape = X.XK_Escape;
const int KeySpace = X.XK_Space;
const int KeyPageUp = X.XK_Prior;
const int KeyPageDown = X.XK_Next;
const int KeyEnd = X.XK_End;
const int KeyHome = X.XK_Home;
const int KeyArrowLeft = X.XK_Left;
const int KeyArrowUp = X.XK_Up;
const int KeyArrowRight = X.XK_Right;
const int KeyArrowDown = X.XK_Down;
const int KeyInsert = X.XK_Insert;
const int KeyDelete = X.XK_Delete;
const int Key0 = 0x30;
const int Key1 = 0x31;
const int Key2 = 0x32;
const int Key3 = 0x33;
const int Key4 = 0x34;
const int Key5 = 0x35;
const int Key6 = 0x36;
const int Key7 = 0x37;
const int Key8 = 0x38;
const int Key9 = 0x39;

; //SECOND LEVEL

const int KeyA = 0x41;
const int KeyB = 0x42;
const int KeyC = 0x43;
const int KeyD = 0x44;
const int KeyE = 0x45;
const int KeyF = 0x46;
const int KeyG = 0x47;
const int KeyH = 0x48;
const int KeyI = 0x49;
const int KeyJ = 0x4A;
const int KeyK = 0x4B;
const int KeyL = 0x4C;
const int KeyM = 0x4D;
const int KeyN = 0x4E;
const int KeyO = 0x4F;
const int KeyP = 0x50;
const int KeyQ = 0x51;
const int KeyR = 0x52;
const int KeyS = 0x53;
const int KeyT = 0x54;
const int KeyU = 0x55;
const int KeyV = 0x56;
const int KeyW = 0x57;
const int KeyX = 0x58;
const int KeyY = 0x59;
const int KeyZ = 0x5A;
const int KeyNumPad0 = X.XK_KP_0; //0x60
const int KeyNumPad1 = X.XK_KP_1; //0x61
const int KeyNumPad2 = X.XK_KP_2; //0x62
const int KeyNumPad3 = X.XK_KP_3; //0x63
const int KeyNumPad4 = X.XK_KP_4; //0x64
const int KeyNumPad5 = X.XK_KP_5; //0x65
const int KeyNumPad6 = X.XK_KP_6; //0x66
const int KeyNumPad7 = X.XK_KP_7; //0x67
const int KeyNumPad8 = X.XK_KP_8; //0x68
const int KeyNumPad9 = X.XK_KP_9; //0x69
const int KeyF1 = X.XK_F1; //0x70
const int KeyF2 = X.XK_F2; //0x71
const int KeyF3 = X.XK_F3; //0x72
const int KeyF4 = X.XK_F4; //0x73
const int KeyF5 = X.XK_F5; //0x74
const int KeyF6 = X.XK_F6; //0x75
const int KeyF7 = X.XK_F7; //0x76
const int KeyF8 = X.XK_F8; //0x77
const int KeyF9 = X.XK_F9; //0x78
const int KeyF10 = X.XK_F10; //0x79
const int KeyF11 = X.XK_F11; //0x7A
const int KeyF12 = X.XK_F12; //0x7B
const int KeyF13 = X.XK_F13; //0x7C
const int KeyF14 = X.XK_F14; //0x7D
const int KeyF15 = X.XK_F15; //0x7E
const int KeyF16 = X.XK_F16; //0x7F

; //THIRD LEVEL

const int KeyF17 = X.XK_F17; //0x80
const int KeyF18 = X.XK_F18; //0x81
const int KeyF19 = X.XK_F19; //0x82
const int KeyF20 = X.XK_F20; //0x83
const int KeyF21 = X.XK_F21; //0x84
const int KeyF22 = X.XK_F22; //0x85
const int KeyF23 = X.XK_F23; //0x86
const int KeyF24 = X.XK_F24; //0x87
const int KeyNumLock = X.XK_Num_Lock; //0x90
const int KeyScrollLock = X.XK_Scroll_Lock; //0x91
const int KeyLeftShift = X.XK_Shift_L; //0xA0
const int KeyRightShift = X.XK_Shift_R; //0xA1
const int KeyLeftControl = X.XK_Control_L; //0xA2
const int KeyRightControl = X.XK_Control_R; //0xA3
const int KeyLeftAlt = X.XK_Meta_L; //0xA4
const int KeyRightAlt = X.XK_Meta_R; //0xA5

}