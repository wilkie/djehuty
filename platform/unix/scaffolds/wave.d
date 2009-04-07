module platform.unix.scaffolds.wave;

import platform.unix.vars;

import core.view;
import core.graphics;

import bases.window;
import core.window;
import core.string;
import core.file;
import core.stream;
import core.thread;
import core.semaphore;
import core.time;

import core.audio;

import core.main;

import core.definitions;


void WaveOpenDevice(ref Audio wave, ref WavePlatformVars waveVars, ref AudioFormat wf)
{
}

void WaveCloseDevice(ref Audio wave, ref WavePlatformVars waveVars)
{
}

void WaveSendBuffer(ref Audio wave, ref WavePlatformVars waveVars, Stream waveBuffer, bool isLast)
{
}

void WaveResume(ref Audio wave, ref WavePlatformVars waveVars)
{
}

void WavePause(ref Audio wave, ref WavePlatformVars waveVars)
{
}



Time WaveGetPosition(ref Audio wave, ref WavePlatformVars waveVars)
{
	Time tm;

	tm = tm.init;
	return tm;
}

bool WaveIsOpen(ref Audio wave, ref WavePlatformVars waveVars)
{
	return false;
}
