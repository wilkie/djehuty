import djehuty;

import specs.test;

// Djehuty
//	| Controls
//	| Sockpuppets
//	| Utils
//	| Parsers
//	| Hashes
//	| Graphics
//	| Core
//	|  | Bases
//	|  | Interfaces
//	| Platform
//	| Console
//	| Codecs
//	| Math
//	|  | Common (sqrt, etc)
//	|  | Vector (Vector)
//	|  | Matrix (Matrix)
//	|  | MathObject
//	|  | Stat
//	| OpenGL
//	|  | Window
//	|  | GL
//	|  | GLU
//	|  | Texture

class Field : View {
	this() {
		CreateDIB(1024,768);
	}

	void random(long seed = -1) {
		void* ptr;
		ulong len;

		lockBuffer(&ptr, len);

		data = cast(uint*)ptr;
		len /= 4;
		max = data + len;

		Random rnd = new Random(seed);
		long height = rnd.next((_height / 4) * 3);
		long width = 0;

		Console.putln("height: ", height);

		long state = 0; // plateau
		double slope = 1.0;
		long slopeState;

		for(int i = 0; i < _width; i++) {

			if (state == 0) {
				// plateau
				double step = rnd.nextDouble();
				if (step < 0.4) {
					state = -1;
				}
				else if (step > 0.6) {
					state = 1;
				}
				else {
					state = 2;
				}

				slopeState = rnd.next(2);
			}
			else {
				double slopeChange = rnd.nextDouble();

				if (state == -1) {
					// up hill
					height += cast(long)(4.0 * slope);
				}
				else if (state == 2) {
					height += cast(long)(2 - rnd.next(4));
				}
				else {
					// down hill
					height -= cast(long)(4.0 * slope);
					if (height < 0) { height = 0; }
				}

				if (slopeState == 0) {
					slope -= slopeChange;
					if (slope < 0.0) {
						state = 0;
					}
				}
				else {
					slope += slopeChange;
					if (slope > 1.0) {
						state = 0;
					}
				}
			}
			drawLine(i, height);
		}

		unlockBuffer();

	}

	void drawLine(long x, long height) {
		// draw line
		if (height > _height) { height = _height - 1; }
		if (x > _width) { x = _width - 1; }
		uint* curLine = data + ((_height - height) * _width) + x;

		for( ; curLine < max; curLine += _width) {
			*curLine = 0xff00;
		}
	}

	void explode(int x, int y, int intensity) {
	}
protected:
	uint* data;
	uint* max;
}

class MyControl : WindowedControl
{
	Image img;
	Field fld;

	this()
	{
		super(0,0,48,48);
		img = new Image("tiles.png");
		fld = new Field();
		fld.random();
	}

	void OnDraw(ref Graphics g)
	{
		g.drawImage(50,50,img);
		g.drawView(0,0,fld);
	}
}

class MyWindow : Window
{
	this()
	{
		super("Blarg !!! AND A HALF!!!", WindowStyle.Fixed, Color.Black, 0, 0,
			1024,		// width
			768			// height
		);
	}

	~this()
	{
	}

	IRC.Client ic;
	TextField tf;
	Button btn;

	void OnAdd()
	{
		setState(WindowState.Fullscreen);
		tf = new TextField(0,0,200,25,"Hello");
		btn = new Button(200,25,25,25,"!", &btnEvent);
		addControl(tf);
		addControl(btn);

		addControl(new MyControl());

		//ic = new IRC.Client();

		//ic.setDelegate(&IRCInterpret);

		//ic.connect("hubbard.freenode.net");

		//ic.authenticate("djehuty", "Djehuty");
		//ic.join("#djehuty");
	}

	void btnEvent(Button btn, ButtonEvent bevt)
	{
		if (bevt == ButtonEvent.Selected)
		{
			ic.sendMessage(new String("#djehuty"), tf.getText());
		}
	}

	void IRCInterpret(IRC.Command command)
	{
		/*
		if (command.prefix !is null)
		{
			writef("prefix: ", command.prefix);
		}

		writef("command: ", command.command);

		foreach(param; command.params)
		{
			if (param !is null)
			{
				writef("param: ", param);
			}
		}

		if (command.content !is null)
		{
			writef("content: ", command.content);
		}

		Console.putln(""); *

		Console.putln("PREFIX");

		if (command.prefix !is null)
		{
		Console.putln(command.prefix);
		}

		Console.putln("PARAMS");

		if (command.params !is null)
		{
			foreach(param; command.params[0..command.paramCount])
			{
				Console.putln("", param);
			}
		}

		Console.putln("COMMAND");
		if (command.command !is null)
		{
			Console.putln(command.command);
		}


		Console.putln("CONTENT");
		if (command.content !is null)
		{
			Console.putln(command.content);
		}//*/
	}
}
/*
class MyWindow : GLWindow
{
	this()
	{
		//super("Window Manager Simulation", WindowStyle.Fixed, Color.Black, 0, 0,
		//	1024,		// width
		//	768			// height
		//);

		super("Blah!", WindowStyle.Sizable, 0,0,640,480);
	}

	GLdouble x=0.5;
	GLdouble y=0.5;

	GLdouble w=0.1;
	GLdouble h=0.1;

	GLdouble xv=0.05;
	GLdouble yv=0.05;

	Texture tx;

	//IRCClient ic;

	void OnAdd()
	{

		//ic = new IRCClient();

		//ic.connect("hubbard.freenode.net");

		tx = new Texture("tiles.png");

		Console.putln("start");
		glViewport(0, 0, getWidth(), getHeight());

		glMatrixMode(GL_PROJECTION);
		glLoadIdentity();

		// Calculate Aspect Ratio
		//gluPerspective(45.0f, cast(GLfloat)getWidth() / cast(GLfloat)getHeight(), 0.1f, 100.0f);

		glMatrixMode(GL_MODELVIEW);
		glLoadIdentity();

		glShadeModel(GL_SMOOTH);

		glClearColor(0.0f, 0.0f, 0.0f, 0.0f);

		glClearDepth(1.0f);
		glEnable(GL_DEPTH_TEST);
		glDepthFunc(GL_LEQUAL);

		glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);

		setUpView();

		//useTexture(tx, 3);

		bindTexture(tx);
	}

	void setUpView()
	{
		glViewport(0, 0, getWidth(), getHeight());         // reset viewport
		glMatrixMode(GL_PROJECTION);    // add perspective to scene
		glLoadIdentity();               // restore matrix to original state

		double nRange = 1.0;

		{
			glOrtho (0, nRange, 0, nRange, -nRange, nRange);
		}


		glClearColor(0.0f, 0.0f, 0.0f, 1.0f);  	// clear background to black
		glClearDepth(100.0);            // set depth buffer to the most distant value
	    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	    glMatrixMode(GL_MODELVIEW);

		enableTextures();
	}

	void OnResize()
	{
		setUpView();
	}

	void OnPrimaryMouseDown()
	{
		x = mouseProps.x;
		y = mouseProps.y;

		xv *= 2;
		yv *= 2;
	}

	double count = 0.0;
	int frames = 0;

	void OnDraw(double delta)
	{
		count += delta;
		frames++;
		if (count > 1.0)
		{
		Console.putln("fps: ", frames);
		frames = 0;
		count = 0;
		}

		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

		x += delta * xv;
		y += delta * yv;

		// collision detection

		if (x + tx.getFrameWidth() > cast(double)getWidth())
		{
			x = getWidth() - tx.getFrameWidth();

			xv *= -1;
		}

		if (y + tx.getFrameHeight() > cast(double)getHeight())
		{
			y = getHeight() - tx.getFrameHeight();

			yv *= -1;
		}

		if (x < 0.0)
		{
			x = 0;

			xv *= -1;
		}

		if (y < 0.0)
		{
			y = 0;
			yv *= -1;
		}
		                    // initialize drawing coordinates

		// enableTextures();

		renderTexture(x,y,0);

	}
}
//*/

class MyThread : Thread
{
	override void run()
	{
		String bugger;
		bugger.append("das");
	}
}

void InitWindow()
{
	MyWindow mainWindow;

	mainWindow = new MyWindow();
	mainWindow.setVisibility(true);

	Djehuty.addWindow(mainWindow);

	Directory testsDir = FileSystem.getApplicationDir;
//	Directory blah = testsDir.getParent();

	Directory blah = new Directory();

	testsDir = testsDir.traverse("tests");

//	File fle = new File("winsamp.d");
	//char[] str;
//	while(fle.readLine(str))
	//{
	//	Console.putln(str);
//	}

	foreach(file; blah.list())
	{
		Console.putln("'", file.array, "'");
	}
}

import scripting.lua;

extern(System) void DjehutyMain(Arguments args)
{
	Djehuty.setApplicationName("djehutyTestApp");

	Tests.testAll();

	Directory dir;

	dir = FileSystem.getTempDir();
	Console.putln("TEMP: ", dir.getPath.array);

	dir = FileSystem.getAppDataDir();
	Console.putln("APP:  ", dir.getPath.array);

	dir = FileSystem.getUserDataDir();
	Console.putln("USER: ", dir.getPath.array);

	Directory myDir = FileSystem.getApplicationDir();
	Console.putln(myDir.getPath.array);

	dir = FileSystem.getBinaryDir();
	Console.putln("BIN:  ", dir.getPath.array);

	LuaScript lua = new LuaScript();
	lua.evalFile("hello.lua");

Random rnd = new Random(-1);
Console.putln(rnd.next());
Console.putln(rnd.next());
Console.putln(rnd.next());
Console.putln(rnd.next());
Console.putln(rnd.next());

	InitWindow();
}