/*
 * wave.d
 *
 * This Scaffold holds the Wave implementations for the Linux platform
 *
 * Author: Dave Wilkinson
 *
 */

module platform.unix.scaffolds.wave;

import platform.unix.vars;

import core.string;
import core.stream;
import core.time;
import core.main;
import core.definitions;

import io.audio;

import synch.thread;
import synch.semaphore;

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
