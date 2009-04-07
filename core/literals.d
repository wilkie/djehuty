module core.literals;

static const char _lit_types[][] = ["char", "wchar", "dchar", "Char"];
static const char _lit_vals[][] = ["8", "16", "32", ""];

template _D2_Support_AddUTFInvariant()
{
	version(D_Version2)
	{
		const char[] _D2_Support_AddUTFInvariant =	`alias invariant(Char)[] StringLiteral;`;
	}
	else
	{
		const char[] _D2_Support_AddUTFInvariant =	`alias Char[] StringLiteral;`;
	}
}

/*
template _D2_Support_AddUTFCharInvariant(int idx)
{
	version(D_Version2)
	{
		const char[] _D2_Support_AddUTFCharInvariant =	`alias invariant(` ~ _lit_types[idx] ~ `) Char` ~ _lit_vals[idx] ~ `;`;
	}
	else
	{
		const char[] _D2_Support_AddUTFCharInvariant =	`alias ` ~ _lit_types[idx] ~ ` Char` ~ _lit_vals[idx] ~ `;`;
	}
}

mixin(_D2_Support_AddUTFCharInvariant!(0));
mixin(_D2_Support_AddUTFCharInvariant!(1));
mixin(_D2_Support_AddUTFCharInvariant!(2));
*/

template _D2_Support_AddUTF8Invariant()
{
	version(D_Version2)
	{
		const char[] _D2_Support_AddUTF8Invariant =	`alias invariant(char)[] StringLiteral8;`;
	}
	else
	{
		const char[] _D2_Support_AddUTF8Invariant =	`alias char[] StringLiteral8;`;
	}
}

template _D2_Support_AddUTF16Invariant()
{
	version(D_Version2)
	{
		const char[] _D2_Support_AddUTF16Invariant =	`alias invariant(wchar)[] StringLiteral16;`;
	}
	else
	{
		const char[] _D2_Support_AddUTF16Invariant =	`alias wchar[] StringLiteral16;`;
	}
}

template _D2_Support_AddUTF32Invariant()
{
	version(D_Version2)
	{
		const char[] _D2_Support_AddUTF32Invariant =	`alias invariant(dchar)[] StringLiteral32;`;
	}
	else
	{
		const char[] _D2_Support_AddUTF32Invariant =	`alias dchar[] StringLiteral32;`;
	}
}
mixin(_D2_Support_AddUTF8Invariant!());
mixin(_D2_Support_AddUTF16Invariant!());
mixin(_D2_Support_AddUTF32Invariant!());


template _D2_Support_AddUTF32CharInvariant()
{
	version(D_Version2)
	{
		const char[] _D2_Support_AddUTF32CharInvariant =	`alias invariant(dchar) CharLiteral32;`;
	}
	else
	{
		const char[] _D2_Support_AddUTF32CharInvariant =	`alias dchar CharLiteral32;`;
	}
}

template _D2_Support_AddUTF16CharInvariant()
{
	version(D_Version2)
	{
		const char[] _D2_Support_AddUTF16CharInvariant =	`alias invariant(wchar) CharLiteral16;`;
	}
	else
	{
		const char[] _D2_Support_AddUTF16CharInvariant =	`alias wchar CharLiteral16;`;
	}
}

template _D2_Support_AddUTF8CharInvariant()
{
	version(D_Version2)
	{
		const char[] _D2_Support_AddUTF8CharInvariant =	`alias invariant(char) CharLiteral8;`;
	}
	else
	{
		const char[] _D2_Support_AddUTF8CharInvariant =	`alias char CharLiteral8;`;
	}
}
mixin(_D2_Support_AddUTF8CharInvariant!());
mixin(_D2_Support_AddUTF16CharInvariant!());
mixin(_D2_Support_AddUTF32CharInvariant!());
