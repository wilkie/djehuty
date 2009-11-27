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

// Kernel
public import binding.win32.windef;
public import binding.win32.winnt;
public import binding.win32.winbase;
public import binding.win32.winerror;

// User
public import binding.win32.winuser;

// Graphical
public import binding.win32.wingdi;

// Console
public import binding.win32.wincon;

// Multimedia
public import binding.win32.mmsystem;

// Socket
public import binding.win32.ws2def;
public import binding.win32.winsock2;