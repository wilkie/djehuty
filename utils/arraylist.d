module utils.arraylist;

import interfaces.list;

// Section: Utils

// Description: This template class abstracts the stack data structure. T is the type you wish to store.
class ArrayList(T) : AbstractList!(T)
{
	this()
	{
		_list = new T[_capacity];
	}

	this(uint size)
	{
		_capacity = size;
		this();
	}

	// Description: Adds a new node to the end of the list.
	// data: The data to store in the node.
	void addItem(T data)
	{
		if (_count == _capacity)
		{
			_capacity *= 2;

			T tmp[] = new T[_capacity];

			tmp[0.._count] = _list[0.._count];

			_list = tmp;
		}

		_list[_count] = data;
		_count++;
	}

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
        if (index < _count)
        {
            data = _list[index];
            return true;
        }

        return false;
    }

	bool setItem(T data, uint index)
	{
		if (index < _count)
		{
			_list[index] = data;
			return true;
		}

        return false;
    }

	Iterator getIterator()
	{
		Iterator irate = new Iterator;
		irate.irate_ptr = null;
		irate.irate_int = 0;
		irate.irate_cnt = 0;

		return irate;
	}

	bool getItem(out T data, ref Iterator irate)
	{
		if (irate.irate_int < _count)
		{
			data = _list[cast(uint)irate.irate_int];
			irate.irate_int++;
			return true;
		}
		return false;
    }

	// Description: Removes the last piece of data and stores it in the parameter passed to it. It does so in a first-in-last-out ordering (FILO).
	// Returns: This function will return false when there are no items to return and indicates the list is empty.
	bool remove(out T data)
	{
		if (_count == 0) {
			return false;
		}

		_count--;
		data = _list[_count];

		return true;
	}

	T opIndex(size_t i1)
	{
		if (i1 < 0 || i1 > _count)
		{
			return _list[0];
		}

		return _list[i1];
	}

	int opIndexAssign(T value, size_t i1)
	{
		_list[i1] = value;

		return i1;
    }

	T[] opSlice()
	{
		return _list;
	}

	T[] opSlice(size_t start, size_t end)
	{
		return _list[start..end];
	}

	int opApply(int delegate(inout T) loopFunc)
	{
		int ret;

		for(int i = 0; i < _count; i++)
		{
			ret = loopFunc(_list[i]);
			if (ret) { break; }
		}

		return ret;
	}

	// Description: Removes the last piece of data and stores it in the parameter passed to it. It does so in a first-in-last-out ordering (FILO).
	// Returns: This function will return false when there are no items to return and indicates the list is empty.
	bool remove(out T data, uint index)
	{
		if (_count == 0) {
			return false;
		}

		if (index < _count)
		{
			data = _list[index];

			_count--;

			for (uint i=index; i<_count; i++)
			{
				_list[i] = _list[i+1];
			}
			return true;
		}


		return false;
	}

	void clear()
	{
		_list = new T[_capacity];
		_count = 0;
	}

	uint length()
	{
	   return _count;
	}

protected:

	T _list[] = null;
	uint _capacity = 10;
	uint _count = 0;
}

