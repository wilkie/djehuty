/*
 * socket.d
 *
 * This module has the structure that is kept with a Socket class for Windows.
 *
 * Author: Dave Wilkinson
 * Originated: July 22th, 2009
 *
 */

module platform.vars.socket;

import binding.win32.windef;
import binding.win32.winsock2;

struct SocketPlatformVars {
	SOCKET m_skt;
	SOCKET m_bind_skt;
	DWORD m_thread_id;
	ubyte m_recvbuff[2048];

	static bool inited = false;
	static int init_ref = 0;
}