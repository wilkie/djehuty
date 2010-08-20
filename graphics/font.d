module graphics.font;

import platform.vars.font;

import Scaffold = scaffold.graphics;

import core.color;
import core.string;
import core.definitions;

class Font {
private:
	FontPlatformVars _pfvars;
public:
	this(string fontname, int fontsize, int weight, bool italic, bool underline, bool strikethru) {
		Scaffold.createFont(&_pfvars, fontname, fontsize, weight, italic, underline, strikethru);
	}

	~this() {
		Scaffold.destroyFont(&_pfvars);
	}

	Size measureString(string text) {
		Size sz;
		Scaffold.measureText(&_pfvars, text, sz);
		return sz;
	}

	// platform bullshits
	FontPlatformVars* platformVariables() {
		return &_pfvars;
	}
}
