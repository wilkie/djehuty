module codecs.image.all;

import graphics.bitmap;

import core.string;
import core.stream;

import codecs.codec;
import codecs.image.codec;

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

StreamData runAllCodecs(ref ImageCodec imageCodec, Stream stream, ref Bitmap view) {
	StreamData ret;

	ulong pos = stream.position;

	imageCodec = new PNGCodec();
	if ((ret = imageCodec.decode(stream, view)) != StreamData.Invalid)
	{
		return ret;
	}

	stream.position = pos;

	imageCodec = new BMPCodec();
	if ((ret = imageCodec.decode(stream, view)) != StreamData.Invalid)
	{
		return ret;
	}

	stream.position = pos;

	imageCodec = new GIFCodec();
	if ((ret = imageCodec.decode(stream, view)) != StreamData.Invalid)
	{
		return ret;
	}

	stream.position = pos;

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
