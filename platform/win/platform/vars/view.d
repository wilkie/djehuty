/*
 * view.d
 *
 * This module has the structure that is kept with a View class for Windows.
 *
 * Author: Dave Wilkinson
 * Originated: July 22th, 2009
 *
 */

module platform.vars.view;

import binding.win32.winnt;
import binding.win32.winuser;
import binding.win32.winbase;
import binding.win32.windef;
import binding.win32.wingdi;

import binding.win32.gdiplusgpstubs;
import binding.win32.gdiplustypes;
import binding.win32.gdiplusimaging;

struct ViewPlatformVars {
	// antialias
	bool aa;

	RECT bounds;
	HDC dc;
	
	GpImage* image;
	Rect rt;
	BitmapData bdata;

	void* bits;
	int length;

	int penClr;

	GpBrush* curBrush = null;
	GpPen* curPen = null;
	GpBrush* curTextBrush = null;
	GpFont* curFont = null;

	GpGraphics* g = null;

	_clipList clipRegions;
}

class _clipList {
	this() {
	}

	// make sure to delete the regions from the list
	~this() {
		HANDLE rgn;
		while(remove(rgn)) {
			DeleteObject(rgn);
		}
	}

	// add to the head

	// Description: Will add the data to the head of the list.
	// data: The information you wish to store.  It must correspond to the type of data you specified in the declaration of the class.
	void addItem(HANDLE data) {
		LinkedListNode* newNode = new LinkedListNode;
		newNode.data = data;

		if (head is null) {
			head = newNode;
			tail = newNode;

			newNode.next = newNode;
			newNode.prev = newNode;
		}
		else {
			newNode.next = head;
			newNode.prev = tail;

			head.prev = newNode;
			tail.next = newNode;

			head = newNode;
		}

		_count++;
	}

	// remove the tail

	// Description: Will remove an item from the tail of the list, which would remove in a first-in-first-out ordering (FIFO).
	// data: Will be set to the data retreived.
	bool remove(out HANDLE data) {
		if (tail == null) {
			return false;
		}

		data = tail.data;

		//tail.next = null;
		//tail.prev = null;

		if (head is tail) {
			// unlink all
			head = null;
			tail = null;
		}
		else {
			tail = tail.prev;
		}

		_count--;

		return true;
	}

	bool remove() {
		if (tail == null) {
			return false;
		}

		//tail.next = null;
		//tail.prev = null;

		if (head is tail)
		{
			// unlink all
			head = null;
			tail = null;
		}
		else
		{
			tail = tail.prev;
		}

		_count--;

		return true;
	}

	uint length() {
	   return _count;
	}

protected:

	// the contents of a node
	struct LinkedListNode {
		LinkedListNode* next;
		LinkedListNode* prev;
		HANDLE data;
	}

	// the head and tail of the list
	LinkedListNode* head = null;
	LinkedListNode* tail = null;

	// the last accessed node is cached
	LinkedListNode* last = null;
	uint lastIndex = 0;

	// the number of items in the list
	uint _count;
}
