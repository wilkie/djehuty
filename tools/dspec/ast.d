module ast;

import core.string;
import console.main;

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

	void value(String s)
	{
		data.type = ValueType.String;
		data.value.str = new String(s);
	}

	void hint(String s)
	{
		data.type = ValueType.Hint;
		data.value.str = new String(s);
	}

	void name(String s)
	{
		data.type = ValueType.Name;
		data.value.str = new String(s);
	}
	
	void walk(uint depth = 0)
	{
		static char[] spaces = "`---------------------------------------------------------------------------";
		if (data.type == ValueType.Hint)
		{
			// *** Console.putln(...);
			Console.putln(spaces[0..depth*2], "HINT: ", data.value.str.array, " [", left, ", ", right, "]");
			//writefln(spaces[0..depth*2], "HINT: ", data.value.str.array, " [", left, ", ", right, "]");
		}
		else if (data.type == ValueType.Name)
		{
			// *** Console.putln(...);
			Console.putln(spaces[0..depth*2], data.value.str.array, " [", left, ", ", right, "]");
			//writefln(spaces[0..depth*2], data.value.str.array, " [", left, ", ", right, "]");
		}
		else
		{
			// *** Console.putln(...);
			Console.putln(spaces[0..depth*2], "\"", data.value.str.replace('\n', ' '), "\" [", left, ", ", right, "]");
			//writefln(spaces[0..depth*2], "\"", replace(data.value.str.array, "\n", " "), "\" [", left, ", ", right, "]");
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
	
	void getValue(out String value)
	{
		value = new String(data.value.str);
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
		String str;
		String hint;
	}
	
	valueHolder data;
}