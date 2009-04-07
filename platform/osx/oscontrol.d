module platform.osx.oscontrol;

import core.literals;

template PlatformTestControlStatus(StringLiteral8 ControlName)
{
	static if (ControlName == "OSBlehField")
	{
		const char[] PlatformTestControlStatus = `true`;
	}
	else
	{
		const char[] PlatformTestControlStatus = `false`;
	}
}