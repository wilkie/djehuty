module decoders.image.all;

import graphics.bitmap;

import core.string;
import core.stream;

import io.console;

import decoders.decoder;
import decoders.image.decoder;

public import decoders.image.png;
public import decoders.image.bmp;
public import decoders.image.gif;
public import decoders.image.jpeg;
// TIFF
// TGA
// JPEG 2000
// MNG
// PCX
// RAW
StreamData runAllDecoders(ref ImageDecoder imageCodec, Stream stream, ref Bitmap view) {
	StreamData ret;

	ulong pos = stream.position;

	imageCodec = new PNGDecoder();
	if ((ret = imageCodec.decode(stream, view)) != StreamData.Invalid) {
		return ret;
	}

	stream.position = pos;

	imageCodec = new BMPDecoder();
	if ((ret = imageCodec.decode(stream, view)) != StreamData.Invalid) {
		return ret;
	}

	stream.position = pos;

	imageCodec = new GIFDecoder();
	if ((ret = imageCodec.decode(stream, view)) != StreamData.Invalid) {
		return ret;
	}

	stream.position = pos;

	imageCodec = new JPEGDecoder();
	if ((ret = imageCodec.decode(stream, view)) != StreamData.Invalid) {
		return ret;
	}

	imageCodec = null;
	return StreamData.Invalid;
}

// Codecs:
//mixin(CreateCodecArray!());
//
