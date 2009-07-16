module codecs.audio.all;

import interfaces.stream;
import core.audio;
import core.wavelet;

import codecs.codec;
import codecs.audio.codec;

import core.time;

import core.literals;
import core.string;

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
		
		pos = stream.getPosition();

		if ((ret = audioCodec.decode(stream, buffer, wf)) != StreamData.Invalid) {
			return ret;
		}
		
		stream.setPosition(pos);
	`;
}

StreamData runAllCodecs(ref AudioCodec audioCodec, AbstractStream stream, Wavelet buffer, ref AudioInfo wf) {
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

