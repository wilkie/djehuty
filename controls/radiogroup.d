module controls.radiogroup;

import core.control;
import core.string;
import core.graphics;

import controls.togglefield;

// Description: This control provides a method of grouping together toggle fields to form a collection of mutually exclusive 'radio' fields.
class RadioGroup : Control
{
public:

	override void OnAdd()
	{
		for (uint i = 0; i<_count; i++)
		{
			//writeln("hey!");
			//_toggleFields[i].setDelegate(&ControlProc);
			//writeln("hey!");
			_window.addControl(_toggleFields[i]);
		}
	}


	// Description: This function will add a toggle field control to the group.
	void addControl(ToggleField inctrl)
	{
		if (_toggleFields is null)
		{
			_toggleFields = new ToggleField[_capacity];
			_count = 0;
		}

		if (_capacity == _count)
		{
			ToggleField[] _tmp = _toggleFields;
			_capacity *= 2;
			_toggleFields = new ToggleField[_capacity];
			_toggleFields[0.._count] = _tmp[0.._count];
		}

		_toggleFields[_count] = inctrl;
		_count++;

		ToggleFieldSetGrouped(inctrl, true);

		inctrl.setDelegate(&ControlProc);

		if (_window !is null)
		{
			_window.addControl(inctrl);
		}
	}

private:

	void ControlProc(ToggleField ctrl, ToggleFieldEvent evt)
	{
		// go through each, and unselect, whilst keeping selected the current control

		for (uint i = 0; i<_count; i++)
		{
			if (_toggleFields[i] !is ctrl)
			{
				_toggleFields[i].unselect();
			}
		}
	}

	ToggleField _toggleFields[] = null;
	uint _capacity = 10;
	uint _count = 0;
}
