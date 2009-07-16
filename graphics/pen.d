module graphics.pen;

import platform.imports;
mixin(PlatformGenericImport!("vars"));
mixin(PlatformGenericImport!("definitions"));
mixin(PlatformScaffoldImport!());

import core.color;

import graphics.view;

class Pen {

public:

	// Constructor
	this(Color clr) {
		Scaffold.createPen(&_pfvars, clr);
	}

	// Destructor
	~this() {
		Scaffold.destroyPen(&_pfvars);
	}

	// Sets color of a solid brush
	void setColor(Color clr) {
		Scaffold.destroyPen(&_pfvars);
		Scaffold.createPen(&_pfvars, clr);

		// when tied to a locked view, update the brush being used
		if (_view !is null) {
			if (_view._locked)
			{
				_view._graphics.setPen(_view._pen);
			}
		}
	}

private:

	package PenPlatformVars _pfvars;

	// tied to a view?
	package View _view; // will be null if no view is tied with it

}