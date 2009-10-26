module utils.linkedlist;

import core.list;

// Section: Utils

// Description: This template class abstracts the queue data structure. T is the type you wish to store.
class LinkedList(T) : ListInterface!(T) {
	this() {
	}

	// add to the head

	// Description: Will add the data to the head of the list.
	// data: The information you wish to store.  It must correspond to the type of data you specified in the declaration of the class.
	void add(T data) {
		synchronized(this) {
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
	}

	// Description: Will add the list to the head of the list.
	// list: The class that interfaces the IList interface. All of the items will be copied over.
	void add(ListInterface!(T) list) {
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
			// XXX: Throw list exception
			return _nullValue();
		}

		return head.data;
	}

	T peekAt(size_t index) {
		synchronized(this) {
			if (index < _count) {
				if (index == 0) {
					return head.data;
				}

				LinkedListNode* curnode = null;

				if (last !is null) {
					uint cacheDistance;

					if (lastIndex < index) {
						cacheDistance = index - lastIndex;

						if (cacheDistance < index) {
							curnode = last;
							for ( ; cacheDistance >= 0; cacheDistance--) {
								curnode = curnode.next;
							}
						}
					}
					else {
						cacheDistance = lastIndex - index;

						if (cacheDistance < index) {
							curnode = last;

							for ( ; cacheDistance >= 0; cacheDistance--) {
								curnode = curnode.prev;
							}
						}
					}
				}

				if (curnode is null) {
					curnode = head;

					for ( ; index > 0; index--) {
						curnode = curnode.next;
					}
				}

				// keep cache of last accessed item
				last = curnode;
				lastIndex = index;

				return curnode.data;
			}

			return _nullValue();
		}
    }
		
	// remove the tail

	// Description: Will remove an item from the tail of the list, which would remove in a first-in-first-out ordering (FIFO).
	// data: Will be set to the data retreived.
	T remove() {
		synchronized(this) {
			if (tail == null) {
				// XXX: Throw list exception
				return _nullValue();
			}

			T data = tail.data;

			//tail.next = null;
			//tail.prev = null;

			if (head is tail) {
				// unlink all
				head = null;
				tail = null;
			}
			else {
				tail.prev.next = tail.next;
				tail.next.prev = tail.prev;
				tail = tail.prev;
			}

			_count--;

			return data;
		}
	}

	T remove(T item) {
		synchronized(this) {
			if (head is null) {
				// XXX: throw list exception
				return _nullValue();
			}

			LinkedListNode* curnode = null;

			curnode = head;
			do {
				if (curnode.data == item) {
					// remove this item

					if (head is tail) {
						// unlink all
						head = null;
						tail = null;
					}
					else {
						curnode.prev.next = curnode.next;
						curnode.next.prev = curnode.prev;
					}

					_count--;

					return item;
				}

				curnode = curnode.next;
			} while (curnode !is head);

			// XXX: Throw list exception
			return _nullValue();
		}
	}

	T removeAt(size_t index) {
		return _nullValue();
	}

	void clear() {
		synchronized(this) {
			_count = 0;
			tail = null;
			head = null;
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

			LinkedListNode* curnode = head;

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
			LinkedListNode* curnode = head;

			int ret;

			if (_count == 0) {
				return 0;
			}	

			while(curnode !is null) {
				ret = loopFunc(curnode.data);
				curnode = curnode.next;

				if (ret) { break; }
			}

			return ret;
		}
	}

	int opApply(int delegate(ref size_t, ref T) loopFunc) {
		synchronized(this) {
			LinkedListNode* curnode = head;

			int ret;
			size_t idx;

			if (_count == 0) {
				return 0;
			}	

			while(curnode !is null) {
				ret = loopFunc(idx, curnode.data);
				curnode = curnode.next;
				idx++;

				if (ret) { break; }
			}

			return ret;
		}
	}

	int opApplyReverse(int delegate(inout T) loopFunc) {
		synchronized(this) {
			LinkedListNode* curnode = tail;

			int ret;

			if (_count == 0) {
				return 0;
			}	

			while(curnode !is null) {
				ret = loopFunc(curnode.data);
				curnode = curnode.prev;

				if (ret) { break; }
			}

			return ret;
		}
	}

	int opApplyReverse(int delegate(inout size_t, inout T) loopFunc) {
		synchronized(this) {
			LinkedListNode* curnode = tail;

			int ret;
			size_t idx = _count - 1;

			if (_count == 0) {
				return 0;
			}	

			while(curnode !is null) {
				ret = loopFunc(idx, curnode.data);
				curnode = curnode.prev;
				idx--;

				if (ret) { break; }
			}

			return ret;
		}
	}
	
	size_t length() {
	   return _count;
	}

protected:

	// the contents of a node
	struct LinkedListNode {
		LinkedListNode* next;
		LinkedListNode* prev;
		T data;
	}

	// the head and tail of the list
	LinkedListNode* head = null;
	LinkedListNode* tail = null;

	// the last accessed node is cached
	LinkedListNode* last = null;
	size_t lastIndex = 0;

	// the number of items in the list
	size_t _count;

	// Returns a null value for T
	T _nullValue() {
		T val;
		return val;
	}
}
