module codecs.binary.codec;

import codecs.codec;

import interfaces.stream;

import core.string;

// Section: Interfaces

// Description: The interface to a binary codec.
class BinaryCodec : Codec
{
public:

	StreamData decode(AbstractStream stream, AbstractStream toStream)
	{
		return StreamData.Invalid;
	}

	override String getName()
	{
		return new String("Unknown Binary Codec");
	}
}
