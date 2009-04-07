module graphics.pen;

import platform.imports;
mixin(PlatformGenericImport!("vars"));
mixin(PlatformGenericImport!("definitions"));
mixin(PlatformScaffoldImport!());

import core.color;

import core.view;

class Pen
{

public:

	// Constructor
	this(Color clr)
	{
		Scaffold.createPen(&_pfvars, clr);
	}

	// Destructor
	~this()
	{
		Scaffold.destroyPen(&_pfvars);
	}

	// Sets color of a solid brush
	void setColor(Color clr)
	{
		Scaffold.destroyPen(&_pfvars);
		Scaffold.createPen(&_pfvars, clr);

		// when tied to a locked view, update the brush being used
		if (_view !is null)
		{
			ViewUpdatePen(_view);
		}
	}

private:

	PenPlatformVars _pfvars;

	// tied to a view?
	View _view; // will be null if no view is tied with it

}



PenPlatformVars* PenGetPlatformVars(ref Pen pen)
{
	return &pen._pfvars;
}

void PenSetView(ref Pen pen, ref View view)
{
	pen._view = view;
}

void PenNullView(ref Pen pen)
{
	pen._view = null;
}
