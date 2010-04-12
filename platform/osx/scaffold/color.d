module scaffold.color;

import platform.osx.common;

import graphics.view;
import graphics.graphics;

import gui.window;
import core.string;
import io.file;
import core.color;

import core.main;

import core.definitions;


void ColorGetSystemColor(ref Color clr, SystemColor sysColorIndex) {
	switch (sysColorIndex) {
		case SystemColor.Window:
			//ColorSetValue(clr, 0x0);
			break;
		default: break;
	}
}

