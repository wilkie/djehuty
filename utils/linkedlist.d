module utils.linkedlist;

import interfaces.list;

// Section: Utils

// Description: This template class abstracts the queue data structure. T is the type you wish to store.
class LinkedList(T) : AbstractList!(T)
{
	this()
	{
	}



	// add to the head

	// Description: Will add the data to the head of the list.
	// data: The information you wish to store.  It must correspond to the type of data you specified in the declaration of the class.
	void addItem(T data)
	{
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

	bool getItem(out T data, uint index)
	{
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
		Iterator irate = new Iterator;
		irate.irate_ptr = head;
		irate.irate_int = 0;
		irate.irate_cnt = 0;

		return irate;
	}

	bool getItem(out T data, ref Iterator irate)
	{
		if (irate.irate_ptr !is null)
		{
			irate.irate_ptr = cast(void*)(cast(LinkedListNode*)irate.irate_ptr).next;
			data = (cast(LinkedListNode*)irate.irate_ptr).data;
			return true;
		}
		return false;
    }

	// remove the tail

	// Description: Will remove an item from the tail of the list, which would remove in a first-in-first-out ordering (FIFO).
	// data: Will be set to the data retreived.
	bool remove(out T data)
	{
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
			tail = tail.prev;
		}

		_count--;

		return true;
	}

	bool remove()
	{
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
}
