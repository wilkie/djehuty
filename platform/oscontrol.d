module platform.oscontrol;

import core.literals;

public import platform.imports;
mixin(PlatformGenericPublicImport!("oscontrol"));

template ToLower(char s)
{
	static if (s >= 'A' && s <= 'Z')
	{
		const char ToLower = s + 32;
	}
	else
	{
		const char ToLower = s;
	}
}

template ToLower(StringLiteral8 str)
{
	static if (str.length == 0)
	{
		const ToLower = "";
	}
	else
	{
		const ToLower = ToLower!(str[0]) ~ ToLower!(str[1..$]);
	}
}

template GetStructFieldName(StringLiteral8 structField, uint i)
{
	static if (i <= 0)
	{
		const char[] GetStructFieldName = "";
	}
	static if (structField[i] == '.')
	{
		const char[] GetStructFieldName = structField[i+1..$];
	}
	else
	{
		const char[] GetStructFieldName = GetStructFieldName!(structField, i-1);
	}
}

template PlatformControlGenerationMakeConstructorListThis(classCStrInfo, uint id = 0)
{
	static if (classCStrInfo.tupleof.length == id)
	{
		const char[] PlatformControlGenerationMakeConstructorListThis = ``;
	}
	else static if (classCStrInfo.tupleof.length - 1 == id)
	{
		const char[] PlatformControlGenerationMakeConstructorListThis =
		typeof(classCStrInfo.tupleof[id]).stringof ~ ` ` ~
			GetStructFieldName!(classCStrInfo.tupleof[id].stringof,classCStrInfo.tupleof[id].stringof.length-1);
	}
	else
	{
		const char[] PlatformControlGenerationMakeConstructorListThis =
		typeof(classCStrInfo.tupleof[id]).stringof ~ ` ` ~
			GetStructFieldName!(classCStrInfo.tupleof[id].stringof,classCStrInfo.tupleof[id].stringof.length-1) ~ `, ` ~
			PlatformControlGenerationMakeConstructorListThis!(classCStrInfo, id+1);
	}
}

template PlatformControlGenerationMakeConstructorListSuper(classCStrInfo, uint id = 0)
{
	static if (classCStrInfo.tupleof.length == id)
	{
		const char[] PlatformControlGenerationMakeConstructorListSuper = ``;
	}
	else static if (classCStrInfo.tupleof.length - 1 == id)
	{
		const char[] PlatformControlGenerationMakeConstructorListSuper =
		GetStructFieldName!(classCStrInfo.tupleof[id].stringof,classCStrInfo.tupleof[id].stringof.length-1);
	}
	else
	{
		const char[] PlatformControlGenerationMakeConstructorListSuper =
		GetStructFieldName!(classCStrInfo.tupleof[id].stringof,classCStrInfo.tupleof[id].stringof.length-1) ~ `, ` ~
			PlatformControlGenerationMakeConstructorListSuper!(classCStrInfo, id+1);
	}
}

template PlatformControlGenerationMakeConstructorList(classCStrInfo)
{
	const char[] PlatformControlGenerationMakeConstructorList = `
	this(` ~ PlatformControlGenerationMakeConstructorListThis!(classCStrInfo) ~ `)
	{
		super(` ~ PlatformControlGenerationMakeConstructorListSuper!(classCStrInfo) ~ `);
	}
	`;
}

template PlatformControlGeneration(StringLiteral8 className, StringLiteral8 classEvent)
{
	const char[] PlatformControlGeneration = `static if (mixin(PlatformTestControlStatus!("` ~ className ~ `")))
	{
		` ~ PlatformControlImport!(ToLower!(className)) ~ `
	}
	else
	{
		public
		{
			import Control` ~ className[2..$] ~ ` = controls.` ~ ToLower!(className)[2..$] ~ `;

			` ~ PlatformGenericImport!("definitions") ~ `

			import core.string;
			import core.control;

			class ` ~ className ~ ` : Control` ~ className[2..$] ~ `.` ~ className[2..$] ~ `
			{
				mixin(Control` ~ className[2..$] ~ `.ControlPrintCSTRList!());

				// support Events
				mixin(ControlAddDelegateSupport!("` ~ className ~ `", "Control` ~ className[2..$] ~ `.` ~ classEvent ~ `"));
			}
		}
	}`;

}


template PlatformControlGenerationEventless(StringLiteral8 className)
{
	const char[] PlatformControlGenerationEventless = `static if (mixin(PlatformTestControlStatus!("` ~ className ~ `")))
	{
		` ~ PlatformControlImport!(ToLower!(className)) ~ `
	}
	else
	{
		import ` ~ className ~ `_SCOPE = controls.` ~ ToLower!(className)[2..$] ~ `;

		` ~ PlatformGenericImport!("definitions") ~ `

		import core.string;
		import core.control;

		class ` ~ className ~ ` : ` ~ className ~ `_SCOPE.` ~ className[2..$] ~ `
		{
			//pragma(msg, "` ~ className ~ `");
			mixin(` ~ className ~ `_SCOPE.ControlPrintCSTRList!());
		}

	}`;
}
