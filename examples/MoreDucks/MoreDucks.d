import djehuty;

import gui.application;
import gui.window;
import gui.button;
import gui.widget;

import io.console;

import graphics.graphics;
import resource.image;

class MyControl : Widget {
	this() {
		super(0,0,360,297);
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
	int curImage = 1;
}

class MyWindow : Window {
	this() {
		super("OMG DUCKS",WindowStyle.Fixed,Color.Gray,WindowPosition.Center,360,297);
	}

	override void onAdd() {
		push(imageBox = new MyControl());
		push(button = new Button(1,1,358,48,"MORE DUCKS!"));
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
	Button button;
	MyControl imageBox;
}

class MyApp : GuiApplication {
	// Start an application instance

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

int main() {
	auto app = new MyApp();
	app.run();
	return 0;
}
