module codecs.image.all;

import interfaces.stream;
import core.view;

import codecs.codec;
import codecs.image.codec;

import core.literals;
import core.string;

import console.main;

public import codecs.image.png;
public import codecs.image.bmp;
public import codecs.image.gif;
public import codecs.image.jpeg;
// TIFF
// TGA
// JPEG 2000
// MNG
// PCX
// RAW

StreamData runAllCodecs(ref ImageCodec imageCodec, AbstractStream stream, ref View view)
{
	StreamData ret;

	ulong pos = stream.getPosition();

	imageCodec = new PNGCodec();
	if ((ret = imageCodec.decode(stream, view)) != StreamData.Invalid)
	{
		return ret;
	}

	stream.setPosition(pos);

	imageCodec = new BMPCodec();
	if ((ret = imageCodec.decode(stream, view)) != StreamData.Invalid)
	{
		return ret;
	}

	stream.setPosition(pos);

	imageCodec = new GIFCodec();
	if ((ret = imageCodec.decode(stream, view)) != StreamData.Invalid)
	{
		return ret;
	}

	stream.setPosition(pos);

	imageCodec = new JPEGCodec();
	if ((ret = imageCodec.decode(stream, view)) != StreamData.Invalid)
	{
		return ret;
	}

	imageCodec = null;
	return StreamData.Invalid;
}

// Codecs:
//mixin(CreateCodecArray!());
//
