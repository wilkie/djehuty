module platform.unix.oscontrol;

import core.literals;

template PlatformTestControlStatus(StringLiteral8 ControlName)
{
	static if (ControlName == "OSButton")
	{
		const char[] PlatformTestControlStatus = `false`;
	}
	else static if (ControlName == "OSSomeControl")
	{
		const char[] PlatformTestControlStatus = `false`;
	}
	else
	{
		const char[] PlatformTestControlStatus = `false`;
	}
}