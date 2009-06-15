module utils.linkedlist;

import interfaces.list;

import core.semaphore;

import std.stdio;

// Section: Utils

// Description: This template class abstracts the queue data structure. T is the type you wish to store.
class LinkedList(T) : AbstractList!(T)
{
	this() {
		lock = new Semaphore(1);
	}

	// add to the head

	// Description: Will add the data to the head of the list.
	// data: The information you wish to store.  It must correspond to the type of data you specified in the declaration of the class.
	void addItem(T data)
	{
		lock.down();
		scope(exit) lock.up();

		LinkedListNode* newNode = new LinkedListNode;
		newNode.data = data;

		if (head is null)
		{
			head = newNode;
			tail = newNode;

			newNode.next = newNode;
			newNode.prev = newNode;
		}
		else
		{
			newNode.next = head;
			newNode.prev = tail;

			head.prev = newNode;
			tail.next = newNode;

			head = newNode;
		}

		_count++;
	}

	// Description: Will add the list to the head of the list.
	// list: The class that interfaces the IList interface. All of the items will be copied over.
	void addList(AbstractList!(T) list)
	{
		Iterator irate = list.getIterator();

		T data;

		while(list.getItem(data, irate))
		{
			addItem(data);
		}
	}

	void addList(T[] list)
	{
		foreach(item; list)
		{
			addItem(item);
		}
	}

	bool getItem(out T data, uint index)
	{
		lock.down();
		scope(exit) lock.up();

		if (index < _count)
		{
			if (index == 0)
			{
				data = head.data;
				return true;
			}

			LinkedListNode* curnode = null;

			if (last !is null)
			{
				uint cacheDistance;

				if (lastIndex < index)
				{
					cacheDistance = index - lastIndex;

					if (cacheDistance < index)
					{
						curnode = last;
						for ( ; cacheDistance >= 0; cacheDistance--)
						{
							curnode = curnode.next;
						}
					}
				}
				else
				{
					cacheDistance = lastIndex - index;

					if (cacheDistance < index)
					{
						curnode = last;

						for ( ; cacheDistance >= 0; cacheDistance--)
						{
							curnode = curnode.prev;
						}
					}
				}
			}

			if (curnode is null)
			{
				curnode = head;

				for ( ; index > 0; index--)
				{
					curnode = curnode.next;
				}
	        }

            data = curnode.data;

            // keep cache of last accessed item
            last = curnode;
            lastIndex = index;

            return true;
        }

        return false;
    }

	Iterator getIterator()
	{
		lock.down();
		scope(exit) lock.up();

		Iterator irate = new Iterator;
		irate.irate_int = 0;
		irate.irate_cnt = 0;
		irate.irate_ptr = head;

		return irate;
	}

	bool getItem(out T data, ref Iterator irate)
	{
		lock.down();
		scope(exit) lock.up();

		writefln("getItem");
		if (irate.irate_ptr !is null)
		{
		writefln("item got");
			data = (cast(LinkedListNode*)irate.irate_ptr).data;
			if ((cast(LinkedListNode*)irate.irate_ptr).next is head) {
		writefln("null");
				irate.irate_ptr = null;
			}
			else {
				irate.irate_ptr = cast(void*)(cast(LinkedListNode*)irate.irate_ptr).next;
			}
			return true;
		}
		return false;
    }

	// remove the tail

	// Description: Will remove an item from the tail of the list, which would remove in a first-in-first-out ordering (FIFO).
	// data: Will be set to the data retreived.
	bool remove(out T data)
	{
		lock.down();
		scope(exit) lock.up();

		if (tail == null) {
			return false;
		}

		data = tail.data;

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
			tail.prev.next = tail.next;
			tail.next.prev = tail.prev;
			tail = tail.prev;
		}

		_count--;

		return true;
	}

	bool removeItem(T item) {

		lock.down();
		scope(exit) lock.up();

		if (head is null) { return false; }

		LinkedListNode* curnode = null;

		curnode = head;
		do {
			if (curnode.data == item) {
				// remove this item

				if (head is tail)
				{
					// unlink all
					head = null;
					tail = null;
				}
				else
				{
					curnode.prev.next = curnode.next;
					curnode.next.prev = curnode.prev;
				}
		
				_count--;

				return true;
			}

			curnode = curnode.next;
		} while (curnode !is head);

        return false;
	}

	bool remove()
	{
		lock.down();
		scope(exit) lock.up();
		
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

	T opIndex(size_t i1)
	{
		T ret;
		getItem(ret, i1);

		return ret;
	}

	int opIndexAssign(T value, size_t i1)
	{
		return 0;
    }
    
    T[] opSlice() {

    	writefln("boo");
		T[] ret;
		T obj;

		Iterator i = getIterator();
    	writefln("boo!!!");

		while(getItem(obj, i))
		{
    		writefln("iterate");
			ret ~= obj;
		}

		return ret;
    }

	int opApply(int delegate(inout T) loopFunc)
	{
		int ret;
		T obj;

		Iterator i = getIterator();

		while(getItem(obj, i))
		{
			//Console.putln("blarg");
			writefln("blarg");
			ret = loopFunc(obj);
			if (ret) { break; }
		}

		return ret;
	}

	int opApply(int delegate(inout int, inout T) loopFunc)
	{
		int ret;
		T obj;

		Iterator i = getIterator();
		int idx = 0;

		while(getItem(obj, i))
		{
			ret = loopFunc(idx, obj);
			idx++;
			if (ret) { break; }
		}

		return ret;
	}

	uint length()
	{
	   return _count;
	}

protected:

	// the contents of a node
	struct LinkedListNode
	{
		LinkedListNode* next;
		LinkedListNode* prev;
		T data;
	}

	// the head and tail of the list
	LinkedListNode* head = null;
	LinkedListNode* tail = null;

	// the last accessed node is cached
	LinkedListNode* last = null;
	uint lastIndex = 0;

	// the number of items in the list
	uint _count;
	
	Semaphore lock;
}
