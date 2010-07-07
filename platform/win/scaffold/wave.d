/*
 * wave.d
 *
 * This file implements the Scaffold for platform specific Wave
 * operations in Windows.
 *
 * Author: Dave Wilkinson
 *
 */

module scaffold.wave;

pragma(lib, "winmm.lib");

import binding.win32.windef;
import binding.win32.mmsystem;
import binding.win32.winbase;

import platform.win.main;

import platform.vars.wave;

import core.stream;
import core.time;
import core.main;
import core.definitions;
import core.string;

import synch.thread;
import synch.semaphore;

import io.audio;
import io.console;

// Worker Thread
extern(Windows)
DWORD waveOutThread(void* udata) {
	WavePlatformVars* waveVars = cast(WavePlatformVars*)udata;

//	Console.putln("running!");

	for (;;) {
		//Console.putln("Work Thread : Wait");
		if (WaitForSingleObject(waveVars.event, INFINITE) == WAIT_OBJECT_0) {
		}

		if (waveVars.isClosed) {
			// notify main thread that the thread has closed
			SetEvent(waveVars.closeLock);

			break;
		}

		//Console.putln("Work Thread : Entering Critical Section");
		WaitForSingleObject(waveVars.queueLock, INFINITE);

		// remove from the queue
		//Console.putln("Work Thread : Removing : ", &waveVars.curQueueNode.waveHeader);

		// mark the current node as not in use
		waveVars.curQueueNode.inUse = false;

		waveOutUnprepareHeader(waveVars.waveOut, &waveVars.curQueueNode.waveHeader, WAVEHDR.sizeof);

		bool wasLast = waveVars.curQueueNode.isLast;

		// unlock
		//Console.putln("Work Thread : Leaving Critical Section");
		ReleaseSemaphore(waveVars.queueLock, 1, null);

		if (!wasLast && !waveVars.isClosed) {
			//Console.putln("Work Thread : Callback");
			WaveFireCallback(waveVars.wave);
		}
		else {
			// last
			//Console.putln("Work Thread : End");
		}

		//Console.putln("Work Thread : Returned");
	}

	//Console.putln("Work Thread : Death");

	return 0;
}

// Callback routine to queue the next stuffs
extern(Windows)
void waveOutProc(HWAVEOUT wOut, UINT uMsg, DWORD dwInstance, DWORD p1, DWORD p2) {
	WavePlatformVars* waveVars = cast(WavePlatformVars*)dwInstance;

	WAVEHDR* waveHeader = cast(WAVEHDR*)p1;

	if (uMsg == MM_WOM_OPEN) {
		//Console.putln("Driver Thread : WOM_OPEN");
		waveVars.isClosed = false;
		waveVars.inited = true;
	}
	else if (uMsg == MM_WOM_DONE) {
	//	Console.putln("Driver Thread : WOM_DONE");

		// get the node from the buffer queue

		if (!waveVars.isClosed) {
			// allow the thread to call waveOutWrite
			waveVars.curQueueNode = cast(WavePlatformVars.BufferNode*)waveHeader.dwUser;

		//	Console.putln("Driver Thread : Calling Work Thread");
			SetEvent(waveVars.event);
		}
		else {
		//	Console.putln("Driver Thread: NOT Calling Work Thread");
		}

	//	Console.putln("Driver Thread : Continuing");
	}
	else if (uMsg == MM_WOM_CLOSE) {
		//Console.putln("Driver Thread : WOM_CLOSE");

		// notify main thread that the device has closed
		SetEvent(waveVars.closeLock);
	}
//	Console.putln("Driver Thread : Returning");
}

void WaveOpenDevice(ref Audio wave, ref WavePlatformVars waveVars, ref AudioFormat wf) {
	if (waveVars.inited) { return; }

	waveVars.queueLock = CreateSemaphoreA(null, 1, 0xFFFFFFF, null);

	waveVars.wfx.wFormatTag = cast(ushort)wf.compressionType;
	waveVars.wfx.nChannels = cast(ushort)wf.numChannels;
	waveVars.wfx.nSamplesPerSec = wf.samplesPerSecond;
	waveVars.wfx.nAvgBytesPerSec = wf.averageBytesPerSecond;
	waveVars.wfx.nBlockAlign = cast(ushort)wf.blockAlign;
	waveVars.wfx.wBitsPerSample = cast(ushort)wf.bitsPerSample;

	waveVars.wave = wave;
	waveVars.event = CreateEventW(null, FALSE, FALSE, null);
	waveVars.isClosed = false;

	waveVars.thread = CreateThread(null, 0, &waveOutThread, cast(void*)&waveVars, 0, &waveVars.threadID);

	// opening a wave device, passing the Audio class to the callback routine
	if (true) {
//		Console.putln("ERROR: cannot open wave device", " : ", 
		waveOutOpen(&waveVars.waveOut, WAVE_MAPPER, &waveVars.wfx, cast(DWORD_PTR)&waveOutProc, cast(DWORD)&waveVars, CALLBACK_FUNCTION);
	}
}

void WaveCloseDevice(ref Audio wave, ref WavePlatformVars waveVars) {
	if (waveVars.isClosed) { return; }

	// kill any threads
	if (waveVars.threadID != 0) {
		Console.putln("Audio : Cleanup");

		Console.putln("Audio : Initiating Device Close");

		WaitForSingleObject(waveVars.queueLock, INFINITE);
		waveVars.isClosed = true;

		waveVars.closeLock = CreateEventW(null, FALSE, FALSE, null);

		Console.putln("Audio : Reseting the Device");
		waveOutReset(waveVars.waveOut);

		Console.putln("Audio : Closing the Device");
		waveOutClose(waveVars.waveOut);

		Console.putln("Audio : Waiting for closeLock");
		WaitForSingleObject(waveVars.closeLock, INFINITE);

		Console.putln("Audio : Calling Work Thread");
		if ( SetEvent(waveVars.event) == 0 ) {
	        throw new Exception(format("SetEvent failed ({d})\n",GetLastError()));
	        //return;
	    }

		// hopefully run event and kill thread
		SetEvent(waveVars.event);

		// wait until thread is dead
		Console.putln("Audio : Waiting for closeLock (from Thread)");
		WaitForSingleObject(waveVars.closeLock, INFINITE);

		// remove the rest of the queued buffers
		for(uint i = 0; i < waveVars.buffers.length; i++) {
			if (waveVars.buffers[i].inUse) {
				waveOutUnprepareHeader(waveVars.waveOut, &waveVars.buffers[i].waveHeader, WAVEHDR.sizeof);
				waveVars.buffers[i] = WavePlatformVars.BufferNode.init;
			}
		}

		CloseHandle(waveVars.event);
		CloseHandle(waveVars.queueLock);
		CloseHandle(waveVars.closeLock);

		waveVars.inited = false;

		Console.putln("Audio : Done");
	}
}

void WaveSendBuffer(ref Audio wave, ref WavePlatformVars waveVars, Stream waveBuffer, bool isLast) {
	if (waveVars.isClosed) { return; }

	// make a new waveHeader structure
	// add it to the wave header queue

	// be sure to lock the queue before adding!
	WaitForSingleObject(waveVars.queueLock, INFINITE);

	// new queue node
	WavePlatformVars.BufferNode* queueNode;

	for(uint i = 0; i < waveVars.buffers.length; i++) {
		if (waveVars.buffers[i].inUse == false) {
			queueNode = &waveVars.buffers[i];
			break;
		}
	}

	if (queueNode is null) {
		// too many buffers
		// throw exception?
		ReleaseSemaphore(waveVars.queueLock, 1, null);
		return;
	}

	// mark the current node as in use
	queueNode.inUse = true;
	queueNode.isLast = isLast;

	//Console.putln("creating: ", &queueNode.waveHeader);

	// retain the buffer so it does not get garbage collected
	queueNode.waveBuffer = waveBuffer;

	// set the node to the userdata of the buffer
	// so it can be cleared and collected
	// when the buffer is finished
	queueNode.waveHeader.dwUser = cast(DWORD_PTR)queueNode;



	// set the buffer
	queueNode.waveHeader.lpData = waveBuffer.contents().ptr;
	queueNode.waveHeader.dwBufferLength = cast(uint)waveBuffer.length();




	// prepare the header
	waveOutPrepareHeader(waveVars.waveOut, &queueNode.waveHeader, WAVEHDR.sizeof);

	// Console.put it to the device
	waveOutWrite(waveVars.waveOut, &queueNode.waveHeader, WAVEHDR.sizeof);




	//Console.putln("yep: ", &queueNode.waveHeader);

	// unlock the buffer queue
	ReleaseSemaphore(waveVars.queueLock, 1, null);
}

void WaveResume(ref Audio wave, ref WavePlatformVars waveVars) {
	if (waveVars.isClosed) { return; }

	waveOutRestart(waveVars.waveOut);

	SetEvent(waveVars.resumeEvent);
}

void WavePause(ref Audio wave, ref WavePlatformVars waveVars) {
	if (waveVars.isClosed) { return; }

	waveOutPause(waveVars.waveOut);
}



Time WaveGetPosition(ref Audio wave, ref WavePlatformVars waveVars) {
	if (waveVars.isClosed) { Time myTime = new Time(0); return myTime; }

	MMTIME mmTime;

	mmTime.wType = TIME_BYTES;

	waveOutGetPosition(waveVars.waveOut, &mmTime, MMTIME.sizeof);

	Time retTime;
	long ret;

	ret = cast(long)((cast(float)mmTime.u.cb / cast(float)waveVars.wfx.nAvgBytesPerSec) * 1000.0);
	retTime.milliseconds(ret);
	return retTime;
}

bool WaveIsOpen(ref Audio wave, ref WavePlatformVars waveVars) {
	return !waveVars.isClosed;
}
