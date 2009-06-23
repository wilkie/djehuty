module gui.oscontrol;

import platform.oscontrol;
import interfaces.list;


// Section: Controls


//mixin(PlatformControlGeneration!("OSButton", "Button.Event"));
mixin(PlatformControlGenerationEventless!("OSButton"));

//documentation interests:

/* ;

// Description: This control provides a platform specific push button (or defaults to the standard Button class).
// Image: osbutton_win.png
// Image: osbutton_vista.png
class OSButton : BaseButton
{
}

*/

mixin(PlatformControlGeneration!("OSHScrollBar", "ScrollEvent"));

/* ;

// Description: This control provides a platform specific horizontal scroll bar (or defaults to the standard HScrollBar class).
// Image: oshscrollbar_win.png
// Image: oshscrollbar_vista.png
class OSHScrollBar : BaseScroll
{
}

*/

mixin(PlatformControlGeneration!("OSVScrollBar", "ScrollEvent"));

/* ;

// Description: This control provides a platform specific vertical scroll bar (or defaults to the standard VScrollBar class).
// Image: osvscrollbar_win.png
// Image: osvscrollbar_vista.png
class OSVScrollBar : BaseScroll
{
}

*/

mixin(PlatformControlGeneration!("OSListBox", "ListBoxEvent"));

/* ;

// Description: This control provides a platform specific list selection box (or defaults to the standard ListBox class).
// Image: oslistbox_win.png
// Image: oslistbox_vista.png
class OSListBox : BaseListBox
{
}

*/

mixin(PlatformControlGeneration!("OSListField", "ListFieldEvent"));

/* ;

// Description: This control provides a platform specific dropdown list selection box (or defaults to the standard ListField class).
// Image: oslistfield_win.png
// Image: oslistfield_vista.png
class OSListField : BaseListField
{
}

*/

mixin(PlatformControlGeneration!("OSTextField", "TextFieldEvent"));

/* ;

// Description: This control provides a platform specific one line text field (or defaults to the standard TextField class).
// Image: ostextfield_win.png
// Image: ostextfield_vista.png
class OSTextField : BaseTextField
{
}

*/

mixin(PlatformControlGeneration!("OSToggleField", "ToggleFieldEvent"));

/* ;

// Description: This control provides a platform specific toggle field (or defaults to the standard ToggleField class).
// Image: ostogglefield_win.png
// Image: ostogglefield_vista.png
class OSToggleField : BaseToggleField
{
}

*/

mixin(PlatformControlGeneration!("OSTrackBar", "TrackBarEvent"));

/* ;

// Description: This control provides a platform specific track bar, also known as a slider (or defaults to the standard TrackBar class).
// Image: ostogglefield_win.png
// Image: ostogglefield_vista.png
class OSTrackBar : BaseTrackBar
{
}

*/

mixin(PlatformControlGenerationEventless!("OSProgressBar"));

/* ;

// Description: This control provides a platform specific progress bar (or defaults to the standard ProgressBar class).
// Image: ostogglefield_win.png
// Image: ostogglefield_vista.png
class OSProgressBar : BaseProgressBar
{
}

*/
