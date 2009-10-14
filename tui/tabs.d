/*
 * tabs.d
 *
 * This module implements tabs of windows for TUI apps.
 *
 * Author: Lindsey Bieda
 * Originated: October 14th 2009
 *
 */

module tui.tabs;

import tui.widget;

import core.string;
import core.definitions;

import io.console;

import utils.arrylist;

class TuiTabs : TuiWidget {
	this(uint x, uint y, uint width, uint height) {
		super(x,y,width,height);
	}
	
}

