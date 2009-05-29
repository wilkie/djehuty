/*
 * vars.d
 *
 * This file implements the Platform Variables for the Linux system.
 *
 * Author: Dave Wilkinson
 *
 */

module platform.unix.vars;

import platform.unix.common;
import platform.unix.common : FILE;
import platform.unix.definitions;

import core.definitions;
import core.string;

// GLOBAL SPACE
struct DjehutyPlatformVars
{
	X.Display* display;
	X.Visual* visual;
	int screen;

	X.Atom wm_destroy_window;
	X.Atom wm_name;
	X.Atom wm_hints;
	X.Atom utf8string;
	X.Atom private_data;

	//for mouse double click timer
	static sigevent clickTimerevp = {{0}};
	static timer_t clickTimerId = null;
	static const itimerspec clickTimertime = {{0, 0}, {0, 250000000}};

	//for keys
	static const int numSysKeys = 6;
	static const X.KeySym[6] sysKey = [KeyBackspace, KeyDelete, KeyArrowLeft, KeyArrowRight, KeyArrowDown, KeyArrowUp];

	//GTK IMPLEMENTATION:

	//for xsettings - GTK
	X.Atom x_settings;

	X.Window x_manager;

	bool running = false;

	int argc;
	char** argv;
}

DjehutyPlatformVars _pfvars;


// platform vars will be added to internal classes
// upon compile...use them to store extra information

struct WindowPlatformVars
{
	// required parameters:

	bool _hasGL;		// is a GLWindow
	bool _hasView;		// is a Window

	// -----

	X.Window window;

	//GLXContext ctx;

	//to handle sync issues
	bool destroy_called = false;		//true, when window is to be destroyed
}

struct ViewPlatformVars
{
	X.Window cur_window;

	X.Pixmap pixmap;
	bool pixmap_loaded;

	X.GC gc;

	uint curpen;
	uint curbrush;

	//text
	Cairo.cairo_t* cr;
	Cairo.cairo_surface_t* surface;

	Pango.PangoLayout* layout;

	Pango.PangoAttrList* attr_list_opaque;
	Pango.PangoAttrList* attr_list_transparent;

	Pango.PangoAttribute* attr_bg;

	char* data;

	double textclr_red;
	double textclr_green;
	double textclr_blue;

	int isOpaqueRendering;

	ulong bits_length;
}

struct BrushPlatformVars
{
	uint val;
}

struct PenPlatformVars
{
	uint val;
}

struct FontPlatformVars
{
	Pango.PangoFontDescription* pangoFont;
}

struct SemaphorePlatformVars
{
	sem_t sem_id;
}

struct MutexPlatformVars
{
}

struct ThreadPlatformVars
{
	pthread_t id;
}

struct MenuPlatformVars
{
}

struct FilePlatformVars
{
    FILE* file;
}

struct DirectoryPlatformVars
{
	DIR* dir;
}

struct SocketPlatformVars
{
	int m_skt;
}

struct WavePlatformVars
{
}

struct LibraryPlatformVars
{
	void* handle;
}