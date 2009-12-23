module utils.linkedlist;

import core.list;
import core.exception;
import core.tostring;
import core.definitions;

// Section: Utils

// Description: This template class abstracts the queue data structure. T is the type you wish to store.
class LinkedList(T) : Listable!(T) {
	this() {
	}

	// add to the _head

	// Description: Will add the data to the head of the list.
	// data: The information you wish to store.  It must correspond to the type of data you specified in the declaration of the class.
	void add(T data) {
		synchronized(this) {
			LinkedListNode* newNode = new LinkedListNode;
			newNode.data = data;

			if (_head is null) {
				_head = newNode;
				_tail = newNode;

				newNode.next = newNode;
				newNode.prev = newNode;
			}
			else {
				newNode.next = _head;
				newNode.prev = _tail;

				_head.prev = newNode;
				_tail.next = newNode;

				_head = newNode;
			}

			_count++;
		}
	}

	// Description: Will add the list to the head of the list.
	// list: The class that interfaces the IList interface. All of the items will be copied over.
	void add(Listable!(T) list) {
		foreach(item; list) {
			add(item);
		}
	}

	void add(T[] list) {
		foreach(item; list) {
			add(item);
		}
	}

	T peek() {
		if (_count == 0) {
			throw new OutOfElements(this.classinfo.name);
		}

		return _head.data;
	}

	T peekAt(size_t index) {
		synchronized(this) {
			if (index >= _count) {
				throw new OutOfBounds(this.classinfo.name);
			}

			if (index == 0) {
				return _head.data;
			}

			LinkedListNode* curnode = null;

			if (_last !is null) {
				uint cacheDistance;

				if (_lastIndex < index) {
					cacheDistance = index - _lastIndex;

					if (cacheDistance < index) {
						curnode = _last;
						for ( ; cacheDistance >= 0; cacheDistance--) {
							curnode = curnode.next;
						}
					}
				}
				else {
					cacheDistance = _lastIndex - index;

					if (cacheDistance < index) {
						curnode = _last;

						for ( ; cacheDistance >= 0; cacheDistance--) {
							curnode = curnode.prev;
						}
					}
				}
			}

			if (curnode is null) {
				curnode = _head;

				for ( ; index > 0; index--) {
					curnode = curnode.next;
				}
			}

			// keep cache of _last accessed item
			_last = curnode;
			_lastIndex = index;

			return curnode.data;
		}
    }
		
	// remove the _tail

	// Description: Will remove an item from the tail of the list, which would remove in a first-in-first-out ordering (FIFO).
	// data: Will be set to the data retreived.
	T remove() {
		synchronized(this) {
			if (_tail == null) {
				throw new OutOfElements(this.classinfo.name);
			}

			T data = _tail.data;

			//_tail.next = null;
			//_tail.prev = null;

			if (_head is _tail) {
				// unlink all
				_head = null;
				_tail = null;
			}
			else {
				_tail.prev.next = _tail.next;
				_tail.next.prev = _tail.prev;
				_tail = _tail.prev;
			}

			_count--;

			return data;
		}
	}

	T remove(T item) {
		synchronized(this) {
			if (_head is null) {
				throw new OutOfElements(this.classinfo.name);
			}

			LinkedListNode* curnode = null;

			curnode = _head;
			do {
				if (curnode.data == item) {
					// remove this item

					if (_head is _tail) {
						// unlink all
						_head = null;
						_tail = null;
						_last = null;
						_lastIndex = 0;
					}
					else {
						curnode.prev.next = curnode.next;
						curnode.next.prev = curnode.prev;
				
						// nullify cached value, if it has been removed
						if (_last is curnode) {
							_last = null;
							_lastIndex = 0;
						}
					}

					_count--;

					return item;
				}

				curnode = curnode.next;
			} while (curnode !is _head);

			throw new ElementNotFound(this.classinfo.name);
		}
	}

	T removeAt(size_t index) {
		synchronized(this) {
			if (index >= _count) {
				throw new OutOfBounds(this.classinfo.name);
			}

			LinkedListNode* curnode = null;

			if (_last !is null) {
				uint cacheDistance;

				if (_lastIndex < index) {
					cacheDistance = index - _lastIndex;

					if (cacheDistance < index) {
						curnode = _last;
						for ( ; cacheDistance >= 0; cacheDistance--) {
							curnode = curnode.next;
						}
					}
				}
				else {
					cacheDistance = _lastIndex - index;

					if (cacheDistance < index) {
						curnode = _last;

						for ( ; cacheDistance >= 0; cacheDistance--) {
							curnode = curnode.prev;
						}
					}
				}
			}

			if (curnode is null) {
				curnode = _head;

				for ( ; index > 0; index--) {
					curnode = curnode.next;
				}
			}

			// curnode is the node to be removed
			T ret;
			ret = curnode.data;

			curnode.prev.next = curnode.next;
			curnode.next.prev = curnode.prev;

			// nullify cached value, if it has been removed
			if (_last is curnode) {
				_last = null;
				_lastIndex = 0;
			}

			_count--;

			if (_count == 0) {
				_tail = null;
				_head = null;
			}

			return ret;

		}
	}

	void clear() {
		synchronized(this) {
			_count = 0;
			_tail = null;
			_head = null;
			_last = null;
			_lastIndex = 0;
		}
	}

	bool empty() {
		return _count == 0;
	}

	T opIndex(size_t i1) {
		return peekAt(i1);
	}

	int opIndexAssign(T value, size_t i1) {
		return 0;
    }

	T[] array() {
		T[] items = new T[_count];
		size_t idx = 0;

		foreach(item; this) {
			items[idx] = item;
			idx++;
		}
		return items;
	}

	LinkedList!(T) dup() {
		LinkedList!(T) ret = new LinkedList!(T);
		foreach(item; this) {
			ret.add(item);
		}
		return ret;
	}

	LinkedList!(T) slice(size_t start, size_t end) {
		synchronized (this) {
			LinkedList!(T) ret = new LinkedList!(T);

			LinkedListNode* curnode = _head;

			if (_count == 0) {
				return ret;
			}	

			size_t idx = 0;
			while(curnode !is null && idx < start) {
				curnode = curnode.next;
				idx++;
			}

			while(curnode !is null && idx < end) {
				ret.add(curnode.data);
				curnode = curnode.next;
				idx++;
			}

			return ret;
		}
	}

	LinkedList!(T) reverse() {
		LinkedList!(T) ret = new LinkedList!(T);
		foreach_reverse(item; this) {
			ret.add(item);
		}
		return ret;
	}

    LinkedList!(T) opSlice() {
		return dup();
    }

	int opApply(int delegate(ref T) loopFunc) {
		synchronized(this) {
			LinkedListNode* curnode = _tail;

			int ret;

			if (_count == 0) {
				return 0;
			}

			do {
				ret = loopFunc(curnode.data);
				curnode = curnode.prev;

				if (ret) { break; }
			} while(curnode !is _tail);

			return ret;
		}
	}

	int opApply(int delegate(ref size_t, ref T) loopFunc) {
		synchronized(this) {
			LinkedListNode* curnode = _tail;

			int ret;
			size_t idx;

			if (_count == 0) {
				return 0;
			}

			do {
				ret = loopFunc(idx, curnode.data);
				curnode = curnode.prev;
				idx++;

				if (ret) { break; }
			} while(curnode !is _tail);

			return ret;
		}
	}

	int opApplyReverse(int delegate(inout T) loopFunc) {
		synchronized(this) {
			LinkedListNode* curnode = _head;

			int ret;

			if (_count == 0) {
				return 0;
			}

			do {
				ret = loopFunc(curnode.data);
				curnode = curnode.next;

				if (ret) { break; }
			} while(curnode !is _head);

			return ret;
		}
	}

	int opApplyReverse(int delegate(inout size_t, inout T) loopFunc) {
		synchronized(this) {
			LinkedListNode* curnode = _head;

			int ret;
			size_t idx = _count - 1;

			if (_count == 0) {
				return 0;
			}

			do {
				ret = loopFunc(idx, curnode.data);
				curnode = curnode.next;
				idx--;

				if (ret) { break; }
			} while(curnode !is _head);

			return ret;
		}
	}
	
	size_t length() {
	   return _count;
	}

	string toString() {
		synchronized(this) {
			LinkedListNode* curnode = _tail;

			if (_count == 0) {
				return "[]";
			}

			string str = "[";
			do {
				str ~= toStr(curnode.data) ~ ", ";
				curnode = curnode.prev;

			} while(curnode !is _tail);

			return str[0..$-2] ~ "]";
		}
	}

protected:

	// the contents of a node
	struct LinkedListNode {
		LinkedListNode* next;
		LinkedListNode* prev;
		T data;
	}

	// the _head and _tail of the list
	LinkedListNode* _head = null;
	LinkedListNode* _tail = null;

	// the _last accessed node is cached
	LinkedListNode* _last = null;
	size_t _lastIndex = 0;

	// the number of items in the list
	size_t _count;

	// Returns a null value for T
	T _nullValue() {
		T val;
		return val;
	}
}
