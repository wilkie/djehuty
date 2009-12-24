module graphics.font;

import platform.vars.font;

import Scaffold = scaffold.graphics;

import core.color;
import core.string;
import core.definitions;

import graphics.view;

class Font {
	this(string fontname, int fontsize, int weight, bool italic, bool underline, bool strikethru) {
		Scaffold.createFont(&_pfvars, fontname, fontsize, weight, italic, underline, strikethru);
	}

	~this() {
		Scaffold.destroyFont(&_pfvars);
	}

private:

	package FontPlatformVars _pfvars;

	// tied to a view?
	package View _view; // will be null if no view is tied with it
}
