module specs.core.util;

import core.util;
import utils.stack;
import core.list;
import interfaces.container;

describe util() {
	describe typeIdentification() {
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
	}
}
