/*
 *ftp.d
 *
 *This file implements the ftp standard
 *
 *Author: Brad Kuhlman
 *
 */

module networking.ftp;

import djehuty;

import io.socket;
import io.console;
import io.file;

import synch.thread;
import synch.semaphore;

import core.regex;

private {
	enum Code {
		RMR = 110,                          //Restart marker reply
		SRNNNM = 120,                       //Service ready in nnn minutes
		DCAO = 125, 			    //Data connection already open; transfer starting
		FSOK = 150, 			    //File status okay;about to open data connection

		OK = 200,			    //Command okay.
		CNI = 202, 			    //Command not implemented, superflous at this site

		SHR = 211,			    //System status, or system help reply
		DIRST = 212, 			    //Directory status
		FIST = 213,			    //File Status
		HMESG = 214,			    //Help Message
		NST = 215, 			    //NAME system type

		SRNU = 220,			    //Service ready for new user
		SCCC = 221,			    //Service closing control connection

		DCO = 225,			    //Data connection open; no transfer in progress
		CDC = 226,			    //Closing Data connect; file transfer success

		PASS = 227, 			    //Entering Passive Mode

		USERLOG = 230,			    //User logged in, proceed

		RFAOK = 250,			    //Request file action okay, complete

		PATHCR = 257,			    //"PATHNAME" created

		UNOKA = 331,			    //User name okay, need password
		NEEDACO = 332,			    //Need account for login

		RFAPFI = 350,			    //Request file action pending further information

		SNA = 421,			    //Service not available, closing control connection
		CODC = 425,			    //Can't open data connection

		RFANTFB = 450,			    //Requested file action not taken. File busy
		RAALEP = 451,			    //Requested action aborted; local error in processing
		RANT = 452,			    //Requested action not taken. Insufficient storage
		//space on sytem.

		SE = 500,			    //Syntax error, command unrecognized
		SEPA = 501,                         //Syntax error in parameters or arguments
		COMNI = 502,			    //Command not implemented
		BSOC = 503,			    //Bad sequence of commands
		CNIFTP = 504,			    //Command not implemented for that parameter

		NLI = 530,			    //Not logged in

		NAFSF = 532,			    //Need account for storing files

		RANTFUA = 550,			    //Requested action not taken; file unavailable
		RAAPTU = 551,			    //Requested action aborted: page type unknown
		RFAA = 552,			    //Requested file action aborted. Exceed storage
		//allocation

		REQANT = 553			    //Requested action not taken. File name not allowed

	}
}


//Description: This class provides server interface to the ftp protocol
class FtpServer {
	this(){
	}
}

class FtpClient : Dispatcher {
	enum Signal {
		Authenticated = 0,
		PassiveMode = 1,
		LoginIncorrect = 2,
		CurDirSuc =3, 
		OK = 4,
	}

	enum Data_Mode {
		GetFile = 0,
		SendFile = 1,
		PrintFile = 2,

	}

	this() {
		_cskt = new Socket();
		_cthread = new Thread();
		_dskt = new Socket();
		_dthread = new Thread();		
		_busy = new Semaphore(1);


		_cthread.callback = &cthreadProc;
		_dthread.callback = &dthreadProc;

	}

	//Description: Connect to the ftp server at the host given. The port is optional by default it is 21.
	//host: The host to connect to.
	//port: The port to use to connect. Default is 21.
	bool connect(string host, ushort port =21,string username="anonymous",string password=""){
		_busy.down();
		
		_connected = _cskt.connect(host,port);

		_username = username;
		_password = password;

		if (_connected) {
			_cthread.start();
		}	

		return _connected;
	}

	bool open_dataconnect(string host, ushort port =20)
	{
		bool data_connect = false;
			
		data_connect = _dskt.connect(host,port);

		if (data_connect){
			_dthread.run();
		}
		
		return data_connect;

	}
	
	bool get_file(string spath,string file, string local_dest)
	{
		send_Command("PASV");
		send_Command("TYPE I");
		send_Command("CWD " ~ spath);
		send_Command("RETR " ~ file);
		
		_datamode = Data_Mode.GetFile;
		_filename = local_dest ~ file;

		open_dataconnect(_host,_dataport);

		return true;
	}

	bool send_file(string server_path,string file, string user_path)
	{
		send_Command("PASV");
		send_Command("TYPE I");
		send_Command("CWD " ~ server_path);
		send_Command("STOR " ~ file);
	
		_datamode = Data_Mode.SendFile;
		_filename = user_path ~ file;
		
		open_dataconnect(_host,_dataport);
	
		return true;

	}	

	string list_directory(string path)
	{
		send_Command("PASV");
		send_Command("CWD " ~ path);
		send_Command("LIST");

		_datamode = Data_Mode.PrintFile;
		open_dataconnect(_host,_dataport);
		_busy.down;
		_busy.up;
		return _reply;	
	}

	void send_Command(string command)
	{
		_busy.down();

		if (_connected){
			Console.putln("sending ", command);
			command ~= "\n";
			_cskt.write(command);
		}
	}

	bool close(){
		_busy.down();
		_cskt.close();
		return true;
	}




protected:
	//Description: control connection thread	
	void cthreadProc(bool pleaseStop){

		if (pleaseStop) {
			return;
		}
	
		string response;
		while (!pleaseStop) {
			
	//			Console.putln("bleh");
			if (!_cskt.readLine(response)) {
	//			Console.putln("foo?!");
				break;
			}
	//			Console.putln("bleh!");
	
			Console.putln(response);		
			
			ushort code;
			response.nextInt(code);
			response = response[toStr(code).length+1..$];
		

			switch (code)
			{
				case Code.OK:// 200
					raiseSignal(Signal.OK);
					_busy.up();
					break; 
				case Code.SRNU: // 220
					//enter username 
					_cskt.write("USER " ~ _username ~ "\n");					
					break;
				case Code.UNOKA: // 331
					//enter password for username
					_cskt.write("PASS " ~ _password ~ "\n");
					
					break; 
				case Code.USERLOG: // 230 
					//user logged in 
					_busy.up();
					raiseSignal(Signal.Authenticated);
					break; 
				case Code.PATHCR: // 257
					Console.putln(response);
					break;
				case Code.FSOK:  // 150
					Console.putln("Starting Data Transfer ...");
					//get size of file
					
					break; 
				case Code.CDC: // 226
					//transfer complete
					_dskt.close();
					_busy.up();
					//		Console.putln("transfer complete");
					break; 
				case Code.PASS: //227
					//break apart and determine port
					string[] s = response.split("(,)");
					_host = s[1] ~ "." ~ s[2]~ "." ~ s[3] ~ "."  ~ s[4]; 
					ushort port1,port2;
					s[5].nextInt(port1);
					s[6].nextInt(port2);
					_dataport = (256 * port1) + port2;			

					
					// Raise signal
					raiseSignal(Signal.PassiveMode);
					_busy.up();
					break;
				case Code.RFAOK: 
				
					Console.putln("Current directory successful");
		//			raiseSignal(Signal.CurDirSuc);
					_busy.up();
					break; 
				case Code.NLI:

					Console.putln("Login Incorrect");
					raiseSignal(Signal.LoginIncorrect);
					break; 
				default:
					break;
			}



		}

//		Console.putln("cthread stopped");


	}

	//Description: data connection thread
	void dthreadProc(bool pleaseStop) {
		if (pleaseStop)	{
			return;
		}
	
		string response;
		ulong check;
		File f;
		
		switch (_datamode)
		{
			case Data_Mode.GetFile:
				f = new File(_filename);
				do {
					check = _dskt.readAny(f,100);
				}while(check != 0);
				f.close();
			break;
			case Data_Mode.SendFile:	
				f = File.open(_filename);
	   			check = _dskt.write(f,f.length);
				f.close();
			break;
			case Data_Mode.PrintFile:
				_reply = "";
				while (_dskt.readLine(response))
				{
					_reply ~= response ~ "\n";
				}		

			break;

			default: 
				//probably bad
			break;
		}
		_dskt.close();

		//done transfer close connection 
	}

	Socket _cskt;
	Socket _dskt;

	string _host;
	string _username;
	string _password;
	string _filename;
	string _reply;

	ushort _dataport;
	ushort _datamode;

	Semaphore _busy;

	bool _connected = false;

	Thread _cthread;
	Thread _dthread;
	
}
