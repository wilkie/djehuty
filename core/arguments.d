module core.arguments;

import core.string;
import utils.arraylist;

import interfaces.list;

// Description: This class holds the command line arguments that were passed into the app and will aid in parsing them.
class Arguments : AbstractList!(String)
{
public:

	this()
	{
		_list = new ArrayList!(String)();
	}
	
	static Arguments getInstance()
	{
		if (appInstance is null)
		{
			appInstance = new Arguments();
		}
		
		return appInstance;
	}

	// Description: Adds a new node to the end of the list.
	// data: The data to store in the node.
	void addItem(String data)
	{
		_list.addItem(data);
	}

	void addList(AbstractList!(String) list)
	{
		_list.addList(list);
	}

	void addList(String[] list)
	{
		_list.addList(list);
	}

	String[] getList()
	{
		return _list.getList();
	}

    bool getItem(out String data, uint index)
    {
    	return _list.getItem(data,index);
    }

	bool setItem(String data, uint index)
	{
		return _list.setItem(data,index);
    }

	Iterator getIterator()
	{
		return _list.getIterator();
	}

	bool getItem(out String data, ref Iterator irate)
	{
		return _list.getItem(data, irate);
    }

	// Description: Removes the last piece of data and stores it in the parameter passed to it. It does so in a first-in-last-out ordering (FILO).
	// Returns: This function will return false when there are no items to return and indicates the list is empty.
	bool remove(out String data)
	{
		return _list.remove(data);
	}

	// Description: Removes the last piece of data and stores it in the parameter passed to it. It does so in a first-in-last-out ordering (FILO).
	// Returns: This function will return false when there are no items to return and indicates the list is empty.
	bool remove(out String data, uint index)
	{
		return _list.remove(data,index);
	}

	uint length()
	{
	   return _list.length();
	}

protected:

	ArrayList!(String) _list;
	
	static Arguments appInstance;
}