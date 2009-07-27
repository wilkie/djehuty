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

import platform.unix.common;

import core.string;
import core.main;
import core.definitions;

import io.console;

// SOCKET

// phobos (in, at least, GDC 0.24) has incorrect addrinfo
struct addrinfo_fix {
  int		ai_flags;			/* AI_PASSIVE, AI_CANONNAME */
  int		ai_family;			/* PF_xxx */
  int		ai_socktype;		/* SOCK_xxx */
  int		ai_protocol;		/* IPPROTO_xxx for IPv4 and IPv6 */
  size_t	ai_addrlen;			/* length of ai_addr */
  sockaddr	*ai_addr;	/* binary address */
  char		*ai_canonname;		/* canonical name for host */
  addrinfo	*ai_next;	/* next structure in linked list */
}
extern(C) char* gai_strerror(int ecode);

bool SocketOpen(ref SocketPlatformVars sockVars, ref String hostname, ref ushort port)
{
	addrinfo_fix* result;

    int error;

    addrinfo_fix hints;

	hints.ai_family = AF_UNSPEC;
    hints.ai_protocol = IPPROTO_TCP;
    hints.ai_socktype = SOCK_STREAM;

	String portstr = new String(port);

	// make C style strings
	portstr.appendChar('\0');
	hostname.appendChar('\0');

	error = getaddrinfo( hostname.ptr, portstr.ptr, cast(addrinfo*)&hints, cast(addrinfo**)&result );

	if ( 0 != error )
	{
		// Error Connecting
		Console.putln("getaddrinfo, error", portstr.array.length, ",",portstr.array);
		//printf("%s\n", gai_strerror(error));
		return false;
    }

	sockVars.m_skt = socket(result.ai_family, result.ai_socktype, result.ai_protocol);

	if (sockVars.m_skt == -1)
	{
		//file an error event
		Console.putln("socket, error");
		return false;
	}

	int iResult = connect(sockVars.m_skt, result.ai_addr, result.ai_addrlen);
	if (iResult == -1)
	{
		//file an error event
		close(sockVars.m_skt);
		sockVars.m_skt = 0;
		Console.putln("connect, error");

		return false;
	}

	Console.putln("connected");

	return true;
}

bool SocketBind(ref SocketPlatformVars sockVars, ref ushort port)
{
	return false;
}

bool SocketListen(ref SocketPlatformVars sockVars)
{
	return false;
}

bool SocketAccept(ref SocketPlatformVars sockVars)
{
	return false;
}

void SocketClose(ref SocketPlatformVars sockVars)
{
	close(sockVars.m_skt);
}

bool SocketRead(ref SocketPlatformVars sockVars, ubyte* buffer, ulong len)
{
	ulong progress = 0;
	ulong ret = 0;
	ulong amt = len;

	int cur_amt;

	ubyte* cur = buffer;

	while (progress < len)
	{
		cur_amt = cast(int)(amt & 0x7FFFFFFF);
		ret = recv(sockVars.m_skt, cur, cur_amt, 0);

		if (ret <= 0) { return false; }

		progress += ret;
		amt -= ret;
		cur += ret;

		if (ret <= 0) { return false; }
	}

	return true;
}

ulong SocketReadAvailable(ref SocketPlatformVars sockVars, ubyte* buffer, ulong len)
{
	int cur_amt = cast(int)(len & 0x7FFFFFFF);
	ulong ret = recv(sockVars.m_skt, buffer, cur_amt, 0);

	return ret;
}

bool SocketWrite(ref SocketPlatformVars sockVars, ubyte* buffer, ulong len)
{
	ulong progress = 0;
	ulong ret = 0;
	ulong amt = len;

	int cur_amt;

	ubyte* cur = buffer;

	while (progress < len)
	{
		cur_amt = cast(int)(amt & 0x7FFFFFFF);

		ret = send(sockVars.m_skt, cur, cur_amt, 0);

		if (ret <= 0) { return false; }

		progress += ret;
		amt -= ret;
		cur += ret;

		if (ret <= 0) { return false; }
	}

	return true;
}

