/*
 * window.d
 *
 * This module implements a window extension that uses opengl
 *
 * Author: Dave Wilkinson
 *
 */

module opengl.window;

import gui.window;

import core.string;
import core.definitions;
import core.color;
import core.event;

import opengl.texture;

import binding.opengl.gl;

import platform.vars.window;

import scaffold.opengl;

class GLWindow : Window {
protected:

	// the texture coordinates currently in use
	GLdouble _tu0 = 0.0;
	GLdouble _tu1 = 0.0;
	GLdouble _tv0 = 0.0;
	GLdouble _tv1 = 0.0;

	Texture _bindedTexture;

	double _aspectRatio;

public:

	this(string windowTitle, WindowStyle windowStyle, int x, int y, int width, int height) {
		super(windowTitle, windowStyle, Color.Black, x, y, width, height);
	}
	
	// Events

	void onDraw(double deltaTime) {
	}

	// Methods to aid drawing?
	// Or perhaps a separate class that is passed to onDraw
	// Probably need a separate class to maintain the current context

	// Description: This function will bind the texture given.
	// tex: The Texture to bind.
	void bindTexture(Texture tex) {
		_bindedTexture = tex;
		glBindTexture(GL_TEXTURE_2D, tex.textureIndex());

		// texture mode
		//glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);

		// set the texture coordinates
		_tu0 = 0;
		_tu1 = 1;
		_tv0 = 0;
		_tv1 = 1;
	}

	// Description: This function will enable textures using glEnable.
	void enableTextures() {
		glEnable(GL_TEXTURE_2D);
	}

	// Description: This function will disable textures using glDisable.
	void disableTextures() {
		glDisable(GL_TEXTURE_2D);
	}

	// Description: This function will bind a section of a texture.
	// tex: The Texture to bind.
	// x1: The left.
	// y1: The top.
	// x2: The right.
	// y2: The bottom.
	void useTexture(Texture tex, int x1, int y1, int x2, int y2) {
		_tu0 = cast(double)x1 / cast(double)tex.width;
		_tv0 = cast(double)y1 / cast(double)tex.height;

		_tu1 = cast(double)x2 / cast(double)tex.width;
		_tv1 = cast(double)y2 / cast(double)tex.height;
	}

	// Description: This function will bind a frame from a texture.
	// tex: The Texture to bind.
	// frameIndex: The row-major index of the frame.
	void useTexture(Texture tex, int frameIndex) {
		int x,y;
		x = frameIndex % tex.numRows;
		y = frameIndex / tex.numRows;

		_tu0 = cast(double)x / cast(double)tex.numColumns;
		_tu1 = cast(double)(x+1) / cast(double)tex.numColumns;
		_tv0 = cast(double)y / cast(double)tex.numRows;
		_tv1 = cast(double)(y+1) / cast(double)tex.numRows;
	}


	// Description: This function will render a simple quad of size 1 at the origin.
	void renderQuad() {
		glBegin(GL_QUADS);
			glNormal3f(0,0,1);
			glTexCoord2f(_tu0, _tv0);
			glVertex4f(-0.5,0.5,0,1.0);

			glTexCoord2f(_tu1, _tv0);
			glVertex4f(0.5,0.5,0,1.0);

			glTexCoord2f(_tu1, _tv1);
			glVertex4f(0.5,-0.5,0,1.0);

			glTexCoord2f(_tu0, _tv1);
			glVertex4f(-0.5,-0.5,0,1.0);

		glEnd();
	}

	void renderWireQuad() {
	}

	void renderTexture(double x, double y, int frameIndex) {
		// render 1-1 texture

		glPushMatrix();

		glLoadIdentity();

		GLdouble xpos, ypos;

		// assumes -1 ... 1 window

		xpos = x / cast(double)this.width;

		ypos = 1.0 - (y / cast(double)this.height);

		GLdouble scalew, scaleh;

		int x1 = frameIndex % _bindedTexture.numRows;
		int y1 = frameIndex / _bindedTexture.numRows;

		scalew = cast(double)_bindedTexture.frameWidth / cast(double)this.width;
		scaleh = cast(double)_bindedTexture.frameHeight / cast(double)this.height;

		glTranslatef(xpos + (scalew/2), ypos - (scaleh/2), 0.0);
		glScalef(scalew, scaleh, 1.0);

		_tu0 = cast(double)x1 / cast(double)_bindedTexture.numColumns;
		_tu1 = cast(double)(x1+1) / cast(double)_bindedTexture.numColumns;
		_tv0 = cast(double)y1 / cast(double)_bindedTexture.numRows;
		_tv1 = cast(double)(y1+1) / cast(double)_bindedTexture.numRows;

		renderQuad();

		glPopMatrix();
	}
}
