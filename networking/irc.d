/*
 * irc.d
 *
 * This file implements the IRC standard.
 *
 * Author: Dave Wilkinson
 *
 */

module networking.irc;

import core.string;
import core.stream;
import synch.thread;
import core.unicode;

import io.socket;
import io.console;

struct IRC
{
	struct Command
	{
		char[] prefix;
		char[] command;
		char[] params[16];

		char[] content;

		uint paramCount;
	}

	enum Response
	{
		None				= 300,
		UserHost			= 302,
		IsOn				= 303,
		Away				= 301,
		UnAway				= 305,
		NowAway				= 306,
		WhoIsUser			= 311,
		WhoIsServer			= 312,
		WhoIsOperator		= 313,
		WhoIsIdle			= 317,
		EndOfWhoIs			= 318,
		WhoIsChannels		= 319,
		WhoWasUser			= 314,
		EndOfWhoWas			= 369,
		ListStart			= 321,
		List				= 322,
		ListEnd				= 323,
		ChannelModeIs		= 324,
		NoTopic				= 331,
		Topic				= 332,
		Inviting			= 341,
		Summoning			= 342,
		Version				= 351,
		WhoReply			= 352,
		EndOfWho			= 315,
		NameReply			= 353,
		EndOfNames			= 366,
		Links				= 364,
		EndOfLinks			= 365,
		BanList				= 367,
		EndOfBanList		= 368,
		Info				= 371,
		EndOfInfo			= 374,
		MOTDStart			= 375,
		MOTD				= 372,
		EndOfMOTD			= 376,
		YouAreOperator		= 381,
		Rehashing			= 382,
		MyPortIs			= 384,
		Time				= 391,
		UsersStart			= 392,
		Users				= 393,
		EndOfUsers			= 394,
		NoUsers				= 395,
		WhoIsChannelOp		= 316,
		KillDone			= 361,
		Closing				= 362,
		CloseEnd			= 363,
		InfoStart			= 373,



		TrackLink			= 200,
		TraceConnecting		= 201,
		TraceHandshake		= 202,
		TraceUnknown		= 203,
		TraceOperator		= 204,
		TraceUser			= 205,
		TraceServer			= 206,
		TraceNewType		= 208,
		TraceClass			= 209,
		TraceLog			= 261,
		ServiceInfo			= 231,
		EndOfServices		= 232,
		Service				= 233,
		ServiceList			= 234,
		ServiceListEnd		= 235,
		StatsLinkInfo		= 211,
		StatsCommands		= 212,
		StatsCLine			= 213,
		StatsNLine			= 214,
		StatsILine			= 215,
		StatsKLine			= 216,
		StatsQLine			= 217,
		StatsYLine			= 218,
		EndOfStats			= 219,
		StatsLLine			= 241,
		StatsUpTime			= 242,
		StatsOLine			= 243,
		StatsHLine			= 244,
		UModeIs				= 221,
		LUserClient			= 251,
		LUserOp				= 252,
		LUserUnknown		= 253,
		LUserChannels		= 254,
		LUserMe				= 255,
		AdminMe				= 256,
		AdminLoc1			= 257,
		AdminLoc2			= 258,
		AdminEmail			= 259
	}

	enum Error
	{
		NoSuchNick			= 401,
		NoSuchServer		= 402,
		NoSuchChannel		= 403,
		CannotSendToChannel	= 404,
		TooManyChannels		= 405,
		WasNoSuchNick		= 406,
		TooManyTargets		= 407,
		NoOrigin			= 409,
		NoRecipient			= 411,
		NoTextToSend		= 412,
		NoTopLevel			= 413,
		WildcardTopLevel	= 414,
		UnknownCommand		= 421,
		NoMessageOTDay		= 422,
		NoAdminInfo			= 423,
		FileError			= 424,
		NoNickNameGiven		= 431,
		ErroneusNickname	= 432,
		NicknameInUse		= 433,
		NickCollision		= 436,
		UserNotInChannel	= 441,
		NotOnChannel		= 442,
		UserAlreadyOnChannel= 443,
		NoLogin				= 444,
		SummonDisabled		= 445,
		UsersDisabled		= 446,
		NotRegistered		= 451,
		NeedMoreParams		= 461,
		AlreadyRegistered	= 462,
		NoPermForHost		= 463,
		PasswordMismatch	= 464,
		YouAreBannedCreep	= 465,
		YouWillBeBanned		= 466,
		KeySet				= 467,
		ChannelIsFull		= 471,
		UnknownMode			= 472,
		InviteOnlyChannel	= 473,
		BannedFromChannel	= 474,
		BadChannelKey		= 475,
		BadChannelMask		= 476,
		NoPrivileges		= 481,
		ChanOpPrivsNeeded	= 482,
		CannotKillServer	= 483,
		NoOperHost			= 491,
		NoServiceHost		= 492,
		UnknownModeFlag		= 501,
		UsersDoNotMatch		= 502,
	}

	class Server
	{
	}

	class Client
	{
		this()
		{
			_skt = new Socket();
			_thread = new Thread();
			_buffer = new Stream();

			_thread.setDelegate(&_recvFunc);
		}

		~this()
		{
			close();
		}

		void setDelegate(void delegate(Command) callback)
		{
			_callback = callback;
		}

		void authenticate(string nickname, string realname)
		{
			if (_connected)
			{
//				_skt.writeUtf8("PASS hashmash\r\n");
				_skt.writeUtf8("NICK " ~ Unicode.toUtf8(nickname) ~ "\r\n");
				_skt.writeUtf8("USER " ~ Unicode.toUtf8(nickname) ~ " 0 * :" ~ Unicode.toUtf8(realname) ~ "\r\n");
			}
		}

		bool connect(string hostname, ushort port = 6667)
		{
			_connected = _skt.connect(hostname, port);

			if (_connected)
			{
				_thread.start();
			}

			return _connected;
		}

		void join(string channel)
		{
			if (_connected)
			{
				_skt.writeUtf8("JOIN " ~ Unicode.toUtf8(channel) ~ "\r\n");
			}
		}

		void quit()
		{
			if (_connected)
			{
				_skt.writeUtf8("QUIT\r\n");
			}
		}

		void close()
		{
			quit();
			_skt.close();
		}

		void sendPong(String server)
		{
			if (_connected)
			{
				_skt.writeUtf8("PONG " ~ server.toUtf8() ~ "\r\n");
			}
		}

		void sendMessage(String to, String message)
		{
			if (_connected)
			{
				_skt.writeUtf8("PRIVMSG " ~ to.toUtf8() ~ " :" ~ message.toUtf8() ~ "\r\n");
			}
		}

		void OnPing(String server)
		{
			Console.put("ping! " ~ server.toUtf8());
			sendPong(server);
		}

		void OnReceiveMessage(String to, String from, String message)
		{
			int pos = from.find(new String("!"));
			if (pos > 0)
			{
				from = from.subString(0, pos);
			}
			Console.put("Message Received");
			Console.put("from: " ~ from.toUtf8());
			Console.put("message: " ~ message.toUtf8());
		}



	protected:

		const auto downloadBuffer = 1024*128;

		Socket _skt;
		Thread _thread;

		Stream _buffer;

		bool _connected;
		uint _checkPos;
		uint _curPos;

		char[] _commandStr;

		void delegate(Command) _callback;

		void _parseResponse()
		{
			Command command;

			uint i = 0;
			if (_commandStr[0] == ':')
			{
				// prefix

				for(i=1; i<_commandStr.length; i++)
				{
					if (_commandStr[i] == ' ')
					{
						command.prefix = _commandStr[1..i];
						i++;
						break;
					}
				}
			}

			// parse the command
			uint start = i;
			for( ; i<_commandStr.length; i++)
			{
				if (_commandStr[i] == ' ')
				{
					command.command = _commandStr[start..i];
					i++;
					break;
				}
			}


			// parse each parameter

			for ( ; i<_commandStr.length; )
			{
				start = i;

				// the rest is content
				if (_commandStr[i] == ':')
				{
					command.content = _commandStr[i+1..$];
					break;
				}

				for ( ; i<_commandStr.length; i++)
				{
					if (_commandStr[i] == ' ' || _commandStr[i] == ':')
					{
						command.params[command.paramCount] = _commandStr[start..i];
						command.paramCount++;
						if (command.paramCount == command.params.length)
						{
							// error in parsing, we will ignore extra parameters
							i = _commandStr.length;
						}

						i++;
						break;
					}
				}
			}

			if (_callback !is null)
			{
				_callback(command);
			}

			// interpret the command
			if (command.command !is null)
			{
				if (command.command == "PRIVMSG" && command.paramCount > 0 && command.prefix !is null && command.content !is null)
				{
					OnReceiveMessage(new String(command.params[0]),
						new String(command.prefix),
						new String(command.content));
				}
				else if (command.command == "PING" && command.prefix !is null)
				{
					OnPing(new String(command.prefix));
				}
			}
		}

		void _recvFunc(bool pleaseStop)
		{
			if (pleaseStop)
			{
				close();
				return;
			}

			// receive the irc commands
			// and any data

			_curPos = 0;
			_checkPos = 0;

			ubyte bytein;
			for (;;)
			{
				uint ret = cast(uint)_buffer.appendAny(_skt, downloadBuffer);

				if (ret == 0) { return; }

				// Parse the IRC Response, if needed

				// Find the "\r\n" sequence and fire the command parser

				bool _foundSlashR;

				//Console.put("!!!\n", cast(char[])_buffer.contents, "\n!!!");

				Console.put("len: ", _buffer.length);

				for (;_checkPos < _buffer.length; _checkPos++)
				{
					if (_buffer.contents[_checkPos] == '\n' && _foundSlashR)
					{
						// parse command
						_commandStr = cast(char[])_buffer.contents[_curPos.._checkPos-1];
						_parseResponse();
						_curPos = _checkPos+1;
						_foundSlashR = false;
					}
					else if (_buffer.contents[_checkPos] == '\n')
					{
						_commandStr = cast(char[])_buffer.contents[_curPos.._checkPos-1];
						_parseResponse();
						_curPos = _checkPos+1;
						_foundSlashR = false;
					}
					else if (_buffer.contents[_checkPos] == '\r')
					{
						_foundSlashR = true;
					}
					else
					{
						_foundSlashR = false;
					}
				}
			}
		}


	}
}
