module specs.core.util;

import core.util;
import data.stack;
import data.list;
import interfaces.container;

describe util() {
	describe typeTemplates() {
		it should_determine_if_it_is_a_type () {
			should(IsType!(int));
			shouldNot(IsType!(int[]));
		}

		it should_determine_if_it_is_a_class() {
			should(IsClass!(Stack!(int)));
			shouldNot(IsClass!(int));
		}

		it should_determine_if_it_is_an_iterface() {
			should(IsInterface!(AbstractContainer));
			shouldNot(IsInterface!(int));
		}

		it should_determine_if_it_is_an_object() {
			shouldNot(IsObject!(int));
			should(IsObject!(Stack!(int)));
			should(IsObject!(AbstractContainer));
		}

		it should_determine_if_it_is_an_int_type() {
			should(IsIntType!(int));
			should(IsIntType!(uint));
			shouldNot(IsIntType!(int[]));
		}

		it should_determine_if_it_is_unsigned() {
			should(IsUnsigned!(uint));
			should(IsUnsigned!(ushort));
			should(IsUnsigned!(ulong));
			should(IsUnsigned!(ubyte));

			shouldNot(IsUnsigned!(int));
			shouldNot(IsUnsigned!(short));
			shouldNot(IsUnsigned!(long));
			shouldNot(IsUnsigned!(byte));
		}

		it should_determine_if_it_is_signed() {
			should(IsSigned!(int));
			should(IsSigned!(short));
			should(IsSigned!(long));
			should(IsSigned!(byte));

			shouldNot(IsSigned!(uint));
			shouldNot(IsSigned!(ushort));
			shouldNot(IsSigned!(ulong));
			shouldNot(IsSigned!(ubyte));
		}

		it should_determine_if_it_is_float() {
			should(IsFloat!(float));
			should(IsFloat!(double));
			should(IsFloat!(real));

			shouldNot(IsFloat!(int));
		}

		it should_determine_if_it_is_complex {
			should(IsComplex!(cfloat));
			should(IsComplex!(cdouble));
			should(IsComplex!(creal));

			shouldNot(IsComplex!(float));
		}

		it should_determine_if_it_is_imaginary {
			should(IsImaginary!(ifloat));
			should(IsImaginary!(idouble));
			should(IsImaginary!(ireal));

			shouldNot(IsImaginary!(float));
		}

		it should_determine_if_it_is_struct {
			shouldNot(IsStruct!(int));
		}

		it should_determine_if_it_is_array {
			should(IsArray!(int[]));
			shouldNot(IsArray!(int));
		}
		
		it should_determine_the_superclass {
			class A{}
			class B : A {}
			class C : B {}

			should(Super!(B).stringof == "A");
			should(Super!(C).stringof == "B");
		}

		it should_determine_the_interfaces {
			class A {}
			interface E {}
			interface F {}
			interface G {}
			class B : A,G {}
			class C : B,E,F {}

			should(Interfaces!(C).stringof == "(E, F)");
		}

		it should_determine_the_arraytype {
			should(ArrayType!(int[]).stringof == "int");
		}
	}

	describe stringTemplates {
		it should_capitalize_a_string {
			should(Capitalize!("string") == "String");
			should(Capitalize!("String") == "String");
		}

		it should_trim_whitespace_from_the_left {
			should(TrimL!("string") == "string");
			should(TrimL!("   string") == "string");
			should(TrimL!("string   ") == "string   ");
			should(TrimL!("   string   ") == "string   ");

			should(TrimL!("\t\n\rstring") == "string");
			should(TrimL!("string\t\n\r") == "string\t\n\r");
			should(TrimL!("\t\n\rstring\t\n\r") == "string\t\n\r");
		}

		it should_trim_whitespace_from_the_right {
			should(TrimR!("string") == "string");
			should(TrimR!("   string") == "   string");
			should(TrimR!("string   ") == "string");
			should(TrimR!("   string   ") == "   string");

			should(TrimR!("\t\n\rstring") == "\t\n\rstring");
			should(TrimR!("string\t\n\r") == "string");
			should(TrimR!("\t\n\rstring\t\n\r") == "\t\n\rstring");
		}

		it should_remove_spaces {
			should(RemoveSpaces!("string") == "string");
			should(RemoveSpaces!(" s t r i n g ") == "string");
			should(RemoveSpaces!("\ts\nt\rr\ti\nn\rg") == "string");
		}
	}
}
