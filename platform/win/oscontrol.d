/*
 * oscontrol.d
 *
 * This file gives the hint to whether or not a control has been implemented.
 *
 * Author: Dave Wilkinson
 *
 */

module platform.win.oscontrol;

import core.literals;

template PlatformTestControlStatus(StringLiteral8 ControlName)
{
	static if (ControlName == "OSButton")
	{
		const char[] PlatformTestControlStatus = `true`;
	}
	else
	{
		const char[] PlatformTestControlStatus = `false`;
	}
}