module interfaces.container;

import gui.core;

// Section: Interfaces

// Description: Extending this class allows for the adding of controls.
interface AbstractContainer
{
	void removeControl(Widget control);
	Widget controlAtPoint(int x, int y);

	int getBaseX();
	int getBaseY();
}
