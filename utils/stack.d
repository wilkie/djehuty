module utils.stack;

import utils.arraylist;

class Stack(T) : ArrayList!(T)
{
	this()
	{
		super();
	}

	this(uint size)
	{
		super(size);
	}
	
	T pop()
	{
		T ret;
		remove(ret);
		
		return ret;
	}
	
	void push(T item)
	{
		addItem(item);
	}
	
	T peek()
	{
		T ret;
		getItem(ret, length-1);
		return ret;
	}
}