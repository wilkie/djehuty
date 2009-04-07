module platform.win.oscontrol;

import core.literals;

template PlatformTestControlStatus(StringLiteral8 ControlName)
{
	static if (ControlName == "OSButton")
	{
		const char[] PlatformTestControlStatus = `true`;
	}
	else static if (ControlName == "OSTextField")
	{
		const char[] PlatformTestControlStatus = `true`;
	}
	else static if (ControlName == "OSHScrollBar")
	{
		const char[] PlatformTestControlStatus = `true`;
	}
	else static if (ControlName == "OSVScrollBar")
	{
		const char[] PlatformTestControlStatus = `true`;
	}
	else static if (ControlName == "OSListBox")
	{
		const char[] PlatformTestControlStatus = `true`;
	}
	else static if (ControlName == "OSListField")
	{
		const char[] PlatformTestControlStatus = `true`;
	}
	else static if (ControlName == "OSToggleField")
	{
		const char[] PlatformTestControlStatus = `true`;
	}
	else static if (ControlName == "OSProgressBar")
	{
		const char[] PlatformTestControlStatus = `true`;
	}
	else static if (ControlName == "OSTrackBar")
	{
		const char[] PlatformTestControlStatus = `true`;
	}
	else
	{
		const char[] PlatformTestControlStatus = `false`;
	}
}