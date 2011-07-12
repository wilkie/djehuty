/*
 * socket.d
 *
 * This Scaffold holds the Socket implementations for the Linux platform
 *
 * Author: Dave Wilkinson
 *
 */

module scaffold.socket;

import platform.vars.socket;

import core.string;
import core.main;
import core.definitions;

import io.console;

// SOCKET

bool SocketOpen(ref SocketPlatformVars sockVars, ref string hostname, ref ushort port) {
	return true;
}

bool SocketBind(ref SocketPlatformVars sockVars, ref ushort port) {
	return false;
}

bool SocketListen(ref SocketPlatformVars sockVars) {
	return false;
}

bool SocketAccept(ref SocketPlatformVars sockVars) {
	return false;
}

void SocketClose(ref SocketPlatformVars sockVars) {
}

bool SocketRead(ref SocketPlatformVars sockVars, ubyte* buffer, ulong len) {
	return true;
}

ulong SocketReadAvailable(ref SocketPlatformVars sockVars, ubyte* buffer, ulong len) {
	return 0;
}

bool SocketWrite(ref SocketPlatformVars sockVars, ubyte* buffer, ulong len) {
	return false;
}
