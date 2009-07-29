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
		images[0] = new Image("examples/MoreDucks/baby_ducks.png");
		images[1] = new Image("examples/MoreDucks/duckling.png");
		images[2] = new Image("examples/MoreDucks/ducks-cute.png");
	}

	override void onDraw(ref Graphics g) {
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
		super("OMG DUCKS",WindowStyle.Fixed,Color.Gray,0,0,360,347);
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
