module graphics.brush;

import platform.imports;
mixin(PlatformGenericImport!("vars"));
mixin(PlatformGenericImport!("definitions"));
mixin(PlatformScaffoldImport!());

import core.color;

import core.view;

class Brush
{

public:

	// Constructor
	this(Color clr)
	{
		Scaffold.createBrush(&_pfvars, clr);
	}

	// Destructor
	~this()
	{
		Scaffold.destroyBrush(&_pfvars);
	}

	// Sets color of a solid brush
	void setColor(Color clr)
	{
		Scaffold.destroyBrush(&_pfvars);
		Scaffold.createBrush(&_pfvars, clr);

		// when tied to a locked view, update the brush being used
		if (_view !is null)
		{
			ViewUpdateBrush(_view);
		}
	}

private:

	BrushPlatformVars _pfvars;

	// tied to a view?
	View _view; // will be null if no view is tied with it

}



BrushPlatformVars* BrushGetPlatformVars(ref Brush brsh)
{
	return &brsh._pfvars;
}

void BrushSetView(ref Brush brush, ref View view)
{
	brush._view = view;
}

void BrushNullView(ref Brush brush)
{
	brush._view = null;
}
