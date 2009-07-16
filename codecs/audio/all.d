module codecs.audio.all;

import io.audio;
import io.wavelet;

import core.time;
import core.literals;
import core.string;
import core.stream;

import codecs.codec;
import codecs.audio.codec;

version(NoWaveAudio) {
}
else {
	public import codecs.audio.wav : WAVCodec;
}

version(NoMp2Audio) {
}
else {
	public import codecs.audio.mp2 : MP2Codec;
}

// MP1
// MP3
// MP4
// AUD
// SND
// XM
// IT
// RA
// WMA
// OGG

template RunCodec(StringLiteral8 codec) {
	const char[] RunCodec = `
		audioCodec = new ` ~ codec ~ `Codec();
		
		pos = stream.position;

		if ((ret = audioCodec.decode(stream, buffer, wf)) != StreamData.Invalid) {
			return ret;
		}

		stream.position = pos;
	`;
}

StreamData runAllCodecs(ref AudioCodec audioCodec, Stream stream, Wavelet buffer, ref AudioInfo wf) {
	StreamData ret;
	ulong pos;
	
	version(NoWaveAudio) {
	}
	else {
		mixin(RunCodec!("WAV"));
	}

	version(NoMp2Audio) {
	}
	else {
		mixin(RunCodec!("MP2"));
	}

	audioCodec = null;
	return StreamData.Invalid;
}

// Codecs:
//mixin(CreateCodecArray!());

