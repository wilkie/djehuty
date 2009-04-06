module codecs.audio.all;

import interfaces.stream;
import core.audio;
import core.wavelet;

import codecs.codec;
import codecs.audio.codec;

import core.time;

import core.literals;
import core.string;

public import codecs.audio.wav : WAVCodec;
// MP1
public import codecs.audio.mp2 : MP2Codec;
// MP3
// MP4
// AUD
// SND
// XM
// IT
// RA
// WMA
// OGG

// template for creating a decoder array

template StringOfLastName(StringLiteral8 string, uint idx = string.length-1)
{
	static if (idx == 0)
	{
		const char[] StringOfLastName = string;
	}
	else
	{
		static if (string[idx] == '.')
		{
			const char[] StringOfLastName = string[idx+1..$];
		}
		else
		{
			const char[] StringOfLastName = StringOfLastName!(string, idx-1);
		}
	}
}

template AddAudioCodec(StringLiteral8 codec, uint idx = 0)
{
	static if (AudioCodec.tupleof.length == idx)
	{
		const char[] AddAudioCodec = ``;
	}
	else
	{
		static if (idx == 0)
		{
			const char[] AddAudioCodec =
				`{&` ~ codec ~ `Codec.`
				~ StringOfLastName!(AudioCodec.tupleof[idx].stringof) ~ `, `
				~ AddAudioCodec!(codec, idx+1) ~ `}, `;
		}
		else
		{
			const char[] AddAudioCodec = `&` ~ codec ~ `Codec.`
			~ StringOfLastName!(AudioCodec.tupleof[idx].stringof) ~ `, `
			~ AddAudioCodec!(codec, idx+1);
		}
	}
}

template CreateCodecArray()
{
	const char[] CreateCodecArray = `
		AudioCodec audioCodecs[] = [ `

		~ AddAudioCodec!("WAV")
		~ AddAudioCodec!("MP2")

		~ ` ]; `;
}

StreamData runAllCodecs(ref AudioCodec audioCodec, AbstractStream stream, Wavelet buffer, ref AudioInfo wf)
{
	StreamData ret;

	ulong pos = stream.getPosition();

	audioCodec = new WAVCodec();
	if ((ret = audioCodec.decode(stream, buffer, wf)) != StreamData.Invalid)
	{
		return ret;
	}

	stream.setPosition(pos);

	audioCodec = new MP2Codec();
	if ((ret = audioCodec.decode(stream, buffer, wf)) != StreamData.Invalid)
	{
		return ret;
	}

	audioCodec = null;
	return StreamData.Invalid;
}

// Codecs:
//mixin(CreateCodecArray!());

