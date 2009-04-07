module interfaces.container;

import core.control;

// Section: Interfaces

// Description: Extending this class allows for the adding of controls.
interface AbstractContainer
{
	void addControl(Control control);
	void removeControl(Control control);
	Control controlAtPoint(int x, int y);

	int getBaseX();
	int getBaseY();
}
