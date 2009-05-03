module ast;

// *** import console.main;

// *** delete both
import std.stdio;
import std.string;

class AST
{
	this(AST left, AST right)
	{
		children[0] = left;
		children[1] = right;
	}
	
	void left(AST left)
	{
		children[0] = left;
	}
	
	void right(AST right)
	{
		children[1] = right;
	}
	
	AST left()
	{
		return children[0];
	}
	
	AST right()
	{
		return children[1];
	}

	void value(ulong val)
	{
		data.type = ValueType.Unsigned;
		data.value.unsigned = val;
	}
	
	void value(char[] s)
	{
		data.type = ValueType.String;
		data.value.str = s;
	}

	void hint(char[] s)
	{
		data.type = ValueType.Hint;
		data.value.str = s;
	}
	
	void name(char[] s)
	{
		data.type = ValueType.Name;
		data.value.str = s;
	}
	
	void walk(uint depth = 0)
	{
		static char[] spaces = "`---------------------------------------------------------------------------";
		if (data.type == ValueType.Hint)
		{
			// *** Console.putln(...);
			writefln(spaces[0..depth*2], "HINT: ", data.value.str, " [", left, ", ", right, "]");
		}
		else if (data.type == ValueType.Name)
		{
			// *** Console.putln(...);
			writefln(spaces[0..depth*2], data.value.str, " [", left, ", ", right, "]");
		}
		else
		{
			// *** Console.putln(...);
			writefln(spaces[0..depth*2], "\"", replace(data.value.str, "\n", " "), "\" [", left, ", ", right, "]");
		}
		if (left !is null) { left.walk(depth+1); }
		if (right !is null) { right.walk(depth+1); }
	}
	
	enum ValueType
	{
		Unsigned,
		Signed,
		Object,
		Pointer,
		String,
		Hint,
		Name
	}
	
	ValueType valueType()
	{
		return data.type;
	}
	
	void getValue(out char[] value)
	{
		value = data.value.str;
	}
	
	void getValue(out ulong value)
	{
		value = data.value.unsigned;
	}
	
protected:
	
	AST children[2];
	
	union valueHolder
	{
		ValueType type;
		values value;
	}
	
	struct values
	{
		ulong unsigned;
		long signed;
		Object object;
		void* pointer;
		char[] str;
		char[] hint;
	}
	
	valueHolder data;
}