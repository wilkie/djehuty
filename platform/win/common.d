/*
 * common.d
 *
 * This file holds bindings to the Windows API.
 *
 * Author: Dave Wilkinson
 *
 */

module platform.win.common;

pragma(lib, "user32.lib");

// import the windows libraries from Phobos
public import std.c.windows.winsock;

public import binding.win32.windef;
public import binding.win32.winnt;
public import binding.win32.winbase;
public import binding.win32.winerror;
public import binding.win32.wingdi;
public import binding.win32.winuser;
public import binding.win32.wincon;
public import binding.win32.mmsystem;