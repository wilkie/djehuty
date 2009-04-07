module hashes.digest;

import core.string;

class Digest
{
public:
	this (uint[] newData...)
	{
		data = newData.dup;
	}

	uint[] data;

	String getString()
	{
		String ret = new String();
		for(int i=0; i<data.length; i++)
		{
			ret.append("%.8x", data[i]);
		}
		return ret;
	}

//	override string toString()
//	{
//		return getString().toString();
//	}

	// operator overloads

	bool equals(Digest compareTo)
	{
		if (data == compareTo.data)
		{
			return true;
		}

		return false;
	}

	// mathematical operator overloads
	override int opEquals(Object o)
	{
		if (cast(Digest)o !is null)
		{
			return equals(cast(Digest)o);
		}
		return 0;
	}
}
