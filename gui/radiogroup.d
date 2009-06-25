module gui.radiogroup;

import gui.widget;
import gui.togglefield;

import core.string;
import core.graphics;
import core.event;

// Description: This control provides a method of grouping together toggle fields to form a collection of mutually exclusive 'radio' fields.
class RadioGroup : Widget
{
public:
	this() {
		super(0,0,0,0);
	}

	override void OnAdd()
	{
		for (uint i = 0; i<_count; i++)
		{
			_window.push(_toggleFields[i]);
		}
	}

	override bool OnSignal(Dispatcher dsp, uint signal) {
		if (signal == ToggleField.Signal.Selected) {
			for (uint i = 0; i<_count; i++) {
				if (_toggleFields[i] !is dsp) {
					_toggleFields[i].unselect();
				}
			}
		}
		return false;
	}

	// Description: This function will add a toggle field control to the group.
	override void push(Dispatcher dsp) {
		if (cast(ToggleField)dsp !is null) {
		}
		else {
			// error
		}
	}

private:
	ToggleField _toggleFields[] = null;

	uint _capacity = 10;
	uint _count = 0;

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

		if (_window !is null)
		{
			_window.push(inctrl);
		}
	}
}
