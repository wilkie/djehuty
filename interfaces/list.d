module interfaces.list;

// generic iterator class
class Iterator
{
	void* irate_ptr;
	ulong irate_int;
	ulong irate_cnt;
}

// Section: Interfaces

// Description: This abstract class represents operations to maintain a list of items.
interface AbstractList(T)
{
	void addItem(T item);
	void addList(AbstractList!(T) list);
	void addList(T[] list);

	bool getItem(out T item, uint index);

	Iterator getIterator();
	bool getItem(out T item, ref Iterator irate);

	uint length();

	bool remove(out T data);
}
