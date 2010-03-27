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
import io.directory;

import synch.thread;
import synch.semaphore;
import synch.mutex;

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

		DIRE = 521,			//Directory already exists

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

	enum DataMode {
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
	
	//Description: Connects to the ftp server to allow for data transfer. 

	//host: The host to connect to.
	//port: The port to use to connect. Default is 20
	bool open_dataconnect(string host, ushort port =20)
	{
		bool data_connect = false;
			
		data_connect = _dskt.connect(host,port);

		if (data_connect){
			_dthread.run();
		}
		
		return data_connect;

	}
	//Description: Downloads a file from the ftp server onto a user's local computer 

	//server_path: The path to the file that the user wants to download from the server
	//local_dest: The directory on the user's computer that the file will be saved to 
	bool get_file(string server_path, string local_dest)
	{
		//check if directory !!! 
		string[] file = split(server_path,'/');

		string par_path = server_path[0..($ - (file[$-1].length))];
		
		string[] cur_files = split(list_directory(par_path),"\n");
		string[] temp;
		foreach(c;cur_files)
		{
			temp = split(c," ");
			if (temp[$-1] ==  file[$-1])
			{
				break;
			}	
		}
		//directory!!
		if (temp[0][0] == 'd')
		{
			Directory new_dir = Directory.create(local_dest ~ file[$-1]);
			string[] proc_files = split(list_directory(server_path,1),"\n");
			foreach(c;proc_files)
			{
				get_file(c,local_dest ~ file[$-1] ~ "/");
			}

		}
		else 
		{
			send_command("PASV");
			send_command("TYPE I");

			send_command("RETR " ~ server_path);
		
			_datamode = DataMode.GetFile;
			_filename = local_dest ~ file[$-1];

			open_dataconnect(_host,_dataport);

		}
		_datamode = DataMode.GetFile;
		_filename = local_dest ~ file[$-1];


		return true;
	}

	//Description: Sends a file from the local computer to the ftp server
	//user_path: The path to the file that the user wants to send to the server
	//server_dest: The directory on the server that the file will be saved to
	bool send_file(string user_path,string server_dest) {
		Directory dir_files = Directory.open(user_path);

		if (dir_files !is null)
		{
			string[] items = dir_files.list();
			string server_loc = server_dest ~ dir_files.name() ~ "/";
			send_command("MKD " ~ server_loc);
			foreach(c;items) {
				//RECURSION !! !
				send_file(user_path ~ "/" ~ c,server_loc); 
			}
		}
		else 
		{
			send_command("PASV");
			send_command("TYPE I");
			string[] file = split(user_path,'/');

			send_command("STOR " ~ server_dest ~ file[$-1]);

			_datamode = DataMode.SendFile;
			_filename = user_path;

			open_dataconnect(_host,_dataport);
		}

		return true;
	}	

	//Description: Deletes a file on the server 
	//path: The path to the file to delete on the ftp server
	bool delete_file(string path)
	{
		send_command("PASV");
		send_command("DELE " ~ path);

		return true;
	}
	//Description: List the contents of the directory that the user specifies

	//path: The directory that will be displayed to the user
	//mode: 0 returns a string of the normal directory structure
	//      1 returns a simplified directory structure 
	string list_directory(string path, ubyte mode = 0) {
		send_command("PASV");
		if (mode == 0) {
			send_command("LIST " ~ path);
		}
		else {
			send_command("NLST " ~ path);
		}

		_datamode = DataMode.PrintFile;
		open_dataconnect(_host,_dataport);
		_busy.down;
		_busy.up;
		return _reply;	
	}
	//Description: Renames a file on the ftp server

	//orig_path: Path to the original file to rename
	//new_path: Path to the new location of the file
	bool rename_file(string orig_path, string new_path)
	{
		send_command("RNFR " ~ orig_path);
		send_command("RNTO " ~ new_path);
	
		return true;
	}
	//Description: Returns a string of the current path
	string get_path()
	{
		send_command("PWD");

		_busy.down;
		_busy.up;
		return _reply;
	}
	//Description: Sends a command to the ftp server 

	//command: The command to be sent to the ftp server
	void send_command(string command)
	{
		_busy.down();

		if (_connected){
			Console.putln("sending ", command);
			command ~= "\n";
			_cskt.write(command);
		}
	}
	//Description: Closes the ftp connection

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
			
			if (!_cskt.readLine(response)) {
				break;
			}
	
			Console.putln(response);		
			
			ushort code;
			response.nextInt(code);
			response = response[toStr(code).length+1..$];
		

			switch (code)
			{
				case Code.OK:// 200
				//	raiseSignal(Signal.OK);
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
				//	raiseSignal(Signal.Authenticated);
					break; 
				case Code.PATHCR: // 257
					string[] temp = split(response, " ");
					_reply = temp[0][1..($-1)] ~ "/";
					_busy.up();
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
				//	raiseSignal(Signal.PassiveMode);
					_busy.up();
					break;
				case Code.RFAOK: //250 
				
				//	Console.putln("Current directory successful");
		//			raiseSignal(Signal.CurDirSuc);
					_busy.up();
					break; 
				case Code.NLI:

					Console.putln("Login Incorrect");
					raiseSignal(Signal.LoginIncorrect);
					break; 
				case Code.RFAPFI: //350
					_busy.up();

					break;	
				case Code.DIRE: //521
					//directory already exists which is a fine result for us
					_busy.up();
			
					break;
				default:
					break;
			}



		}


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
			case DataMode.GetFile:
				f = new File(_filename);
				do {
					check = _dskt.readAny(f,100);
				}while(check != 0);
				f.close();
			break;
			case DataMode.SendFile:	
				f = File.open(_filename);
	   			check = _dskt.write(f,f.length);
				f.close();
			break;
			case DataMode.PrintFile:
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
