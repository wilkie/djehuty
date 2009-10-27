import djehuty;

import gui.application;
import gui.window;
import gui.button;
import gui.widget;
import gui.osbutton;

import graphics.graphics;
import resource.image;

class MyControl : Widget {
	this() {
		super(0,50,360,297);
	}

	override void onAdd() {
	}

	override void onDraw(ref Graphics g) {
		if (images[curImage] is null) {
			string path = "";
			switch(curImage) {
				case 0:
					path = "baby_ducks.png";
					break;
				case 1:
					path = "duckling.png";
					break;
				case 2:
				default:
					path = "ducks-cute.png";
					break;
			}
			images[curImage] = new Image("examples/MoreDucks/" ~ path);
		}
		g.drawImage(this.left,this.top,images[curImage]);
	}

	void nextImage() {
		if(curImage == images.length-1) {
			curImage = 0;
			return;
		}

		curImage++;
	}

private:
	Image[3] images;
	int curImage = 0;
}

class MyWindow : Window {
	this() {
		super("OMG DUCKS",WindowStyle.Fixed,Color.Gray,50,50,360,347);
	}

	override void onAdd() {
		push(button = new OSButton(0,0,360,50,"MORE DUCKS!"));
		push(imageBox = new MyControl());
	}

	override bool onSignal(Dispatcher d, uint signal) {
		if(d is button) {
			if(signal == Button.Signal.Selected) {
				imageBox.nextImage();
				redraw();
				return true;
			}
		}

		return false;
	}


private:
	OSButton button;
	MyControl imageBox;
}

class MyApp : GuiApplication {
	// Start an application instance
	static this() { new MyApp(); }

	override void onApplicationStart() {
		wnd = new MyWindow();
		wnd.visible = true;

		push(wnd);
	}

	override void onApplicationEnd() {
	}

private:
	MyWindow wnd;
}
